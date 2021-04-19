class dsp_base_layr extends uvm_component;
    `uvm_component_utils(dsp_base_layr)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);

    datagen_seqr                    datagen_seqr_i;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void dsp_base_layr::build_phase(uvm_phase phase);
    `uvm_component_create(uvm_sequencer #(datagen_seqi), datagen_seqr_i)
endfunction