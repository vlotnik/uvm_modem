//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_base_seqc #(
      GPDW = 10
    , A_W = 12
    , B_W = 12
) extends uvm_sequence #(compmult_seqi);
    `uvm_object_param_utils(compmult_base_seqc #(GPDW, A_W, B_W))
    `uvm_object_new

    extern task body();

    compmult_seqi #(
          .GPDW(GPDW)
        , .A_W(A_W)
        , .B_W(B_W)
    )                               compmult_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task compmult_base_seqc::body();
    `uvm_object_create(compmult_seqi #(GPDW, A_W, B_W), compmult_seqi_h)

    repeat(100) begin
        start_item(compmult_seqi_h);
            assert(compmult_seqi_h.randomize());
        finish_item(compmult_seqi_h);
    end
endtask