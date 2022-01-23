//--------------------------------------------------------------------------------------------------------------------------------
// name : basemod_envr
//--------------------------------------------------------------------------------------------------------------------------------
class basemod_envr extends uvm_env;
    `uvm_component_utils(basemod_envr)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    datagen_seqr                        datagen_seqr_i;

    // layers
    dsp_layr_sym_framer                 dsp_symf_h;
    dsp_layr_iq_mapper                  dsp_mapp_h;
    dsp_layr_resampler                  dsp_rsmp_h;
    dsp_layr_mixer                      dsp_mixr_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void basemod_envr::build_phase(uvm_phase phase);
    // build layering
    `uvm_component_create(dsp_layr_sym_framer,  dsp_symf_h)
    `uvm_component_create(dsp_layr_iq_mapper,   dsp_mapp_h)
    `uvm_component_create(dsp_layr_resampler,   dsp_rsmp_h)
    `uvm_component_create(dsp_layr_mixer,       dsp_mixr_h)
endfunction

function void basemod_envr::connect_phase(uvm_phase phase);
    // input sequencer
    datagen_seqr_i = dsp_symf_h.datagen_seqr_i;

    dsp_symf_h.datagen_seqr_o = dsp_mapp_h.datagen_seqr_i;
    dsp_mapp_h.datagen_seqr_o = dsp_rsmp_h.datagen_seqr_i;
    dsp_rsmp_h.datagen_seqr_o = dsp_mixr_h.datagen_seqr_i;
endfunction