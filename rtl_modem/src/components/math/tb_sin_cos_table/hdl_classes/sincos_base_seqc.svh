//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_base_seqc #(
      GPDW = 10
    , PHASE_W = 12
    , SINCOS_W = 16
) extends uvm_sequence #(sincos_seqi);
    `uvm_object_utils(sincos_base_seqc #(GPDW, PHASE_W, SINCOS_W))
    `uvm_object_new

    extern task body();

    sincos_seqi #(
          .GPDW(GPDW)
        , .PHASE_W(PHASE_W)
        , .SINCOS_W(SINCOS_W)
    )                               sincos_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task sincos_base_seqc::body();
    `uvm_object_create(sincos_seqi #(GPDW, PHASE_W, SINCOS_W), sincos_seqi_h)

    repeat(100) begin
        start_item(sincos_seqi_h);
            assert(sincos_seqi_h.randomize());
        finish_item(sincos_seqi_h);
    end
endtask