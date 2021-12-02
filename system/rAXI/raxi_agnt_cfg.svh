//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_agnt_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_agnt_cfg #(
      RAXI_DW_I
    , RAXI_DW_O
) extends uvm_object;
    `uvm_object_param_utils(raxi_agnt_cfg #(RAXI_DW_I, RAXI_DW_O))
    `uvm_object_new

    virtual raxi_bfm #(
          .DATA_WIDTH(RAXI_DW_I)
    )                               raxi_bfm_i;
    virtual raxi_bfm #(
          .DATA_WIDTH(RAXI_DW_O)
    )                               raxi_bfm_o;
endclass