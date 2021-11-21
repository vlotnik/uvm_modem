//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_drvr
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_drvr #(
      A_DW = 12
    , B_DW = 12
) extends uvm_driver #(compmult_seqi);
    `uvm_component_param_utils(compmult_drvr #(A_DW, B_DW))
    `uvm_component_new

    extern task run_phase(uvm_phase phase);

    virtual compmult_bfm #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_bfm_h;
    compmult_seqi                       compmult_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task compmult_drvr::run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(compmult_seqi_h);

            @(posedge compmult_bfm_h.iclk)
            compmult_bfm_h.iv <= compmult_seqi_h.iv;
            if (compmult_seqi_h.iv == 1) begin
                compmult_bfm_h.ia_i <= compmult_seqi_h.ia_i;
                compmult_bfm_h.ia_q <= compmult_seqi_h.ia_q;
                compmult_bfm_h.ib_i <= compmult_seqi_h.ib_i;
                compmult_bfm_h.ib_q <= compmult_seqi_h.ib_q;
            end

        seq_item_port.item_done();
    end
endtask