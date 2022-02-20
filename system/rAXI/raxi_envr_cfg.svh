//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_envr_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_envr_cfg #(
      IRAXI_DW
    , ORAXI_DW
) extends uvm_object;
    `uvm_object_param_utils(raxi_envr_cfg #(IRAXI_DW, ORAXI_DW))
    `uvm_object_new

    virtual raxi_bfm #(
          .DW(IRAXI_DW)
    )                                   raxi_bfm_i;
    virtual raxi_bfm #(
          .DW(ORAXI_DW)
    )                                   raxi_bfm_o;
endclass