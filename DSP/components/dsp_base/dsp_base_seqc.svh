class dsp_base_seqc extends uvm_sequence #(datagen_seqi);
    `uvm_object_utils(dsp_base_seqc)
    `uvm_object_new

    extern task body();

    // base transaction
    datagen_seqi                    datagen_seqi_i;

    // settings
    int tr_pldsz = 1024;
    bit random_data = 1;
    bit bitstream[];
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_base_seqc::body();
    `uvm_object_create(datagen_seqi, datagen_seqi_i)

    if (random_data == 1)
        assert(datagen_seqi_i.randomize() with {
                bitstream.size() inside {tr_pldsz};
            });
    else
        datagen_seqi_i.bitstream = this.bitstream;

    datagen_seqi_i.tr_pldsz = tr_pldsz;

    start_item(datagen_seqi_i);
    finish_item(datagen_seqi_i);
endtask