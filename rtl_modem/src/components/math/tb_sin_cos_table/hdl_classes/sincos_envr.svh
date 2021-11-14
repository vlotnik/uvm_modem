//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_envr
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_envr extends uvm_env;
    `uvm_component_utils(sincos_envr)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);

    sincos_envr_cfg                 sincos_envr_cfg_h;

    sincos_agnt_cfg                 sincos_agnt_cfg_h;
    sincos_agnt                     sincos_agnt_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_envr::build_phase(uvm_phase phase);
    // get configuration from database
    if (!uvm_config_db #(sincos_envr_cfg)::get(this, "", "sincos_envr_cfg_h", sincos_envr_cfg_h)
        ) `uvm_fatal(get_name(), "Failed to get configuration");

    // build agent configuration
    `uvm_object_create(sincos_agnt_cfg, sincos_agnt_cfg_h)
    sincos_agnt_cfg_h.sincos_bfm_h = sincos_envr_cfg_h.sincos_bfm_h;
    // set agent configuration to database
    uvm_config_db #(sincos_agnt_cfg)::set(
        this, "sincos_agnt*", "sincos_agnt_cfg_h", sincos_agnt_cfg_h);

    // build agent
    `uvm_component_create(sincos_agnt, sincos_agnt_h)
endfunction