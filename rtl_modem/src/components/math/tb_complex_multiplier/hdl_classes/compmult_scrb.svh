//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_i)
`uvm_analysis_imp_decl(_o)

class compmult_scrb extends uvm_scoreboard;
    `uvm_component_param_utils(compmult_scrb)
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

    uvm_analysis_imp_i #(compmult_seqi, compmult_scrb) compmult_aprt_i;
    uvm_analysis_imp_o #(compmult_seqi, compmult_scrb) compmult_aprt_o;

    compmult_seqi compmult_seqi_queue_i[$];
    compmult_seqi compmult_seqi_queue_o[$];

    sim_complex_multiplier              sim_complex_multiplier_h;

    // settings
    bit data_good = 0;
    bit conj_mult = 0;
    int fail_cnt = 0;
    string test_name = "";
    string file_name;
    int fid_result;

    // functions
    extern virtual function void write_i(compmult_seqi compmult_seqi_h);
    extern virtual function void write_o(compmult_seqi compmult_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_scrb::build_phase(uvm_phase phase);
    compmult_aprt_i = new("compmult_aprt_i", this);
    compmult_aprt_o = new("compmult_aprt_o", this);

    `uvm_object_create(sim_complex_multiplier, sim_complex_multiplier_h)
    sim_complex_multiplier_h.conj_mult = this.conj_mult;
endfunction

function void compmult_scrb::write_i(compmult_seqi compmult_seqi_h);
    compmult_seqi_queue_i.push_back(compmult_seqi_h);
    // sim_complex_multiplier_h.simulate(compmult_seqi_h);
    // `uvm_info("SEQC", $sformatf("\nPING... sequence with %s", compmult_seqi_h.convert2string()), UVM_NONE);
endfunction

function void compmult_scrb::write_o(compmult_seqi compmult_seqi_h);
    compmult_seqi_queue_o.push_back(compmult_seqi_h);
    // `uvm_info("SEQC", $sformatf("\n...PONG sequence with %s", compmult_seqi_h.convert2string()), UVM_NONE);
    processing();
endfunction

function void compmult_scrb::processing();
    compmult_seqi compmult_seqi_i;
    compmult_seqi compmult_seqi_o;
    string data_str;

    compmult_seqi_i = compmult_seqi_queue_i.pop_front();
    sim_complex_multiplier_h.simulate(compmult_seqi_i);
    compmult_seqi_o = compmult_seqi_queue_o.pop_front();

    `uvm_info("SEQC", $sformatf("\nPING... sequence with %s", compmult_seqi_i.o2string()), UVM_FULL);
    `uvm_info("SEQC", $sformatf("\n...PONG sequence with %s", compmult_seqi_o.o2string()), UVM_FULL);

    data_good = 1;
    data_str = {
              "\n"
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

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_scrb::report_phase(uvm_phase phase);
    if (fail_cnt > 0 || data_good == 0) begin
        `uvm_info("TEST_FAILED", "", UVM_NONE)
    end else begin
        `uvm_info("TEST_PASSED", "", UVM_NONE)
    end
endfunction