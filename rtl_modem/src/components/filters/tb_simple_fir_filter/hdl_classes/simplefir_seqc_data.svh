//--------------------------------------------------------------------------------------------------------------------------------
// name : simplefir_seqc_data
//--------------------------------------------------------------------------------------------------------------------------------
class simplefir_seqc_data #(
      SAMPLE_DW = 32
) extends uvm_sequence #(raxi_seqi);
    `uvm_object_param_utils(simplefir_seqc_data #(SAMPLE_DW))
    `uvm_object_new

    extern task body();

    localparam D_MAX = 2**(SAMPLE_DW) - 1;
    localparam D_MIN = 2**(SAMPLE_DW-1);

    raxi_seqi                           raxi_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task simplefir_seqc_data::body();
    bit[SAMPLE_DW-1:0] data;

    `uvm_object_create(raxi_seqi, raxi_seqi_h);

    repeat (1000) begin
        start_item(raxi_seqi_h);
            raxi_seqi_h.valid = $urandom_range(0, 1);
            if (raxi_seqi_h.valid == 1) begin
                data = $urandom_range(0, D_MAX) - D_MIN;
            end
            raxi_seqi_h.data = {<<{data}};
        finish_item(raxi_seqi_h);
    end
endtask