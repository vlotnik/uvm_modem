//--------------------------------------------------------------------------------------------------------------------------------
// name : comprot_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class comprot_base_test #(
      GP_DW
    , PHASE_DW
    , SAMPLE_DW
    , SINCOS_DW
    , CONJ_MULT
    , PIPE_CE
    , IRAXI_DW
    , ORAXI_DW
) extends raxi_base_test #(IRAXI_DW, ORAXI_DW);

    typedef uvm_component_registry #(comprot_base_test #(
          GP_DW
        , PHASE_DW
        , SAMPLE_DW
        , SINCOS_DW
        , CONJ_MULT
        , PIPE_CE
        , IRAXI_DW
        , ORAXI_DW
    ), "comprot_base_test") type_id;

    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // sequencers
    raxi_seqr                           raxi_seqr_h;

    // drivers
    raxi_drvr #(
          .DW(IRAXI_DW)
    )                                   raxi_drvr_h;

    // sequence
    raxi_base_seqc #(
          .DW(IRAXI_DW)
    )                                   raxi_base_seqc_h;

    // monitors
    raxi_mont #(
          .DW(IRAXI_DW)
    )                                   iraxi_mont;
    raxi_mont #(
          .DW(ORAXI_DW)
    )                                   oraxi_mont;

    // scoreboard
    comprot_scrb #(
          .GP_DW(GP_DW)
        , .PHASE_DW(PHASE_DW)
        , .SAMPLE_DW(SAMPLE_DW)
        , .SINCOS_DW(SINCOS_DW)
        , .CONJ_MULT(CONJ_MULT)
        , .PIPE_CE(PIPE_CE)
    )                                   comprot_scrb_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void comprot_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build sequencers
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_h)

    // build driver
    `uvm_component_create(raxi_drvr #(IRAXI_DW), raxi_drvr_h)

    // build sequence
    `uvm_component_create(raxi_base_seqc #(IRAXI_DW), raxi_base_seqc_h);
    raxi_base_seqc_h.nof_repeats = 1000;

    // build monitor
    `uvm_component_create(raxi_mont #(IRAXI_DW), iraxi_mont)
    `uvm_component_create(raxi_mont #(ORAXI_DW), oraxi_mont)

    // build scoreboard
    `uvm_component_create(comprot_scrb #(GP_DW, PHASE_DW, SAMPLE_DW, SINCOS_DW, CONJ_MULT, PIPE_CE), comprot_scrb_h);
endfunction

function void comprot_base_test::connect_phase(uvm_phase phase);
    // connect driver
    raxi_drvr_h.raxi_bfm_h = raxi_bfm_i;
    raxi_drvr_h.seq_item_port.connect(raxi_seqr_h.seq_item_export);

    // connect monitor
    iraxi_mont.raxi_bfm_h = raxi_bfm_i;
    oraxi_mont.raxi_bfm_h = raxi_bfm_o;

    // connect mont to scoreboard
    iraxi_mont.raxi_aprt_h.connect(comprot_scrb_h.raxi_aprt_i);
    oraxi_mont.raxi_aprt_h.connect(comprot_scrb_h.raxi_aprt_o);
endfunction

task comprot_base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        raxi_base_seqc_h.start(raxi_seqr_h);
    phase.drop_objection(this);
endtask