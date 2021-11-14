//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_agnt extends uvm_agent;
    `uvm_component_utils(sincos_agnt)
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    // objects
    sincos_agnt_cfg                 sincos_agnt_cfg_h;
    sincos_seqr                     sincos_seqr_h;
    sincos_drvr                     sincos_drvr_h;
    sincos_mont                     sincos_mont_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_agnt::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(sincos_agnt_cfg)::get(this, "", "sincos_agnt_cfg_h", sincos_agnt_cfg_h)
        ) `uvm_fatal(get_name(), "Failed to get configuration");

    // build sequencer
    `uvm_component_create(uvm_sequencer #(sincos_seqi), sincos_seqr_h)

    // build driver
    `uvm_component_create(sincos_drvr, sincos_drvr_h)

    // build monitor
    `uvm_component_create(sincos_mont, sincos_mont_h)
endfunction

function void sincos_agnt::connect_phase(uvm_phase phase);
    // connect driver
    sincos_drvr_h.sincos_bfm_h = sincos_agnt_cfg_h.sincos_bfm_h;
    sincos_drvr_h.seq_item_port.connect(sincos_seqr_h.seq_item_export);

    // connect monitor
    sincos_mont_h.sincos_bfm_h = sincos_agnt_cfg_h.sincos_bfm_h;
endfunction