//--------------------------------------------------------------------------------------------------------------------------------
// name : pipe_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class pipe_agnt #(
      DW = 10
    , SIZE = 256
    , PIPE_CE = 0
) extends uvm_agent;
    `uvm_component_param_utils(pipe_agnt #(DW, SIZE, PIPE_CE))
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    // objects
    virtual raxi_bfm #(
          .DW(DW)
    )                                   raxi_bfm_i;
    virtual raxi_bfm #(
          .DW(DW)
    )                                   raxi_bfm_o;

    raxi_seqr                           raxi_seqr_h;

    raxi_drvr #(
          .DW(DW)
    )                                   raxi_drvr_h;

    raxi_mont #(
          .DW(DW)
    )                                   raxi_mont_i;
    raxi_mont #(
          .DW(DW)
    )                                   raxi_mont_o;

    pipe_scrb #(
          .DW(DW)
        , .SIZE(SIZE)
        , .PIPE_CE(PIPE_CE)
    )                                   pipe_scrb_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void pipe_agnt::build_phase(uvm_phase phase);
    // build sequencer
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_h)

    // build driver
    `uvm_component_create(raxi_drvr #(DW), raxi_drvr_h)

    // build monitor
    `uvm_component_create(raxi_mont #(DW), raxi_mont_i)
    `uvm_component_create(raxi_mont #(DW), raxi_mont_o)

    // build scoreboard
    `uvm_component_create(pipe_scrb #(DW, SIZE, PIPE_CE), pipe_scrb_h)
endfunction

function void pipe_agnt::connect_phase(uvm_phase phase);
    // connect driver
    raxi_drvr_h.raxi_bfm_h = this.raxi_bfm_i;
    raxi_drvr_h.seq_item_port.connect(raxi_seqr_h.seq_item_export);

    // connect monitor
    raxi_mont_i.raxi_bfm_h = this.raxi_bfm_i;
    raxi_mont_o.raxi_bfm_h = this.raxi_bfm_o;

    // connect mont to scoreboard
    raxi_mont_i.raxi_aprt_h.connect(pipe_scrb_h.raxi_aprt_i);
    raxi_mont_o.raxi_aprt_h.connect(pipe_scrb_h.raxi_aprt_o);
endfunction