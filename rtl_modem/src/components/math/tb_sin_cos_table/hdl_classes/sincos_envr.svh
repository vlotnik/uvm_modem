//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_envr
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_envr #(
      IRAXI_DW
    , ORAXI_DW
) extends uvm_env;
    `uvm_component_param_utils(sincos_envr #(IRAXI_DW, ORAXI_DW))
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);

    sincos_envr_cfg #(
          .IRAXI_DW(IRAXI_DW)
        , .ORAXI_DW(ORAXI_DW)
    )                                   sincos_envr_cfg_h;

    sincos_agnt_cfg #(
          .IRAXI_DW(IRAXI_DW)
        , .ORAXI_DW(ORAXI_DW)
    )                                   sincos_agnt_cfg_h;
    sincos_agnt #(
          .IRAXI_DW(IRAXI_DW)
        , .ORAXI_DW(ORAXI_DW)
    )                                   sincos_agnt_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_envr::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(sincos_envr_cfg #(
          IRAXI_DW
        , ORAXI_DW
    ))::get(this, "", "sincos_envr_cfg_h", sincos_envr_cfg_h))
        `uvm_fatal(get_name(), "Failed to get sincos envr configuration");

    // build agent configuration
    `uvm_object_create(sincos_agnt_cfg #(IRAXI_DW, ORAXI_DW), sincos_agnt_cfg_h)
    sincos_agnt_cfg_h.raxi_bfm_i = sincos_envr_cfg_h.raxi_bfm_i;
    sincos_agnt_cfg_h.raxi_bfm_o = sincos_envr_cfg_h.raxi_bfm_o;
    // set agent configuration to database
    uvm_config_db #(sincos_agnt_cfg #(
          IRAXI_DW
        , ORAXI_DW
    ))::set(this, "sincos_agnt*", "sincos_agnt_cfg_h", sincos_agnt_cfg_h);

    // build agent
    `uvm_component_create(sincos_agnt #(IRAXI_DW, ORAXI_DW), sincos_agnt_h)
endfunction