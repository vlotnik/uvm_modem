//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_envr
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_envr #(
      A_DW = 12
    , B_DW = 12
) extends uvm_env;
    `uvm_component_param_utils(compmult_envr #(A_DW, B_DW))
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);

    compmult_envr_cfg #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_envr_cfg_h;

    compmult_agnt_cfg #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_agnt_cfg_h;
    compmult_agnt #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_agnt_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_envr::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(compmult_envr_cfg)::get(this, "", "compmult_envr_cfg_h", compmult_envr_cfg_h))
        `uvm_fatal(get_name(), "Failed to get configuration");

    // build agent configuration
    `uvm_object_create(compmult_agnt_cfg #(A_DW, B_DW), compmult_agnt_cfg_h)
    compmult_agnt_cfg_h.compmult_bfm_h = compmult_envr_cfg_h.compmult_bfm_h;
    // set agent configuration to database
    uvm_config_db #(compmult_agnt_cfg)::set(this, "compmult_agnt*", "compmult_agnt_cfg_h", compmult_agnt_cfg_h);

    // build agent
    `uvm_component_create(compmult_agnt #(A_DW, B_DW), compmult_agnt_h)
endfunction