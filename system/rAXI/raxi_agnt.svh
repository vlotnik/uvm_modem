//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_agnt #(
      RAXI_DWI = 10
    , RAXI_DWO = 12
) extends uvm_agent;
    `uvm_component_param_utils(raxi_agnt #(RAXI_DWI, RAXI_DWO))
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);

    raxi_seqr                           raxi_seqr_h;

    raxi_drvr #(
          .DW(RAXI_DWI)
    )                                   raxi_drvr_h;

    raxi_mont #(
          .DW(RAXI_DWI)
    )                                   raxi_mont_i;
    raxi_mont #(
          .DW(RAXI_DWO)
    )                                   raxi_mont_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void raxi_agnt::build_phase(uvm_phase phase);
    // build sequencer
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_h)

    // build driver
    `uvm_component_create(raxi_drvr #(RAXI_DWI), raxi_drvr_h)

    // build monitor
    `uvm_component_create(raxi_mont #(RAXI_DWI), raxi_mont_i)
    `uvm_component_create(raxi_mont #(RAXI_DWO), raxi_mont_o)
endfunction