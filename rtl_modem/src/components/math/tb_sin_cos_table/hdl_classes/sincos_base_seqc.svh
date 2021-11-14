//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_base_seqc extends uvm_sequence #(sincos_seqi);
    `uvm_object_utils(sincos_base_seqc)
    `uvm_object_new

    extern task body();

    sincos_seqi                     sincos_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task sincos_base_seqc::body();
    repeat(100) begin
        `uvm_object_create(sincos_seqi, sincos_seqi_h)
        start_item(sincos_seqi_h);
            assert(sincos_seqi_h.randomize());
        finish_item(sincos_seqi_h);
    end
endtask