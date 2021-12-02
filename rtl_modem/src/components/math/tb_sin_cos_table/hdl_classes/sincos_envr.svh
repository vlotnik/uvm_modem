//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_envr
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_envr #(
      RAXI_DWI
    , RAXI_DWO
) extends uvm_env;
    `uvm_component_param_utils(sincos_envr #(RAXI_DWI, RAXI_DWO))
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);

    sincos_envr_cfg #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               sincos_envr_cfg_h;

    sincos_agnt_cfg #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               sincos_agnt_cfg_h;
    sincos_agnt #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               sincos_agnt_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_envr::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(sincos_envr_cfg #(
          RAXI_DWI
        , RAXI_DWO
    ))::get(this, "", "sincos_envr_cfg_h", sincos_envr_cfg_h))
        `uvm_fatal(get_name(), "Failed to get sincos envr configuration");

    // build agent configuration
    `uvm_object_create(sincos_agnt_cfg #(RAXI_DWI, RAXI_DWO), sincos_agnt_cfg_h)
    sincos_agnt_cfg_h.raxi_bfm_i = sincos_envr_cfg_h.raxi_bfm_i;
    sincos_agnt_cfg_h.raxi_bfm_o = sincos_envr_cfg_h.raxi_bfm_o;
    // set agent configuration to database
    uvm_config_db #(sincos_agnt_cfg #(
          RAXI_DWI
        , RAXI_DWO
    ))::set(this, "sincos_agnt*", "sincos_agnt_cfg_h", sincos_agnt_cfg_h);

    // build agent
    `uvm_component_create(sincos_agnt #(RAXI_DWI, RAXI_DWO), sincos_agnt_h)
endfunction