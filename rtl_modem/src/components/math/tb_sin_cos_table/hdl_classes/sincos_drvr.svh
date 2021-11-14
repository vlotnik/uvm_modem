//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_drvr
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_drvr extends uvm_driver #(sincos_seqi);
    `uvm_component_utils(sincos_drvr)
    `uvm_component_new

    extern task run_phase(uvm_phase phase);

    virtual sincos_bfm              sincos_bfm_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task sincos_drvr::run_phase(uvm_phase phase);
    sincos_seqi sincos_seqi_h;

    forever begin
        seq_item_port.get_next_item(sincos_seqi_h);

            foreach(sincos_seqi_h.phase_v[i]) begin
                @(posedge sincos_bfm_h.iclk)
                sincos_bfm_h.iv <= sincos_seqi_h.phase_v[i];
                if (sincos_seqi_h.phase_v[i] == 1'b1)
                    sincos_bfm_h.iphase <= sincos_seqi_h.phase[11:0];

                if (sincos_bfm_h.ov == 1) begin
                    sincos_seqi_h.sin = $signed(sincos_bfm_h.osin);
                    sincos_seqi_h.cos = $signed(sincos_bfm_h.ocos);
                end
            end

        seq_item_port.item_done();
    end
endtask