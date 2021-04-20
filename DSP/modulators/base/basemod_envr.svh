class basemod_envr extends uvm_env;
    `uvm_component_utils(basemod_envr)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    datagen_seqr                    datagen_seqr_i;

    // layers
    dsp_layr_sym_framer             dsp_symf_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void basemod_envr::build_phase(uvm_phase phase);
    // build layering
    `uvm_component_create(dsp_layr_sym_framer,  dsp_symf_h)
endfunction

function void basemod_envr::connect_phase(uvm_phase phase);
    // input sequencer
    datagen_seqr_i = dsp_symf_h.datagen_seqr_i;
endfunction