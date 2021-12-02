//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_scrb
//--------------------------------------------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_i)
`uvm_analysis_imp_decl(_o)

class sincos_scrb extends uvm_scoreboard;
    `uvm_component_param_utils(sincos_scrb)
    `uvm_component_new

    // base UVM functions
    extern function void build_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

    uvm_analysis_imp_i #(sincos_seqi, sincos_scrb) sincos_aprt_i;
    uvm_analysis_imp_o #(sincos_seqi, sincos_scrb) sincos_aprt_o;

    sincos_seqi sincos_seqi_queue_i[$];
    sincos_seqi sincos_seqi_queue_o[$];

    // LATENCY
    int latency_cnt = 0;

    // settings
    bit data_good = 0;
    int fail_cnt = 0;
    int max_value = 2 ** 15 - 1;
    string test_name = "";
    string file_name;
    int fid_result;

    // functions
    extern virtual function void write_i(sincos_seqi sincos_seqi_h);
    extern virtual function void write_o(sincos_seqi sincos_seqi_h);
    extern function void processing();
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_scrb::build_phase(uvm_phase phase);
    sincos_aprt_i = new("sincos_aprt_i", this);
    sincos_aprt_o = new("sincos_aprt_o", this);
endfunction

function void sincos_scrb::write_i(sincos_seqi sincos_seqi_h);
    sincos_seqi_queue_i.push_back(sincos_seqi_h);
endfunction

function void sincos_scrb::write_o(sincos_seqi sincos_seqi_h);
    sincos_seqi_queue_o.push_back(sincos_seqi_h);
    processing();
endfunction

function void sincos_scrb::processing();
    sincos_seqi sincos_seqi_i;
    sincos_seqi sincos_seqi_o;
    string data_str;

    sincos_seqi_o = sincos_seqi_queue_o.pop_front();

    if (latency_cnt == 0) begin
        sincos_seqi_i = sincos_seqi_queue_i.pop_front();
        sincos_seqi_i.sin = c_math_sin(sincos_seqi_i.phase, max_value, 12);
        sincos_seqi_i.cos = c_math_cos(sincos_seqi_i.phase, max_value, 12);
        `uvm_info("SEQC", $sformatf("PING... sequence with %s", sincos_seqi_i.convert2string()), UVM_FULL);

        sincos_seqi_o.phase = sincos_seqi_i.phase;
        `uvm_info("SEQC", $sformatf("...PONG sequence with %s", sincos_seqi_o.convert2string()), UVM_FULL);

        data_good = 1;
        data_str = {
                  "\n"
                , "got from RTL: ", sincos_seqi_o.convert2string()
                , "\n"
                , "got from SIM: ", sincos_seqi_i.convert2string()
            };

        if (!sincos_seqi_i.compare(sincos_seqi_o)) begin
            `uvm_error("FAIL", data_str)
            fail_cnt++;
        end else
            `uvm_info("PASS", data_str, UVM_HIGH)
    end else begin
        `uvm_info("LATENCY", $sformatf("skip item because of latency, %0d left", latency_cnt), UVM_NONE);
        latency_cnt--;
    end
endfunction

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_scrb::report_phase(uvm_phase phase);
    // file_name = $sformatf("_result/sincos_scrb_%s.RESULT", test_name);
    // fid_result = $fopen(file_name, "w");

    if (fail_cnt > 0 || data_good == 0) begin
        `uvm_info("TEST_FAILED", "", UVM_NONE)
        // $fwrite(fid_result, "FAIL");
    end else begin
        `uvm_info("TEST_PASSED", "", UVM_NONE)
        // $fwrite(fid_result, "PASS");
    end

    // $fclose(fid_result);
endfunction