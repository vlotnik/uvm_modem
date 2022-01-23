//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_seqc_iq_mapper
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_seqc_iq_mapper extends dsp_base_seqc;
    `uvm_object_utils(dsp_seqc_iq_mapper)
    `uvm_object_new

    extern task pre_body();
    extern task body();

    iqmap                               iqmap_h;

    // settings
    int mod_type;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_seqc_iq_mapper::pre_body();
    super.pre_body();

    `uvm_object_create(iqmap, iqmap_h)
endtask

task dsp_seqc_iq_mapper::body();
    forever begin
        datagen_seqr_h.get_next_item(datagen_seqi_i);

        copy_item();

        iqmap_h.get_iq(datagen_seqi_o);

        start_item(datagen_seqi_o);
            `uvm_info(get_name(), $sformatf("\niq mapper, I: %s", datagen_seqi_o.convert2string_mux(4)), UVM_HIGH);
            `uvm_info(get_name(), $sformatf("\niq mapper, Q: %s", datagen_seqi_o.convert2string_mux(5)), UVM_HIGH);
        finish_item(datagen_seqi_o);

        datagen_seqr_h.item_done();
    end
endtask