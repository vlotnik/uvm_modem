//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_agnt_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_agnt_cfg #(
      RAXI_DWI
    , RAXI_DWO
) extends raxi_agnt_cfg #(RAXI_DWI, RAXI_DWO);
    `uvm_object_param_utils(compmult_agnt_cfg #(RAXI_DWI, RAXI_DWO))
    `uvm_object_new

endclass