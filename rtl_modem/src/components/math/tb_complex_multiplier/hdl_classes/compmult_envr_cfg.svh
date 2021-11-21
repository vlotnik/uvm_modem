//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_envr_cfg
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_envr_cfg #(
      A_DW = 12
    , B_DW = 12
) extends uvm_object;
    `uvm_object_param_utils(compmult_envr_cfg)
    `uvm_object_new

    virtual compmult_bfm #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_bfm_h;
endclass