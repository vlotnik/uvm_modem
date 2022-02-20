//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_agnt #(
      IRAXI_DW = 10
    , ORAXI_DW = 12
) extends uvm_agent;
    `uvm_component_param_utils(raxi_agnt #(IRAXI_DW, ORAXI_DW))
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);

    raxi_seqr                           raxi_seqr_h;

    raxi_drvr #(
          .DW(IRAXI_DW)
    )                                   raxi_drvr_h;

    raxi_mont #(
          .DW(IRAXI_DW)
    )                                   raxi_mont_i;
    raxi_mont #(
          .DW(ORAXI_DW)
    )                                   raxi_mont_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void raxi_agnt::build_phase(uvm_phase phase);
    // build sequencer
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_h)

    // build driver
    `uvm_component_create(raxi_drvr #(IRAXI_DW), raxi_drvr_h)

    // build monitor
    `uvm_component_create(raxi_mont #(IRAXI_DW), raxi_mont_i)
    `uvm_component_create(raxi_mont #(ORAXI_DW), raxi_mont_o)
endfunction