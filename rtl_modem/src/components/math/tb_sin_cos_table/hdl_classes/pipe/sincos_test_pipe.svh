//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_test_pipe
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_test_pipe extends sincos_base_test;
    `uvm_component_utils(sincos_test_pipe);
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_test_pipe::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // scoreboard settings
    sincos_scrb_h.test_name = "pipe";
endfunction

function void sincos_test_pipe::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction

task sincos_test_pipe::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask