//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_seqc_sym_framer
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_seqc_sym_framer extends dsp_base_seqc;
    `uvm_object_utils(dsp_seqc_sym_framer)
    `uvm_object_new

    extern task body();

    // create symbol array
    int symsz = 1;
    int digit = 0;

    // settings
    bit bit_order = 0;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_seqc_sym_framer::body();
    forever begin
        datagen_seqr_h.get_next_item(datagen_seqi_i);
        // get settings from input transaction
        this.tr_mod = datagen_seqi_i.tr_mod;
        this.tr_pldsz = datagen_seqi_i.tr_pldsz;
        // calculate other settings
        symsz = pkg_modem::get_modulation_settings(this.tr_mod).symbol_size;
        this.tr_frsz = this.tr_pldsz % symsz == 0 ? this.tr_pldsz / symsz : this.tr_pldsz / symsz + 1;

        // create new transaction
        copy_item();
        datagen_seqi_o.iq_sym = new[tr_frsz];
        sym_ptr = 0;
        for (int ptr = 0; ptr < this.tr_pldsz; ptr++) begin
            sym_ptr = ptr / symsz;
            if (bit_order == 0)
                // MSB first
                digit = (symsz - 1) - ptr % symsz;
            else
                // LSB first
                digit = ptr % symsz;
            datagen_seqi_o.iq_sym[sym_ptr] += datagen_seqi_o.bitstream[ptr] << digit;
        end

        datagen_seqi_o.iq_v = new[datagen_seqi_o.iq_sym.size()];
        for (int ii = 0; ii < datagen_seqi_o.iq_sym.size(); ii++) begin
            datagen_seqi_o.iq_v[ii] = new[1];
            datagen_seqi_o.iq_v[ii][0] = 1;
        end

        // apply settings to output transcation
        datagen_seqi_o.tr_frsz = this.tr_frsz;

        start_item(datagen_seqi_o);
        finish_item(datagen_seqi_o);
        datagen_seqr_h.item_done();
    end
endtask