//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_agnt_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_agnt_cfg #(
      IRAXI_DW
    , ORAXI_DW
) extends raxi_agnt_cfg #(IRAXI_DW, ORAXI_DW);
    `uvm_object_param_utils(compmult_agnt_cfg #(IRAXI_DW, ORAXI_DW))
    `uvm_object_new

endclass