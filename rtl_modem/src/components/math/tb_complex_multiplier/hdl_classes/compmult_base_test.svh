//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_base_test #(
          A_DW
        , B_DW
        , CONJ_MULT
) extends uvm_test;

    typedef uvm_component_registry #(compmult_base_test #(
          A_DW
        , B_DW
        , CONJ_MULT
    ), "compmult_base_test") type_id;

    `uvm_component_new

    localparam                          LATENCY = 4;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    // objects
    virtual compmult_bfm #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_bfm_h;

    compmult_envr_cfg #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_envr_cfg_h;
    compmult_envr #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_envr_h;

    compmult_base_seqc #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_base_seqc_h;

    compmult_scrb                       compmult_scrb_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_base_test::build_phase(uvm_phase phase);
    $display("\nrun test with settings: g_a_dw = %0d, g_b_dw = %0d, g_conj_mult = %0d\n",
        A_DW, B_DW, CONJ_MULT);

    // get bfm from database
    if (!uvm_config_db #(virtual compmult_bfm #(A_DW, B_DW))::get(this, "", "compmult_bfm_h", compmult_bfm_h))
        `uvm_fatal("BFM", "Failed to get compmult_bfm");

    // build environment configuration
    `uvm_object_create(compmult_envr_cfg #(A_DW, B_DW), compmult_envr_cfg_h)
    compmult_envr_cfg_h.compmult_bfm_h = this.compmult_bfm_h;
    // set environment configuration to database
    uvm_config_db #(compmult_envr_cfg)::set(this, "compmult_envr*", "compmult_envr_cfg_h", compmult_envr_cfg_h);

    // build environment
    `uvm_component_create(compmult_envr #(A_DW, B_DW), compmult_envr_h)

    // build sequence
    `uvm_component_create(compmult_base_seqc #(A_DW, B_DW), compmult_base_seqc_h)

    // build scoreboard
    `uvm_component_create(compmult_scrb, compmult_scrb_h)
    // compmult_scrb_h.latency_cnt = PIPE_CE == 0 ? LATENCY : 0;
    compmult_scrb_h.conj_mult = CONJ_MULT;
endfunction

function void compmult_base_test::connect_phase(uvm_phase phase);
    // connect mont to scoreboard
    compmult_envr_h.compmult_agnt_h.compmult_mont_h.compmult_aprt_i.connect(compmult_scrb_h.compmult_aprt_i);
    compmult_envr_h.compmult_agnt_h.compmult_mont_h.compmult_aprt_o.connect(compmult_scrb_h.compmult_aprt_o);
endfunction

task compmult_base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        compmult_base_seqc_h.start(compmult_envr_h.compmult_agnt_h.compmult_seqr_h);
    phase.drop_objection(this);
endtask