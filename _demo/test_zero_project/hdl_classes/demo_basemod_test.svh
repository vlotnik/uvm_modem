class demo_basemod_test extends uvm_test;
    `uvm_component_utils(demo_basemod_test)
    `uvm_component_new

    localparam INCH_NUMBER = 2;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // sequence
    basemod_base_seqc               seqc_h;

    // modulator
    basemod_envr                    basemod_envr_h;

    // interfaces
    virtual if_ddc_bfm #(
          .INCH_NUMBER(INCH_NUMBER)
    )                               if_ddc_bfm_h;
    if_ddc_agnt #(
          .INCH_NUMBER(INCH_NUMBER)
    )                               if_ddc_agnt_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void demo_basemod_test::build_phase(uvm_phase phase);
    // get dut_bfm
    if (!uvm_config_db #(virtual if_ddc_bfm #(INCH_NUMBER))::get(this, "", "if_ddc_bfm_h", if_ddc_bfm_h)
    )`uvm_fatal("BFM", "Failed to get BFM");

    // modulator
    `uvm_object_create(basemod_base_seqc, seqc_h)
    seqc_h.tr_pldsz = 100;
    seqc_h.tr_mod = QPSK;

    // modulator
    `uvm_component_create(basemod_envr, basemod_envr_h)

    // agent
    `uvm_component_create(if_ddc_agnt #(INCH_NUMBER), if_ddc_agnt_h);
    if_ddc_agnt_h.if_ddc_bfm_h = this.if_ddc_bfm_h;
endfunction

function void demo_basemod_test::connect_phase(uvm_phase phase);
    seqc_h.datagen_seqr_h = basemod_envr_h.datagen_seqr_i;
    // basemod_envr_h.dsp_symf_h.datagen_seqr_o = if_ddc_agnt_h.datagen_seqr_h;
    // basemod_envr_h.dsp_mapp_h.datagen_seqr_o = if_ddc_agnt_h.datagen_seqr_h;
    basemod_envr_h.dsp_rsmp_h.datagen_seqr_o = if_ddc_agnt_h.datagen_seqr_h;
endfunction

task demo_basemod_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);

        seqc_h.start(null);

    phase.drop_objection(this);
endtask