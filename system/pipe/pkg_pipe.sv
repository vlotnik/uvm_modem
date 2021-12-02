//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_pipe
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_pipe;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_raxi::*;

    `include "pipe_seqi.svh"
    typedef uvm_sequencer #(pipe_seqi) pipe_seqr;

    // `include "pipe_drvr.svh"

    // typedef uvm_analysis_port #(pipe_seqi) pipe_aprt;
    // `include "pipe_mont.svh"

    `include "sim_pipe.svh"
    `include "pipe_scrb.svh"

    `include "pipe_agnt.svh"

    `include "pipe_seqc.svh"
endpackage