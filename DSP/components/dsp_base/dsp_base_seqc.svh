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
    int pldsz = 0;
    bit bitstream[];

    // settings
    int tr_pldsz = 1024;
    t_modulation tr_mod = BPSK;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_base_seqc::body();
    `uvm_object_create(datagen_seqi, datagen_seqi_i)

    if (random_data == 1) begin
        pldsz = tr_pldsz;
        assert(datagen_seqi_i.randomize() with {
                bitstream.size() inside {pldsz};
            });
        datagen_seqi_i.tr_pldsz = pldsz;
    end else begin
        datagen_seqi_i.bitstream = this.bitstream;
        datagen_seqi_i.tr_pldsz = this.bitstream.size;
    end

    // other settings
    datagen_seqi_i.tr_mod = tr_mod;

    start_item(datagen_seqi_i);
    finish_item(datagen_seqi_i);
endtask

function void dsp_base_seqc::copy_item();
    `uvm_object_create(datagen_seqi, datagen_seqi_o)
    datagen_seqi_o.copy(datagen_seqi_i);
endfunction