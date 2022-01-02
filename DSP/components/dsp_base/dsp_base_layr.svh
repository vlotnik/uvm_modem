//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_base_layr
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_base_layr extends uvm_component;
    `uvm_component_utils(dsp_base_layr)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    datagen_seqr                        datagen_seqr_i;
    datagen_seqr                        datagen_seqr_o;

    datagen_aprt                        datagen_aprt_i;
    datagen_aprt                        datagen_aprt_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------

function void dsp_base_layr::build_phase(uvm_phase phase);
    `uvm_component_create(uvm_sequencer #(datagen_seqi), datagen_seqr_i)
    datagen_aprt_i = new("datagen_aprt_i", this);
    datagen_aprt_o = new("datagen_aprt_o", this);
endfunction

function void dsp_base_layr::connect_phase(uvm_phase phase);
endfunction

task dsp_base_layr::run_phase(uvm_phase phase);
endtask