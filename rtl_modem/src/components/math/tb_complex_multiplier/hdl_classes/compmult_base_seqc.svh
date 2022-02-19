//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_base_seqc #(
      GP_DW = 10
    , A_DW = 12
    , B_DW = 12
) extends uvm_sequence #(compmult_seqi);
    `uvm_object_param_utils(compmult_base_seqc #(GP_DW, A_DW, B_DW))
    `uvm_object_new

    extern task body();

    compmult_seqi #(
          .GP_DW(GP_DW)
        , .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task compmult_base_seqc::body();
    `uvm_object_create(compmult_seqi #(GP_DW, A_DW, B_DW), compmult_seqi_h)

    repeat(100) begin
        start_item(compmult_seqi_h);
            assert(compmult_seqi_h.randomize());
        finish_item(compmult_seqi_h);
    end
endtask