//--------------------------------------------------------------------------------------------------------------------------------
// name : pipe_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class pipe_seqc #(
      DW = 10
) extends uvm_sequence #(pipe_seqi);
    `uvm_object_param_utils(pipe_seqc #(DW))
    `uvm_object_new

    extern task body();

    int nof_repeats = 100;

    pipe_seqi #(
          .DW(DW)
    )                                   pipe_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task pipe_seqc::body();
    `uvm_object_create(pipe_seqi #(DW), pipe_seqi_h)

    repeat(nof_repeats) begin
        start_item(pipe_seqi_h);
            assert(pipe_seqi_h.randomize());
        finish_item(pipe_seqi_h);
    end
endtask