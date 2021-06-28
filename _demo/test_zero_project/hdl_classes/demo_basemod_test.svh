class demo_basemod_test extends uvm_test;
    `uvm_component_utils(demo_basemod_test)
    `uvm_component_new

    localparam INCH_NUMBER = 2;
    localparam NOFCH = 4;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // sequence
    basemod_base_seqc               seqc_h[NOFCH];

    // modulator
    basemod_envr                    basemod_envr_h[NOFCH];

    // summator
    dsp_layr_summator #(
          NOFCH
    )                               dsp_summ_h;

    // interfaces
    virtual if_ddc_bfm #(
          .INCH_NUMBER(INCH_NUMBER)
    )                               if_ddc_bfm_h;
    if_ddc_agnt #(
          .INCH_NUMBER(INCH_NUMBER)
    )                               if_ddc_agnt_h;

    // settings
    real sym_f[NOFCH];
    real car_f[NOFCH];
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void demo_basemod_test::build_phase(uvm_phase phase);
    // get dut_bfm
    if (!uvm_config_db #(virtual if_ddc_bfm #(INCH_NUMBER))::get(this, "", "if_ddc_bfm_h", if_ddc_bfm_h)
    )`uvm_fatal("BFM", "Failed to get BFM");

    // calculate settings
    for (int ii = 0; ii < NOFCH; ii++) begin
        sym_f[ii] = 1.0;
        car_f[ii] = -3 + 2 * ii;
    end

    // modulator
    for (int ii = 0; ii < NOFCH; ii++) begin
        `uvm_object_create(basemod_base_seqc, seqc_h[ii], ii)
        seqc_h[ii].tr_pldsz  = 100;
        seqc_h[ii].tr_mod    = QPSK;
        seqc_h[ii].tr_sym_f  = sym_f[ii];
        seqc_h[ii].tr_rsmp_f = 8.0;
        seqc_h[ii].tr_car_f  = car_f[ii];

        `uvm_component_create(basemod_envr, basemod_envr_h[ii], ii)
    end

    // build summator
    `uvm_component_create(dsp_layr_summator #(NOFCH), dsp_summ_h)

    // agent
    `uvm_component_create(if_ddc_agnt #(INCH_NUMBER), if_ddc_agnt_h);
    if_ddc_agnt_h.if_ddc_bfm_h = this.if_ddc_bfm_h;
endfunction

function void demo_basemod_test::connect_phase(uvm_phase phase);
    for (int ii = 0; ii < NOFCH; ii++) begin
        seqc_h[ii].datagen_seqr_h = basemod_envr_h[ii].datagen_seqr_i;
        basemod_envr_h[ii].dsp_mixr_h.datagen_seqr_o = dsp_summ_h.datagen_seqr_i[ii];
    end

    dsp_summ_h.datagen_seqr_o = if_ddc_agnt_h.datagen_seqr_h;
endfunction

task demo_basemod_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);

        for (int ii = 0; ii < NOFCH; ii++) begin
            automatic int iia = ii;
            fork
                seqc_h[iia].start(null);
            join_none
        end
        wait fork;

    phase.drop_objection(this);
endtask