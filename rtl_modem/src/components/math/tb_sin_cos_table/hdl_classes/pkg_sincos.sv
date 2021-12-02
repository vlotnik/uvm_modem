//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_sincos
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_sincos;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    // import pkg_vrf_dsp_components::*;

    `include "sincos_seqi.svh"
    typedef uvm_sequencer #(sincos_seqi) sincos_seqr;

    `include "sincos_drvr.svh"

    typedef uvm_analysis_port #(sincos_seqi) sincos_aprt;
    `include "sincos_mont.svh"

    `include "sincos_cvrb.svh"
    `include "sincos_scrb.svh"

    `include "sincos_agnt_cfg.svh"
    `include "sincos_agnt.svh"

    `include "sincos_envr_cfg.svh"
    `include "sincos_envr.svh"

    `include "sincos_base_seqc.svh"
    `include "sincos_base_test.svh"

    import "DPI-C" function int c_math_sin(input int phase, input int max, input int phase_w);
    import "DPI-C" function int c_math_cos(input int phase, input int max, input int phase_w);
endpackage