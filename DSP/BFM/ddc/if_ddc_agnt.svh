class if_ddc_agnt #(
          INCH_NUMBER = 1
        , SIGNAL_TYPE = 0
    ) extends uvm_agent;
    `uvm_component_utils(if_ddc_agnt #(INCH_NUMBER, SIGNAL_TYPE))
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    virtual if_ddc_bfm #(
          .INCH_NUMBER(INCH_NUMBER)
        , .SIGNAL_TYPE(SIGNAL_TYPE)
    )                               if_ddc_bfm_h;

    datagen_seqr                    datagen_seqr_h;
    if_ddc_drvr #(
          .INCH_NUMBER(INCH_NUMBER)
        , .SIGNAL_TYPE(SIGNAL_TYPE)
    )                               if_ddc_drvr_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void if_ddc_agnt::build_phase(uvm_phase phase);
    // build sequencer
    `uvm_component_create(uvm_sequencer #(datagen_seqi), datagen_seqr_h)
    // build driver
    `uvm_component_create(if_ddc_drvr #(INCH_NUMBER, SIGNAL_TYPE), if_ddc_drvr_h)
endfunction

function void if_ddc_agnt::connect_phase(uvm_phase phase);
    // parse interface to driver
    if_ddc_drvr_h.if_ddc_bfm_h = this.if_ddc_bfm_h;
    if_ddc_drvr_h.seq_item_port.connect(this.datagen_seqr_h.seq_item_export);
endfunction