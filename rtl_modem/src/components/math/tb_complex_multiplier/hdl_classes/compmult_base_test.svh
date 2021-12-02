//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_base_test #(
      GPDW
    , A_W
    , B_W
    , CONJ_MULT
    , PIPE_CE
    , RAXI_DWI
    , RAXI_DWO
) extends raxi_base_test #(RAXI_DWI, RAXI_DWO);

    typedef uvm_component_registry #(compmult_base_test #(
          GPDW
        , A_W
        , B_W
        , CONJ_MULT
        , PIPE_CE
        , RAXI_DWI
        , RAXI_DWO
    ), "compmult_base_test") type_id;

    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    compmult_envr_cfg #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               compmult_envr_cfg_h;
    compmult_envr #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                               compmult_envr_h;

    compmult_base_seqc #(
          .GPDW(GPDW)
        , .A_W(A_W)
        , .B_W(B_W)
    )                               compmult_base_seqc_h;

    compmult_scrb #(
          .GPDW(GPDW)
        , .A_W(A_W)
        , .B_W(B_W)
        , .PIPE_CE(PIPE_CE)
        , .CONJ_MULT(CONJ_MULT)
    )                               compmult_scrb_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build environment configuration
    `uvm_object_create(compmult_envr_cfg #(RAXI_DWI, RAXI_DWO), compmult_envr_cfg_h)
    compmult_envr_cfg_h.raxi_bfm_i = this.raxi_bfm_i;
    compmult_envr_cfg_h.raxi_bfm_o = this.raxi_bfm_o;
    // set environment configuration to database
    uvm_config_db #(compmult_envr_cfg #(
          RAXI_DWI
        , RAXI_DWO
    ))::set(this, "compmult_envr*", "compmult_envr_cfg_h", compmult_envr_cfg_h);

    // build environment
    `uvm_component_create(compmult_envr #(RAXI_DWI, RAXI_DWO), compmult_envr_h)

    // build sequence
    `uvm_component_create(compmult_base_seqc #(GPDW, A_W, B_W), compmult_base_seqc_h)

    // build scoreboard
    `uvm_component_create(compmult_scrb #(GPDW, A_W, B_W, PIPE_CE, CONJ_MULT), compmult_scrb_h)
endfunction

function void compmult_base_test::connect_phase(uvm_phase phase);
    // connect mont to scoreboard
    compmult_envr_h.compmult_agnt_h.raxi_mont_i.raxi_aprt_h.connect(compmult_scrb_h.raxi_aprt_i);
    compmult_envr_h.compmult_agnt_h.raxi_mont_o.raxi_aprt_h.connect(compmult_scrb_h.raxi_aprt_o);
endfunction

task compmult_base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        compmult_base_seqc_h.start(compmult_envr_h.compmult_agnt_h.raxi_seqr_h);
    phase.drop_objection(this);
endtask