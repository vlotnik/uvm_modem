//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_agnt_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_agnt_cfg #(
      RAXI_DWI
    , RAXI_DWO
) extends raxi_agnt_cfg #(RAXI_DWI, RAXI_DWO);
    `uvm_object_param_utils(sincos_agnt_cfg #(RAXI_DWI, RAXI_DWO))
    `uvm_object_new

endclass