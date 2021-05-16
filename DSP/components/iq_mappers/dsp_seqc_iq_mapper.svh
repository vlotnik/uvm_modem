//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_seqc_iq_mapper
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_seqc_iq_mapper extends dsp_base_seqc;
    `uvm_object_utils(dsp_seqc_iq_mapper)
    `uvm_object_new

    extern task body();

    iqmap                           iqmap_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_seqc_iq_mapper::body();
    `uvm_object_create(iqmap, iqmap_h)

    forever begin
        datagen_seqr_h.get_next_item(datagen_seqi_i);
        copy_item();

        iqmap_h.get_iq(datagen_seqi_o);

        start_item(datagen_seqi_o);
        finish_item(datagen_seqi_o);
        datagen_seqr_h.item_done();
    end
endtask