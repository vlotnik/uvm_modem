//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_envr
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_envr #(
      RAXI_DWI
    , RAXI_DWO
) extends uvm_env;
    `uvm_component_param_utils(compmult_envr #(RAXI_DWI, RAXI_DWO))
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);

    compmult_envr_cfg #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               compmult_envr_cfg_h;

    compmult_agnt_cfg #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               compmult_agnt_cfg_h;
    compmult_agnt #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               compmult_agnt_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_envr::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(compmult_envr_cfg #(
          RAXI_DWI
        , RAXI_DWO
    ))::get(this, "", "compmult_envr_cfg_h", compmult_envr_cfg_h))
        `uvm_fatal(get_name(), "Failed to get compmult envr configuration");

    // build agent configuration
    `uvm_object_create(compmult_agnt_cfg #(RAXI_DWI, RAXI_DWO), compmult_agnt_cfg_h)
    compmult_agnt_cfg_h.raxi_bfm_i = compmult_envr_cfg_h.raxi_bfm_i;
    compmult_agnt_cfg_h.raxi_bfm_o = compmult_envr_cfg_h.raxi_bfm_o;
    // set agent configuration to database
    uvm_config_db #(compmult_agnt_cfg #(
          RAXI_DWI
        , RAXI_DWO
    ))::set(this, "compmult_agnt*", "compmult_agnt_cfg_h", compmult_agnt_cfg_h);

    // build agent
    `uvm_component_create(compmult_agnt #(RAXI_DWI, RAXI_DWO), compmult_agnt_h)
endfunction