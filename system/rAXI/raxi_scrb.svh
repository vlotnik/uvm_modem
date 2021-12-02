//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_scrb
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_scrb extends uvm_scoreboard;
    `uvm_component_utils(raxi_scrb)
    `uvm_component_new

    // base UVM functions
    extern function void report_phase(uvm_phase phase);

    // arrays
    raxi_seqi raxi_seqi_queue_i[$];
    raxi_seqi raxi_seqi_queue_o[$];

    // sim model
    bit data_good = 0;
    int fail_cnt = 0;

endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void raxi_scrb::report_phase(uvm_phase phase);
    if (fail_cnt > 0 || data_good == 0) begin
        `uvm_info("TEST_FAILED", "", UVM_NONE)
    end else begin
        `uvm_info("TEST_PASSED", "", UVM_NONE)
    end
endfunction