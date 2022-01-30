//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_compmult
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_compmult;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem::*;

    import pkg_raxi::*;
    import pkg_pipe::*;

    `include "compmult_seqi.svh"

    `include "sim_complex_multiplier.svh"
    `include "compmult_scrb.svh"

    `include "compmult_agnt_cfg.svh"
    `include "compmult_agnt.svh"

    `include "compmult_envr_cfg.svh"
    `include "compmult_envr.svh"

    `include "compmult_base_seqc.svh"
    `include "compmult_base_test.svh"

    import "DPI-C" function int c_math_complex_mult_re(int a_re, int a_im, int b_re, int b_im, int conj_mult);
    import "DPI-C" function int c_math_complex_mult_im(int a_re, int a_im, int b_re, int b_im, int conj_mult);
endpackage