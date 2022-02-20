//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_comprot
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_comprot;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem_math::*;

    import pkg_raxi::*;
    import pkg_pipe::*;
    import pkg_sincos::*;
    import pkg_compmult::*;

    `include "sim_complex_rotator.svh"
    `include "comprot_scrb.svh"

    `include "comprot_base_test.svh"
endpackage