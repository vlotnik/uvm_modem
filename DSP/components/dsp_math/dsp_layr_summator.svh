//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_layr_summator
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_layr_summator #(
        NOFCH = 1
    ) extends uvm_component;
    `uvm_component_param_utils(dsp_layr_summator #(NOFCH))
    `uvm_component_new

    // settings
    real amp = 0.0;
    real ort = 0.0;
    int zsc_i = 0;
    int zsc_q = 0;

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // input sequencer
    datagen_seqr                        datagen_seqr_i[NOFCH];

    // multichannel sequence handler
    dsp_seqc_summator #(
        NOFCH
    )                                   dsp_seqc_summator_h;

    // output sequencer
    datagen_seqr                        datagen_seqr_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void dsp_layr_summator::build_phase(uvm_phase phase);
    foreach (datagen_seqr_i[ii])
        `uvm_component_create(uvm_sequencer #(datagen_seqi), datagen_seqr_i[ii], ii)

    `uvm_component_create(dsp_seqc_summator #(NOFCH), dsp_seqc_summator_h)
    dsp_seqc_summator_h.amp = this.amp;
    dsp_seqc_summator_h.ort = this.ort;
    dsp_seqc_summator_h.zsc_i = this.zsc_i;
    dsp_seqc_summator_h.zsc_q = this.zsc_q;
endfunction

function void dsp_layr_summator::connect_phase(uvm_phase phase);
    dsp_seqc_summator_h.datagen_seqr_h = datagen_seqr_i;
endfunction

task dsp_layr_summator::run_phase(uvm_phase phase);
    dsp_seqc_summator_h.start(datagen_seqr_o);
endtask