//--------------------------------------------------------------------------------------------------------------------------------
// name : if_ddc_drvr
//--------------------------------------------------------------------------------------------------------------------------------
class if_ddc_drvr #(
          INCH_NUMBER = 1
        , SIGNAL_TYPE = 1
    ) extends uvm_driver #(datagen_seqi);
    `uvm_component_utils(if_ddc_drvr #(INCH_NUMBER, SIGNAL_TYPE))
    `uvm_component_new

    extern task run_phase(uvm_phase phase);

    virtual if_ddc_bfm #(
          .INCH_NUMBER(INCH_NUMBER)
        , .SIGNAL_TYPE(SIGNAL_TYPE)
    )                               if_ddc_bfm_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task if_ddc_drvr::run_phase(uvm_phase phase);
    datagen_seqi                    datagen_seqi_h;

    forever begin
        seq_item_port.get_next_item(datagen_seqi_h);
            $display("modulation: %s", pkg_modem::get_modulation_settings(datagen_seqi_h.tr_mod).name);
            $display("bitstream: %p", datagen_seqi_h.bitstream);
            $display("symbols: %p", datagen_seqi_h.iq_sym);
            $display("IQ I: %p", datagen_seqi_h.iq_i);
            $display("IQ Q: %p", datagen_seqi_h.iq_q);
            $display("\n");
        seq_item_port.item_done();
    end
endtask