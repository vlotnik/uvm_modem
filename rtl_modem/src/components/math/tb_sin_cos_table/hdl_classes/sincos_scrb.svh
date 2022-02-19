//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_i)
`uvm_analysis_imp_decl(_o)

class sincos_scrb #(
      GP_DW = 10
    , PIPE_CE = 0
    , PHASE_DW = 12
    , SINCOS_DW = 16
) extends raxi_scrb;
    `uvm_component_param_utils(sincos_scrb #(GP_DW, PIPE_CE, PHASE_DW, SINCOS_DW))
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);

    uvm_analysis_imp_i #(raxi_seqi, sincos_scrb #(GP_DW, PIPE_CE, PHASE_DW, SINCOS_DW)) raxi_aprt_i;
    uvm_analysis_imp_o #(raxi_seqi, sincos_scrb #(GP_DW, PIPE_CE, PHASE_DW, SINCOS_DW)) raxi_aprt_o;

    // sim model
    sim_sin_cos_table #(
          .GP_DW(GP_DW)
        , .PIPE_CE(PIPE_CE)
        , .PHASE_DW(PHASE_DW)
        , .SINCOS_DW(SINCOS_DW)
    )                                   sim_sin_cos_table_h;

    // settings
    sincos_seqi #(
          .GP_DW(GP_DW)
        , .PHASE_DW(PHASE_DW)
        , .SINCOS_DW(SINCOS_DW)
    )                                   sincos_seqi_i;
    sincos_seqi #(
          .GP_DW(GP_DW)
        , .PHASE_DW(PHASE_DW)
        , .SINCOS_DW(SINCOS_DW)
    )                                   sincos_seqi_o;

    // functions
    extern virtual function void write_i(raxi_seqi raxi_seqi_h);
    extern virtual function void write_o(raxi_seqi raxi_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_scrb::build_phase(uvm_phase phase);
    raxi_aprt_i = new("raxi_aprt_i", this);
    raxi_aprt_o = new("raxi_aprt_o", this);

    `uvm_object_create(sincos_seqi #(GP_DW, PHASE_DW, SINCOS_DW), sincos_seqi_i)
    `uvm_object_create(sincos_seqi #(GP_DW, PHASE_DW, SINCOS_DW), sincos_seqi_o)

    `uvm_object_create(sim_sin_cos_table #(GP_DW, PIPE_CE, PHASE_DW, SINCOS_DW), sim_sin_cos_table_h);
endfunction

function void sincos_scrb::write_i(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_i.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nPING... sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
endfunction

function void sincos_scrb::write_o(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_o.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\n...PONG sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
    processing();
endfunction

function void sincos_scrb::processing();
    raxi_seqi raxi_seqi_sim_i;
    raxi_seqi raxi_seqi_sim_o;
    raxi_seqi raxi_seqi_o;
    string data_str;

    raxi_seqi_sim_i = raxi_seqi_queue_i.pop_front();
    `uvm_object_create(raxi_seqi, raxi_seqi_sim_o);
    sim_sin_cos_table_h.simulate(raxi_seqi_sim_i, raxi_seqi_sim_o);
    raxi_seqi_o = raxi_seqi_queue_o.pop_front();

    // get data from rAXI
    sincos_seqi_i.raxi2this_i(raxi_seqi_sim_i);
    sincos_seqi_i.raxi2this_o(raxi_seqi_sim_o);
    sincos_seqi_o.raxi2this_o(raxi_seqi_o);

    data_good = 1;
    data_str = {
          "\n"
        , "input data  : ", sincos_seqi_i.i2string()
        , "\n"
        , "got from RTL: ", sincos_seqi_o.o2string()
        , "\n"
        , "got from SIM: ", sincos_seqi_i.o2string()
        , "\n"
    };

    if (!sincos_seqi_i.compare(sincos_seqi_o)) begin
        `uvm_error("FAIL", data_str)
        fail_cnt++;
    end else
        `uvm_info("PASS", data_str, UVM_HIGH)
endfunction