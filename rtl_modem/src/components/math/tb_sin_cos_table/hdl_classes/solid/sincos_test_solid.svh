//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_test_solid
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_test_solid extends sincos_base_test;
    `uvm_component_utils(sincos_test_solid);
    `uvm_component_new

    localparam                      LATENCY = 3;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_test_solid::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // scoreboard settings
    sincos_scrb_h.test_name = "solid";
    sincos_scrb_h.latency_cnt = LATENCY;
endfunction

function void sincos_test_solid::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction

task sincos_test_solid::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask