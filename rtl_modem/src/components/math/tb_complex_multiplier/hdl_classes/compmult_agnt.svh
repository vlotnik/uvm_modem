//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_agnt #(
      IRAXI_DW = 10
    , ORAXI_DW = 12
) extends raxi_agnt #(IRAXI_DW, ORAXI_DW);
    `uvm_component_param_utils(compmult_agnt #(IRAXI_DW, ORAXI_DW))
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    // objects
    compmult_agnt_cfg #(
          .IRAXI_DW(IRAXI_DW)
        , .ORAXI_DW(ORAXI_DW)
    )                                   compmult_agnt_cfg_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_agnt::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // get configuration from database
    if (!uvm_config_db #(compmult_agnt_cfg #(
          IRAXI_DW
        , ORAXI_DW
    ))::get(this, "", "compmult_agnt_cfg_h", compmult_agnt_cfg_h))
        `uvm_fatal(get_name(), "Failed to get compmult agnt configuration");
endfunction

function void compmult_agnt::connect_phase(uvm_phase phase);
    // connect driver
    raxi_drvr_h.raxi_bfm_h = compmult_agnt_cfg_h.raxi_bfm_i;
    raxi_drvr_h.seq_item_port.connect(raxi_seqr_h.seq_item_export);

    // connect monitor
    raxi_mont_i.raxi_bfm_h = compmult_agnt_cfg_h.raxi_bfm_i;
    raxi_mont_o.raxi_bfm_h = compmult_agnt_cfg_h.raxi_bfm_o;
endfunction