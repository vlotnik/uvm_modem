//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_vrf_dsp_components
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_vrf_dsp_components;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem::*;
    import pkg_modem_math::*;

    // data generators
    `include "./components/data_generators/datagen_seqi.svh"
    typedef uvm_sequencer #(datagen_seqi) datagen_seqr;

    // dsp base
    `include "./components/dsp_base/dsp_base_seqc.svh"
    `include "./components/dsp_base/dsp_base_layr.svh"

    // symbol framer
    `include "./components/data_generators/dsp_seqc_sym_framer.svh"
    `include "./components/data_generators/dsp_layr_sym_framer.svh"

    // iq mapper
    `include "./components/iq_mappers/iqmap_base.svh"
    `include "./components/iq_mappers/iqmap.svh"
    `include "./components/iq_mappers/dsp_seqc_iq_mapper.svh"
    `include "./components/iq_mappers/dsp_layr_iq_mapper.svh"

    // filters
    `include "./components/filters/filter_design.svh"
    `include "./components/filters/fir_resampler.svh"
    `include "./components/filters/dsp_seqc_resampler.svh"
    `include "./components/filters/dsp_layr_resampler.svh"
endpackage