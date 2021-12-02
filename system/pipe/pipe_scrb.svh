//--------------------------------------------------------------------------------------------------------------------------------
// name : pipe_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_i)
`uvm_analysis_imp_decl(_o)

class pipe_scrb #(
      DW = 10
    , SIZE = 256
    , PIPE_CE = 0
) extends uvm_scoreboard;
    `uvm_component_param_utils(pipe_scrb #(DW, SIZE, PIPE_CE))
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

    uvm_analysis_imp_i #(raxi_seqi, pipe_scrb #(DW, SIZE, PIPE_CE)) raxi_aprt_i;
    uvm_analysis_imp_o #(raxi_seqi, pipe_scrb #(DW, SIZE, PIPE_CE)) raxi_aprt_o;

    raxi_seqi raxi_seqi_queue_i[$];
    raxi_seqi raxi_seqi_queue_o[$];

    // sim model
    sim_pipe #(
          .DW(DW)
        , .SIZE(SIZE)
        , .PIPE_CE(PIPE_CE)
    )                                   sim_pipe_h;

    // result
    pipe_seqi #(
          .DW(DW)
    )                                   pipe_seqi_i;
    pipe_seqi #(
          .DW(DW)
    )                                   pipe_seqi_o;
    bit data_good = 0;
    bit data_same = 0;
    int fail_cnt = 0;

    // functions
    extern virtual function void write_i(raxi_seqi raxi_seqi_h);
    extern virtual function void write_o(raxi_seqi raxi_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void pipe_scrb::build_phase(uvm_phase phase);
    raxi_aprt_i = new("raxi_aprt_i", this);
    raxi_aprt_o = new("raxi_aprt_o", this);

    `uvm_object_create(pipe_seqi #(DW), pipe_seqi_i);
    `uvm_object_create(pipe_seqi #(DW), pipe_seqi_o);

    `uvm_object_create(sim_pipe #(DW, SIZE, PIPE_CE), sim_pipe_h);
endfunction

function void pipe_scrb::write_i(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_i.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nPING... sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
endfunction

function void pipe_scrb::write_o(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_o.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\n...PONG sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
    processing();
endfunction

function void pipe_scrb::processing();
    raxi_seqi raxi_seqi_sim_i;
    raxi_seqi raxi_seqi_sim_o;
    raxi_seqi raxi_seqi_o;
    string data_str;

    raxi_seqi_sim_i = raxi_seqi_queue_i.pop_front();
    `uvm_object_create(raxi_seqi, raxi_seqi_sim_o);
    sim_pipe_h.simulate(raxi_seqi_sim_i, raxi_seqi_sim_o);
    raxi_seqi_o = raxi_seqi_queue_o.pop_front();

    // get data from rAXI
    pipe_seqi_i.raxi2this_i(raxi_seqi_sim_i);
    pipe_seqi_i.raxi2this_o(raxi_seqi_sim_o);
    pipe_seqi_o.raxi2this_o(raxi_seqi_o);

    data_good = 1;
    data_str = {
              "\n"
            , "input data  : ", pipe_seqi_i.i2string()
            , "\n"
            , "got from RTL: ", pipe_seqi_o.o2string()
            , "\n"
            , "got from SIM: ", pipe_seqi_i.o2string()
            , "\n"
        };

    data_same = pipe_seqi_i.compare(pipe_seqi_o);

    if (!data_same) begin
        `uvm_error("FAIL", data_str)
        fail_cnt++;
    end else
        `uvm_info("PASS", data_str, UVM_HIGH)
endfunction

function void pipe_scrb::report_phase(uvm_phase phase);
    if (fail_cnt > 0 || data_good == 0) begin
        `uvm_info("TEST_FAILED", "", UVM_NONE)
    end else begin
        `uvm_info("TEST_PASSED", "", UVM_NONE)
    end
endfunction