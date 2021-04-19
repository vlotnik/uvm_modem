package pkg_vrf_dsp_components;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    // data generators
    `include "./components/data_generators/datagen_seqi.svh"
    typedef uvm_sequencer #(datagen_seqi) datagen_seqr;

    // dsp base
    `include "./components/dsp_base/dsp_base_seqc.svh"
endpackage