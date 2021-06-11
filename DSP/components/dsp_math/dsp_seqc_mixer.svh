//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_seqc_mixer
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_seqc_mixer extends dsp_base_seqc;
    `uvm_object_utils(dsp_seqc_mixer)
    `uvm_object_new

    extern task body();

    dspmath_mixer                   dspmath_mixer_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_seqc_mixer::body();
    `uvm_object_create(dspmath_mixer, dspmath_mixer_h)

    forever begin
        datagen_seqr_h.get_next_item(datagen_seqi_i);
        copy_item();

        dspmath_mixer_h.mix(datagen_seqi_o);

        start_item(datagen_seqi_o);
        finish_item(datagen_seqi_o);
        datagen_seqr_h.item_done();
    end
endtask