//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_raxi
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_raxi;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    `include "raxi_seqi.svh"
    typedef uvm_sequencer #(raxi_seqi) raxi_seqr;

    `include "raxi_drvr.svh"

    typedef uvm_analysis_port #(raxi_seqi) raxi_aprt;
    `include "raxi_mont.svh"

    `include "raxi_agnt_cfg.svh"
    `include "raxi_agnt.svh"

    `include "raxi_envr_cfg.svh"
    // `include "raxi_envr.svh"

    `include "raxi_scrb.svh"

    `include "raxi_base_seqc.svh"
    `include "raxi_base_test.svh"
endpackage