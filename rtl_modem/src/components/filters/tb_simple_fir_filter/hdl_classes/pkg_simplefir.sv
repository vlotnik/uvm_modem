//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_simplefir
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_simplefir;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem::*;

    import pkg_vrf_dsp_components::*;

    import pkg_raxi::*;
    import pkg_pipe::*;

    `include "simplefir_seqc_coef.svh"
    `include "simplefir_seqc_data.svh"

    `include "sim_simple_fir_filter.svh"
    `include "simplefir_scrb.svh"

    `include "simplefir_base_test.svh"
endpackage