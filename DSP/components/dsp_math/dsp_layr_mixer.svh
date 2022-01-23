//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_layr_mixer
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_layr_mixer extends dsp_base_layr;
    `uvm_component_utils(dsp_layr_mixer)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // sequence
    dsp_seqc_mixer                      dsp_seqc_mixer_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void dsp_layr_mixer::build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_component_create(dsp_seqc_mixer, dsp_seqc_mixer_h)
endfunction

function void dsp_layr_mixer::connect_phase(uvm_phase phase);
    dsp_seqc_mixer_h.datagen_seqr_h = datagen_seqr_i;
endfunction

task dsp_layr_mixer::run_phase(uvm_phase phase);
    dsp_seqc_mixer_h.start(datagen_seqr_o);
endtask