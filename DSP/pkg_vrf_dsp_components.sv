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
    typedef uvm_analysis_port #(datagen_seqi) datagen_aprt;

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
    `include "./components/filters/fir_filter.svh"
    `include "./components/filters/dsp_seqc_resampler.svh"
    `include "./components/filters/dsp_layr_resampler.svh"

    // mixer
    `include "./components/dsp_math/dspmath_mixer.svh"
    `include "./components/dsp_math/dsp_seqc_mixer.svh"
    `include "./components/dsp_math/dsp_layr_mixer.svh"

    // summator
    `include "./components/dsp_math/dsp_seqc_summator.svh"
    `include "./components/dsp_math/dsp_layr_summator.svh"
endpackage