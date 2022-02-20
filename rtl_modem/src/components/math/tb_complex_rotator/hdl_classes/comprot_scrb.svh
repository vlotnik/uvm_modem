//--------------------------------------------------------------------------------------------------------------------------------
// name : comprot_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_i)
`uvm_analysis_imp_decl(_o)

class comprot_scrb #(
      GP_DW
    , PHASE_DW
    , SAMPLE_DW
    , SINCOS_DW
    , CONJ_MULT
    , PIPE_CE
) extends raxi_scrb;
    `uvm_component_param_utils(comprot_scrb #(GP_DW, PHASE_DW, SAMPLE_DW, SINCOS_DW, CONJ_MULT, PIPE_CE))
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);

    uvm_analysis_imp_i #(raxi_seqi, comprot_scrb #(GP_DW, PHASE_DW, SAMPLE_DW, SINCOS_DW, CONJ_MULT, PIPE_CE)) raxi_aprt_i;
    uvm_analysis_imp_o #(raxi_seqi, comprot_scrb #(GP_DW, PHASE_DW, SAMPLE_DW, SINCOS_DW, CONJ_MULT, PIPE_CE)) raxi_aprt_o;

    // sim model
    sim_complex_rotator #(
          .GP_DW(GP_DW)
        , .PHASE_DW(PHASE_DW)
        , .SAMPLE_DW(SAMPLE_DW)
        , .SINCOS_DW(SINCOS_DW)
        , .CONJ_MULT(CONJ_MULT)
        , .PIPE_CE(PIPE_CE)
    )                                   sim_complex_rotator_h;

    // functions
    extern virtual function void write_i(raxi_seqi raxi_seqi_h);
    extern virtual function void write_o(raxi_seqi raxi_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void comprot_scrb::build_phase(uvm_phase phase);
    raxi_aprt_i = new("raxi_aprt_i", this);
    raxi_aprt_o = new("raxi_aprt_o", this);

    `uvm_object_create(sim_complex_rotator #(GP_DW, PHASE_DW, SAMPLE_DW, SINCOS_DW, CONJ_MULT, PIPE_CE), sim_complex_rotator_h);
endfunction

function void comprot_scrb::write_i(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_i.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nPING... sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
endfunction

function void comprot_scrb::write_o(raxi_seqi raxi_seqi_h);
    raxi_seqi_queue_o.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\n...PONG sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
    processing();
endfunction

function void comprot_scrb::processing();
    raxi_seqi iraxi_seqi_data;
    raxi_seqi oraxi_seqi_data;
    raxi_seqi oraxi_seqi_data_sim;
    string data_str;

    // get items from arrays
    iraxi_seqi_data = raxi_seqi_queue_i.pop_front();
    oraxi_seqi_data = raxi_seqi_queue_o.pop_front();
    `uvm_object_create(raxi_seqi, oraxi_seqi_data_sim);
    sim_complex_rotator_h.simulate(iraxi_seqi_data, oraxi_seqi_data_sim);

    data_good = 1;
    data_str = {
          "\n"
        , "input data  : ", sim_complex_rotator_h.iraxi_2string(iraxi_seqi_data)
        , "\n"
        , "got from RTL: ", sim_complex_rotator_h.oraxi_2string(oraxi_seqi_data)
        , "\n"
        , "got from SIM: ", sim_complex_rotator_h.oraxi_2string(oraxi_seqi_data_sim)
        , "\n"
    };

    if (!oraxi_seqi_data.compare(oraxi_seqi_data_sim)) begin
        `uvm_error("FAIL", data_str)
        fail_cnt++;
    end else
        `uvm_info("PASS", data_str, UVM_HIGH)
endfunction