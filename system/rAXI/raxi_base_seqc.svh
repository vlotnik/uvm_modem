//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_base_seqc #(
      DW = 32
) extends uvm_sequence #(raxi_seqi);
    `uvm_object_param_utils(raxi_base_seqc #(DW))
    `uvm_object_new

    extern task pre_body();
    extern task body();

    int nof_repeats = 100;

    raxi_seqi                           raxi_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task raxi_base_seqc::pre_body();
    `uvm_object_create(raxi_seqi, raxi_seqi_h);
endtask

task raxi_base_seqc::body();
    bit[DW-1:0] data;

    repeat (nof_repeats) begin
        start_item(raxi_seqi_h);
            raxi_seqi_h.valid = $urandom_range(0, 1);
            if (raxi_seqi_h.valid == 1) begin
                for (int ii = 0; ii < DW; ii++)
                    data[ii] = $urandom_range(0, 1);
            end
            raxi_seqi_h.data = {<<{data}};
        finish_item(raxi_seqi_h);
    end
endtask