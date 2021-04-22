package pkg_vrf_dsp_components;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem::*;

    // data generators
    `include "./components/data_generators/datagen_seqi.svh"
    typedef uvm_sequencer #(datagen_seqi) datagen_seqr;

    // dsp base
    `include "./components/dsp_base/dsp_base_seqc.svh"
    `include "./components/dsp_base/dsp_base_layr.svh"

    // symbol framer
    `include "./components/data_generators/dsp_seqc_sym_framer.svh"
    `include "./components/data_generators/dsp_layr_sym_framer.svh"
endpackage