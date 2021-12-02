//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_agnt
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_agnt #(
      RAXI_DW_I = 10
    , RAXI_DW_O = 12
) extends uvm_agent;
    `uvm_component_param_utils(raxi_agnt #(RAXI_DW_I, RAXI_DW_O))
    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);

    raxi_seqr                       raxi_seqr_h;

    raxi_drvr #(
          .DATA_WIDTH(RAXI_DW_I)
    )                               raxi_drvr_h;

    raxi_mont #(
          .DATA_WIDTH(RAXI_DW_I)
    )                               raxi_mont_i;
    raxi_mont #(
          .DATA_WIDTH(RAXI_DW_O)
    )                               raxi_mont_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void raxi_agnt::build_phase(uvm_phase phase);
    // build sequencer
    `uvm_component_create(uvm_sequencer #(raxi_seqi), raxi_seqr_h)

    // build driver
    `uvm_component_create(raxi_drvr #(RAXI_DW_I), raxi_drvr_h)

    // build monitor
    `uvm_component_create(raxi_mont #(RAXI_DW_I), raxi_mont_i)
    `uvm_component_create(raxi_mont #(RAXI_DW_O), raxi_mont_o)
endfunction