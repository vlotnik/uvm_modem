//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_base_seqc #(
      GP_DW = 10
    , PHASE_DW = 12
    , SINCOS_DW = 16
) extends uvm_sequence #(sincos_seqi);
    `uvm_object_utils(sincos_base_seqc #(GP_DW, PHASE_DW, SINCOS_DW))
    `uvm_object_new

    extern task body();

    sincos_seqi #(
          .GP_DW(GP_DW)
        , .PHASE_DW(PHASE_DW)
        , .SINCOS_DW(SINCOS_DW)
    )                               sincos_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task sincos_base_seqc::body();
    `uvm_object_create(sincos_seqi #(GP_DW, PHASE_DW, SINCOS_DW), sincos_seqi_h)

    repeat(100) begin
        start_item(sincos_seqi_h);
            assert(sincos_seqi_h.randomize());
        finish_item(sincos_seqi_h);
    end
endtask