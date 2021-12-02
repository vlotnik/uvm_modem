//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_drvr
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_drvr #(
      DATA_WIDTH = 10
) extends uvm_driver #(raxi_seqi);
    `uvm_component_param_utils(raxi_drvr #(DATA_WIDTH))
    `uvm_component_new

    extern task run_phase(uvm_phase phase);

    virtual raxi_bfm #(
          .DATA_WIDTH(DATA_WIDTH)
    )                               raxi_bfm_h;
    raxi_seqi                       raxi_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task raxi_drvr::run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(raxi_seqi_h);

            @(posedge raxi_bfm_h.clk)
            raxi_bfm_h.valid <= raxi_seqi_h.valid;
            if (raxi_seqi_h.valid == 1) begin
                raxi_bfm_h.data <= {<<{raxi_seqi_h.data}};
                // foreach (raxi_seqi_h.data[ii])
                //     raxi_bfm_h.data[ii] <= raxi_seqi_h.data[ii];
            end

        seq_item_port.item_done();
    end
endtask