//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_compmult
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_compmult;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    `include "compmult_seqi.svh"
    typedef uvm_sequencer #(compmult_seqi) compmult_seqr;

    `include "compmult_drvr.svh"

    typedef uvm_analysis_port #(compmult_seqi) compmult_aprt;
    `include "compmult_mont.svh"

    `include "sim_complex_multiplier.svh"

    // `include "compmult_cvrb.svh"
    `include "compmult_scrb.svh"

    `include "compmult_agnt_cfg.svh"
    `include "compmult_agnt.svh"

    `include "compmult_envr_cfg.svh"
    `include "compmult_envr.svh"

    `include "compmult_base_seqc.svh"
    `include "compmult_base_test.svh"

    `include "./default/compmult_test_default.svh"
endpackage