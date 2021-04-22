//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_vrf_dsp_bfm
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_vrf_dsp_bfm;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_vrf_dsp_components::*;

    // ddc interface
    `include "./BFM/ddc/if_ddc_drvr.svh"
    `include "./BFM/ddc/if_ddc_agnt.svh"
endpackage