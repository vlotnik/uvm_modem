class demo_basemod_test extends uvm_test;
    `uvm_component_utils(demo_basemod_test)
    `uvm_component_new

    localparam INCH_NUMBER = 2;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // interfaces
    virtual if_ddc_bfm #(
          .INCH_NUMBER(INCH_NUMBER)
    )                               if_ddc_bfm_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void demo_basemod_test::build_phase(uvm_phase phase);
    // get dut_bfm
    if (!uvm_config_db #(virtual if_ddc_bfm #(INCH_NUMBER))::get(this, "", "if_ddc_bfm_h", if_ddc_bfm_h)
        )`uvm_fatal("BFM", "Failed to get BFM");
endfunction

task demo_basemod_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
endtask