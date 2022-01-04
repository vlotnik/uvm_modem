//--------------------------------------------------------------------------------------------------------------------------------
// name : simplefir_seqc_data
//--------------------------------------------------------------------------------------------------------------------------------
class simplefir_seqc_data #(
      G_SAMPLE_DW = 32
) extends uvm_sequence #(raxi_seqi);
    `uvm_object_param_utils(simplefir_seqc_data #(G_SAMPLE_DW))
    `uvm_object_new

    extern task pre_body();
    extern task body();

    localparam D_MAX = 2**(G_SAMPLE_DW) - 1;
    localparam D_MIN = 2**(G_SAMPLE_DW-1);

    raxi_seqi                           raxi_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task simplefir_seqc_data::pre_body();
    `uvm_object_create(raxi_seqi, raxi_seqi_h);
endtask

task simplefir_seqc_data::body();
    bit[G_SAMPLE_DW-1:0] data;

    repeat (1001) begin
        start_item(raxi_seqi_h);
            raxi_seqi_h.valid = $urandom_range(1, 1);
            if (raxi_seqi_h.valid == 1) begin
                data = $urandom_range(0, D_MAX) - D_MIN;
            end
            raxi_seqi_h.data = {<<{data}};
        finish_item(raxi_seqi_h);
    end
endtask