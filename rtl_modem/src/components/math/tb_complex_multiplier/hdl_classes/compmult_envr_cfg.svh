//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_envr_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_envr_cfg #(
      RAXI_DWI
    , RAXI_DWO
) extends raxi_envr_cfg #(RAXI_DWI, RAXI_DWO);
    `uvm_object_param_utils(compmult_envr_cfg #(RAXI_DWI, RAXI_DWO))
    `uvm_object_new

endclass