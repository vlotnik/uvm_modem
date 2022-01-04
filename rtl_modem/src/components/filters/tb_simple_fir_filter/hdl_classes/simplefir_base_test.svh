//--------------------------------------------------------------------------------------------------------------------------------
// name : simplefir_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class simplefir_base_test #(
      G_NOF_TAPS
    , G_COEF_DW
    , G_SAMPLE_DW
    , G_IRAXI_DW_COEF
    , G_IRAXI_DW
    , G_ORAXI_DW
) extends uvm_test;

    `uvm_component_new

    typedef uvm_component_registry #(simplefir_base_test #(
          G_NOF_TAPS
        , G_COEF_DW
        , G_SAMPLE_DW
        , G_IRAXI_DW_COEF
        , G_IRAXI_DW
        , G_ORAXI_DW
    ), "simplefir_base_test") type_id;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // objects
    virtual raxi_bfm #(
          .DW(G_IRAXI_DW_COEF)
    )                                   iraxi_bfm_coef;
    virtual raxi_bfm #(
          .DW(G_IRAXI_DW)
    )                                   iraxi_bfm;
    virtual raxi_bfm #(
          .DW(G_ORAXI_DW)
    )                                   oraxi_bfm;

    // sequencers
    raxi_seqr                           raxi_seqr_coef;
    raxi_seqr                           raxi_seqr_data;

    // drivers
    raxi_drvr #(
          .DW(G_IRAXI_DW_COEF)
    )                                   raxi_drvr_coef;
    raxi_drvr #(
          .DW(G_IRAXI_DW)
    )                                   raxi_drvr_data;

    // monitors
    raxi_mont #(
          .DW(G_IRAXI_DW_COEF)
    )                                   iraxi_mont_coef;
    raxi_mont #(
          .DW(G_IRAXI_DW)
    )                                   iraxi_mont_data;
    raxi_mont #(
          .DW(G_ORAXI_DW)
    )                                   oraxi_mont_data;

    // sequences
    simplefir_seqc_coef #(
          .G_NOF_TAPS(G_NOF_TAPS)
        , .G_COEF_DW(G_COEF_DW)
    )                                   simplefir_seqc_coef_h;
    simplefir_seqc_data #(
          .G_SAMPLE_DW(G_SAMPLE_DW)
    )                                   simplefir_seqc_data_h;

    // scoreboard
    simplefir_scrb #(
          .G_NOF_TAPS(G_NOF_TAPS)
        , .G_COEF_DW(G_COEF_DW)
        , .G_SAMPLE_DW(G_SAMPLE_DW)
    )                                   simplefir_scrb_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void simplefir_base_test::build_phase(uvm_phase phase);
    // get bfm from database
    if (!uvm_config_db #(virtual raxi_bfm #(G_IRAXI_DW_COEF))::get(this, "", "iraxi_bfm_coef", iraxi_bfm_coef))
        `uvm_fatal("BFM", "Failed to get iraxi_bfm_coef");
    if (!uvm_config_db #(virtual raxi_bfm #(G_IRAXI_DW))::get(this, "", "iraxi_bfm", iraxi_bfm))
        `uvm_fatal("BFM", "Failed to get iraxi_bfm");
    if (!uvm_config_db #(virtual raxi_bfm #(G_ORAXI_DW))::get(this, "", "oraxi_bfm", oraxi_bfm))
        `uvm_fatal("BFM", "Failed to get oraxi_bfm");

    // build sequencers
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_coef)
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_data)

    // build driver
    `uvm_component_create(raxi_drvr #(G_IRAXI_DW_COEF), raxi_drvr_coef)
    `uvm_component_create(raxi_drvr #(G_IRAXI_DW), raxi_drvr_data)

    // build monitor
    `uvm_component_create(raxi_mont #(G_IRAXI_DW_COEF), iraxi_mont_coef)
    `uvm_component_create(raxi_mont #(G_IRAXI_DW), iraxi_mont_data)
    `uvm_component_create(raxi_mont #(G_ORAXI_DW), oraxi_mont_data)

    // build sequence
    `uvm_component_create(simplefir_seqc_coef #(G_NOF_TAPS, G_COEF_DW), simplefir_seqc_coef_h);
    `uvm_component_create(simplefir_seqc_data #(G_SAMPLE_DW), simplefir_seqc_data_h);

    // build scoreboard
    `uvm_component_create(simplefir_scrb #(G_NOF_TAPS, G_COEF_DW, G_SAMPLE_DW), simplefir_scrb_h);
endfunction

function void simplefir_base_test::connect_phase(uvm_phase phase);
    // connect driver
    raxi_drvr_coef.raxi_bfm_h = iraxi_bfm_coef;
    raxi_drvr_coef.seq_item_port.connect(raxi_seqr_coef.seq_item_export);
    raxi_drvr_data.raxi_bfm_h = iraxi_bfm;
    raxi_drvr_data.seq_item_port.connect(raxi_seqr_data.seq_item_export);

    // connect monitor
    iraxi_mont_coef.raxi_bfm_h = iraxi_bfm_coef;
    iraxi_mont_data.raxi_bfm_h = iraxi_bfm;
    oraxi_mont_data.raxi_bfm_h = oraxi_bfm;

    // connect mont to scoreboard
    iraxi_mont_coef.raxi_aprt_h.connect(simplefir_scrb_h.iraxi_aprt_coef);
    iraxi_mont_data.raxi_aprt_h.connect(simplefir_scrb_h.iraxi_aprt_data);
    oraxi_mont_data.raxi_aprt_h.connect(simplefir_scrb_h.oraxi_aprt_data);
endfunction

task simplefir_base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        simplefir_seqc_coef_h.start(raxi_seqr_coef);
        #100
        simplefir_seqc_data_h.start(raxi_seqr_data);
    phase.drop_objection(this);
endtask