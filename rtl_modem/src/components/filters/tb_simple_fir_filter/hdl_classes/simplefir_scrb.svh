//--------------------------------------------------------------------------------------------------------------------------------
// name : simplefir_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_icoef)
`uvm_analysis_imp_decl(_idata)
`uvm_analysis_imp_decl(_odata)

class simplefir_scrb #(
      NOF_TAPS
    , SAMPLE_DW
) extends raxi_scrb;
    `uvm_component_param_utils(simplefir_scrb #(NOF_TAPS, SAMPLE_DW))
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);

    // arrays
    raxi_seqi iraxi_seqi_queue_coef[$];
    raxi_seqi iraxi_seqi_queue_data[$];
    raxi_seqi oraxi_seqi_queue_data[$];

    uvm_analysis_imp_icoef #(raxi_seqi, simplefir_scrb #(NOF_TAPS, SAMPLE_DW)) iraxi_aprt_coef;
    uvm_analysis_imp_idata #(raxi_seqi, simplefir_scrb #(NOF_TAPS, SAMPLE_DW)) iraxi_aprt_data;
    uvm_analysis_imp_odata #(raxi_seqi, simplefir_scrb #(NOF_TAPS, SAMPLE_DW)) oraxi_aprt_data;

    // sim model
    sim_simple_fir_filter #(
          .G_NOF_TAPS(NOF_TAPS)
        , .G_SAMPLE_DW(SAMPLE_DW)
    )                                   sim_simple_fir_filter_h;

    // functions
    extern virtual function void write_icoef(raxi_seqi raxi_seqi_h);
    extern virtual function void write_idata(raxi_seqi raxi_seqi_h);
    extern virtual function void write_odata(raxi_seqi raxi_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void simplefir_scrb::build_phase(uvm_phase phase);
    iraxi_aprt_coef = new("iraxi_aprt_coef", this);
    iraxi_aprt_data = new("iraxi_aprt_data", this);
    oraxi_aprt_data = new("oraxi_aprt_data", this);

    `uvm_object_create(sim_simple_fir_filter #(NOF_TAPS, SAMPLE_DW), sim_simple_fir_filter_h);
endfunction

function void simplefir_scrb::write_icoef(raxi_seqi raxi_seqi_h);
    iraxi_seqi_queue_coef.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nICOEF: sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);

    sim_simple_fir_filter_h.add_coefficient(raxi_seqi_h);
endfunction

function void simplefir_scrb::write_idata(raxi_seqi raxi_seqi_h);
    iraxi_seqi_queue_data.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nIDATA: sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
endfunction

function void simplefir_scrb::write_odata(raxi_seqi raxi_seqi_h);
    oraxi_seqi_queue_data.push_back(raxi_seqi_h);
    `uvm_info("SCRB", $sformatf("\nODATA: sequence with %s", raxi_seqi_h.convert2string()), UVM_FULL);
    processing();
endfunction

function void simplefir_scrb::processing();
    raxi_seqi iraxi_seqi_data;
    raxi_seqi oraxi_seqi_data;
    raxi_seqi oraxi_seqi_data_sim;
    string data_str;

    // get items from arrays
    iraxi_seqi_data = iraxi_seqi_queue_data.pop_front();
    oraxi_seqi_data = oraxi_seqi_queue_data.pop_front();
    `uvm_object_create(raxi_seqi, oraxi_seqi_data_sim);
    sim_simple_fir_filter_h.simulate(iraxi_seqi_data, oraxi_seqi_data_sim);

    data_good = 1;
    data_str = {
              "\n"
            , "input data  : ", sim_simple_fir_filter_h.iraxi_iq_2string(iraxi_seqi_data)
            , "\n"
            , "got from RTL: ", sim_simple_fir_filter_h.oraxi_iq_2string(oraxi_seqi_data)
            , "\n"
            , "got from SIM: ", sim_simple_fir_filter_h.oraxi_iq_2string(oraxi_seqi_data_sim)
            , "\n"
        };

    if (!oraxi_seqi_data.compare(oraxi_seqi_data_sim)) begin
        `uvm_error("FAIL", data_str)
        fail_cnt++;
    end else
        `uvm_info("PASS", data_str, UVM_HIGH)
endfunction