//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_layr_iq_mapper
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_layr_iq_mapper extends dsp_base_layr;
    `uvm_component_utils(dsp_layr_iq_mapper)
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // sequence
    dsp_seqc_iq_mapper                  dsp_seqc_iq_mapper_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void dsp_layr_iq_mapper::build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_component_create(dsp_seqc_iq_mapper, dsp_seqc_iq_mapper_h)
endfunction

function void dsp_layr_iq_mapper::connect_phase(uvm_phase phase);
    dsp_seqc_iq_mapper_h.datagen_seqr_h = datagen_seqr_i;
endfunction

task dsp_layr_iq_mapper::run_phase(uvm_phase phase);
    dsp_seqc_iq_mapper_h.start(datagen_seqr_o);
endtask