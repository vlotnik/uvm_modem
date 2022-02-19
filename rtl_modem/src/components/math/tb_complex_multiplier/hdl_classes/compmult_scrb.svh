//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_i)
`uvm_analysis_imp_decl(_o)

class compmult_scrb #(
      GP_DW
    , A_DW
    , B_DW
    , PIPE_CE
    , CONJ_MULT
) extends raxi_scrb;
    `uvm_component_param_utils(compmult_scrb #(GP_DW, A_DW, B_DW, PIPE_CE, CONJ_MULT))
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);

    uvm_analysis_imp_i #(raxi_seqi, compmult_scrb #(GP_DW, A_DW, B_DW, PIPE_CE, CONJ_MULT)) raxi_aprt_i;
    uvm_analysis_imp_o #(raxi_seqi, compmult_scrb #(GP_DW, A_DW, B_DW, PIPE_CE, CONJ_MULT)) raxi_aprt_o;

    // sim model
    sim_complex_multiplier #(
          .GP_DW(GP_DW)
        , .A_DW(A_DW)
        , .B_DW(B_DW)
        , .PIPE_CE(PIPE_CE)
        , .CONJ_MULT(CONJ_MULT)
    )                                   sim_complex_multiplier_h;

    compmult_seqi #(
          .GP_DW(GP_DW)
        , .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_seqi_i;
    compmult_seqi #(
          .GP_DW(GP_DW)
        , .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_seqi_o;

    // functions
    extern virtual function void write_i(raxi_seqi raxi_seqi_h);
    extern virtual function void write_o(raxi_seqi raxi_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_scrb::build_phase(uvm_phase phase);
    raxi_aprt_i = new("raxi_aprt_i", this);
    raxi_aprt_o = new("raxi_aprt_o", this);

    `uvm_object_create(compmult_seqi #(GP_DW, A_DW, B_DW), compmult_seqi_i)
    `uvm_object_create(compmult_seqi #(GP_DW, A_DW, B_DW), compmult_seqi_o)

    `uvm_object_create(sim_complex_multiplier #(GP_DW, A_DW, B_DW, PIPE_CE, CONJ_MULT), sim_complex_multiplier_h);
endfunction

function void compmult_scrb::write_i(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_i.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nPING... sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
endfunction

function void compmult_scrb::write_o(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_o.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\n...PONG sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
    processing();
endfunction

function void compmult_scrb::processing();
    raxi_seqi raxi_seqi_sim_i;
    raxi_seqi raxi_seqi_sim_o;
    raxi_seqi raxi_seqi_o;
    string data_str;

    raxi_seqi_sim_i = raxi_seqi_queue_i.pop_front();
    `uvm_object_create(raxi_seqi, raxi_seqi_sim_o);
    sim_complex_multiplier_h.simulate(raxi_seqi_sim_i, raxi_seqi_sim_o);
    raxi_seqi_o = raxi_seqi_queue_o.pop_front();

    // get data from rAXI
    compmult_seqi_i.raxi2this_i(raxi_seqi_sim_i);
    compmult_seqi_i.raxi2this_o(raxi_seqi_sim_o);
    compmult_seqi_o.raxi2this_o(raxi_seqi_o);

    data_good = 1;
    data_str = {
          "\n"
        , "input data  : ", compmult_seqi_i.i2string()
        , "\n"
        , "got from RTL: ", compmult_seqi_o.o2string()
        , "\n"
        , "got from SIM: ", compmult_seqi_i.o2string()
        , "\n"
    };

    if (!compmult_seqi_i.compare(compmult_seqi_o)) begin
        `uvm_error("FAIL", data_str)
        fail_cnt++;
    end else
        `uvm_info("PASS", data_str, UVM_HIGH)
endfunction