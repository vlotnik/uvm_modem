//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_base_test #(
      GPDW
    , FULL_TABLE
    , PHASE_W
    , SINCOS_W
    , PIPE_CE
    , RAXI_DWI
    , RAXI_DWO
) extends raxi_base_test #(RAXI_DWI, RAXI_DWO);

    `uvm_component_new

    typedef uvm_component_registry #(sincos_base_test #(
          GPDW
        , FULL_TABLE
        , PHASE_W
        , SINCOS_W
        , PIPE_CE
        , RAXI_DWI
        , RAXI_DWO
    ), "sincos_base_test") type_id;

    // functions
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    sincos_envr_cfg #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                                   sincos_envr_cfg_h;
    sincos_envr #(
          .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                                   sincos_envr_h;

    sincos_scrb #(
          .GPDW(GPDW)
        , .PIPE_CE(PIPE_CE)
        , .PHASE_W(PHASE_W)
        , .SINCOS_W(SINCOS_W)
    )                                   sincos_scrb_h;

    sincos_base_seqc #(
          .GPDW(GPDW)
        , .PHASE_W(PHASE_W)
        , .SINCOS_W(SINCOS_W)
    )                                   sincos_base_seqc_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build environment configuration
    `uvm_object_create(sincos_envr_cfg #(RAXI_DWI, RAXI_DWO), sincos_envr_cfg_h)
    sincos_envr_cfg_h.raxi_bfm_i = this.raxi_bfm_i;
    sincos_envr_cfg_h.raxi_bfm_o = this.raxi_bfm_o;
    // set environment configuration to database
    uvm_config_db #(sincos_envr_cfg #(
          RAXI_DWI
        , RAXI_DWO
    ))::set(this, "sincos_envr*", "sincos_envr_cfg_h", sincos_envr_cfg_h);

    // build environment
    `uvm_component_create(sincos_envr #(RAXI_DWI, RAXI_DWO), sincos_envr_h)

    // build sequence
    `uvm_component_create(sincos_base_seqc #(GPDW, PHASE_W, SINCOS_W), sincos_base_seqc_h)

    // build scoreboard
    `uvm_component_create(sincos_scrb #(GPDW, PIPE_CE, PHASE_W, SINCOS_W), sincos_scrb_h)
endfunction

function void sincos_base_test::connect_phase(uvm_phase phase);
    // connect mont to scoreboard
    sincos_envr_h.sincos_agnt_h.raxi_mont_i.raxi_aprt_h.connect(sincos_scrb_h.raxi_aprt_i);
    sincos_envr_h.sincos_agnt_h.raxi_mont_o.raxi_aprt_h.connect(sincos_scrb_h.raxi_aprt_o);
endfunction

task sincos_base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        sincos_base_seqc_h.start(sincos_envr_h.sincos_agnt_h.raxi_seqr_h);
    phase.drop_objection(this);
endtask