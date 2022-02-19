//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_envr_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_envr_cfg #(
      IRAXI_DW
    , ORAXI_DW
) extends raxi_envr_cfg #(IRAXI_DW, ORAXI_DW);
    `uvm_object_param_utils(sincos_envr_cfg #(IRAXI_DW, ORAXI_DW))
    `uvm_object_new

endclass