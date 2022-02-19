//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_sincos
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_sincos;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem_math::*;

    import pkg_raxi::*;
    import pkg_pipe::*;

    `include "sincos_seqi.svh"
    typedef uvm_sequencer #(sincos_seqi) sincos_seqr;

    `include "sim_sin_cos_table_fg.svh"
    `include "sincos_scrb.svh"

    `include "sincos_agnt_cfg.svh"
    `include "sincos_agnt.svh"

    `include "sincos_envr_cfg.svh"
    `include "sincos_envr.svh"

    `include "sincos_base_seqc.svh"
    `include "sincos_base_test.svh"

    // import "DPI-C" function int c_math_sin(input int phase, input int max, input int phase_w);
    // import "DPI-C" function int c_math_cos(input int phase, input int max, input int phase_w);
endpackage