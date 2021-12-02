//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_envr_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_envr_cfg #(
      RAXI_DWI
    , RAXI_DWO
) extends raxi_envr_cfg #(RAXI_DWI, RAXI_DWO);
    `uvm_object_param_utils(sincos_envr_cfg #(RAXI_DWI, RAXI_DWO))
    `uvm_object_new

endclass