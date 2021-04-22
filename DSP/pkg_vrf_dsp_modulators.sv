//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_vrf_dsp_modulators
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_vrf_dsp_modulators;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem::*;
    import pkg_vrf_dsp_components::*;

    // modulators
    `include "./modulators/base/basemod_base_seqc.svh"
    `include "./modulators/base/basemod_envr.svh"
endpackage