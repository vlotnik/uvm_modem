//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_base_seqc extends uvm_sequence #(datagen_seqi);
    `uvm_object_utils(dsp_base_seqc)
    `uvm_object_new

    extern task body();

    // base transaction
    datagen_seqi                    datagen_seqi_i;
    datagen_seqi                    datagen_seqi_o;
    datagen_seqr                    datagen_seqr_h;

    extern function void copy_item();

    // create bit stream
    bit random_data = 1;
    bit bitstream[];

    // settings
    int                             tr_pldsz = 1024;
    t_modulation                    tr_mod = BPSK;
    real                            tr_sym_f = 1.0;
    real                            tr_rsmp_f = 2.0;
    real                            tr_car_f = 0.0;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_base_seqc::body();
    `uvm_object_create(datagen_seqi, datagen_seqi_i)

    if (random_data == 1) begin
        bitstream = new[tr_pldsz];
        datagen_seqi_i.bitstream = this.bitstream;
        assert(datagen_seqi_i.randomize());
        datagen_seqi_i.tr_pldsz = tr_pldsz;
    end else begin
        datagen_seqi_i.bitstream = this.bitstream;
        datagen_seqi_i.tr_pldsz = this.bitstream.size;
    end

    // other settings
    datagen_seqi_i.tr_mod           = tr_mod;
    datagen_seqi_i.tr_sym_f         = tr_sym_f;
    datagen_seqi_i.tr_rsmp_f        = tr_rsmp_f;
    datagen_seqi_i.tr_car_f         = tr_car_f;

    start_item(datagen_seqi_i);
    finish_item(datagen_seqi_i);
endtask

function void dsp_base_seqc::copy_item();
    `uvm_object_create(datagen_seqi, datagen_seqi_o)
    datagen_seqi_o.copy(datagen_seqi_i);
endfunction