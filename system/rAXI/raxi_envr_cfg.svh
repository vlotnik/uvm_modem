//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_envr_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_envr_cfg #(
      RAXI_DWI
    , RAXI_DWO
) extends uvm_object;
    `uvm_object_param_utils(raxi_envr_cfg #(RAXI_DWI, RAXI_DWO))
    `uvm_object_new

    virtual raxi_bfm #(
          .DW(RAXI_DWI)
    )                                   raxi_bfm_i;
    virtual raxi_bfm #(
          .DW(RAXI_DWO)
    )                                   raxi_bfm_o;
endclass