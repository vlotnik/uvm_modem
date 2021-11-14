//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_base_test extends uvm_test;
    `uvm_component_utils(sincos_base_test);
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // objects
    virtual sincos_bfm              sincos_bfm_h;

    sincos_envr_cfg                 sincos_envr_cfg_h;
    sincos_envr                     sincos_envr_h;

    sincos_cvrb                     sincos_cvrb_h;
    sincos_scrb                     sincos_scrb_h;

    sincos_base_seqc                sincos_base_seqc_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_base_test::build_phase(uvm_phase phase);
    // get bfm from database
    if (!uvm_config_db #(virtual sincos_bfm)::get(this, "", "sincos_bfm_h", sincos_bfm_h)
        ) `uvm_fatal("BFM", "Failed to get bfm");

    // build environment configuration
    `uvm_object_create(sincos_envr_cfg, sincos_envr_cfg_h)
    sincos_envr_cfg_h.sincos_bfm_h = this.sincos_bfm_h;
    // set environment configuration to database
    uvm_config_db #(sincos_envr_cfg)::set(
        this, "sincos_envr*", "sincos_envr_cfg_h", sincos_envr_cfg_h);

    // build environment
    `uvm_component_create(sincos_envr, sincos_envr_h)

    // build sequence
    `uvm_component_create(sincos_base_seqc, sincos_base_seqc_h)

    // build coverboard
    `uvm_component_create(sincos_cvrb, sincos_cvrb_h)

    // build scoreboard
    `uvm_component_create(sincos_scrb, sincos_scrb_h)
endfunction

function void sincos_base_test::connect_phase(uvm_phase phase);
    // connect mont to coverboard
    sincos_envr_h.sincos_agnt_h.sincos_mont_h.sincos_aprt_i.connect(sincos_cvrb_h.analysis_export);

    // connect mont to scoreboard
    sincos_envr_h.sincos_agnt_h.sincos_mont_h.sincos_aprt_i.connect(sincos_scrb_h.sincos_aprt_i);
    sincos_envr_h.sincos_agnt_h.sincos_mont_h.sincos_aprt_o.connect(sincos_scrb_h.sincos_aprt_o);
endfunction

task sincos_base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        sincos_base_seqc_h.start(sincos_envr_h.sincos_agnt_h.sincos_seqr_h);
    phase.drop_objection(this);
endtask