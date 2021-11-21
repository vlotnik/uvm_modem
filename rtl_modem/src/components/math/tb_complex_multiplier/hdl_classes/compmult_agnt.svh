//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_agnt #(
      A_DW = 12
    , B_DW = 12
) extends uvm_agent;
    `uvm_component_param_utils(compmult_agnt #(A_DW, B_DW))
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    // objects
    compmult_agnt_cfg #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_agnt_cfg_h;
    compmult_seqr                       compmult_seqr_h;
    compmult_drvr #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_drvr_h;
    compmult_mont #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_mont_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_agnt::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(compmult_agnt_cfg)::get(this, "", "compmult_agnt_cfg_h", compmult_agnt_cfg_h))
        `uvm_fatal(get_name(), "Failed to get configuration");

    // build sequencer
    `uvm_component_create(uvm_sequencer #(compmult_seqi), compmult_seqr_h)

    // build driver
    `uvm_component_create(compmult_drvr #(A_DW, B_DW), compmult_drvr_h)

    // build monitor
    `uvm_component_create(compmult_mont #(A_DW, B_DW), compmult_mont_h)
endfunction

function void compmult_agnt::connect_phase(uvm_phase phase);
    // connect driver
    compmult_drvr_h.compmult_bfm_h = compmult_agnt_cfg_h.compmult_bfm_h;
    compmult_drvr_h.seq_item_port.connect(compmult_seqr_h.seq_item_export);

    // connect monitor
    compmult_mont_h.compmult_bfm_h = compmult_agnt_cfg_h.compmult_bfm_h;
endfunction