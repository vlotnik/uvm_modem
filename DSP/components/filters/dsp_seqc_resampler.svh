//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_seqc_resampler
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_seqc_resampler extends dsp_base_seqc;
    `uvm_object_utils(dsp_seqc_resampler)
    `uvm_object_new

    extern task pre_body();
    extern task body();

    // settings
    real beta = 0.35;
    real cutoff = 0.5;
    real filter_length = 15;
    real num_of_phases = 4096;

    filter_design                       filter_design_h;
    real fir_coefficients[];

    fir_resampler                       fir_resampler_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_seqc_resampler::pre_body();
    super.pre_body();

    filter_design_h = new();
    filter_design_h.get_coefs_rcos(beta, cutoff / num_of_phases, filter_length * num_of_phases, fir_coefficients);
    `uvm_object_create(fir_resampler, fir_resampler_h)
    fir_resampler_h.set_coefficients(fir_coefficients, filter_length, num_of_phases);
endtask


task dsp_seqc_resampler::body();
    forever begin
        datagen_seqr_h.get_next_item(datagen_seqi_i);

        copy_item();

        fir_resampler_h.resample(datagen_seqi_o);

        start_item(datagen_seqi_o);
            `uvm_info(get_name(), $sformatf("\npong sequence with %s", datagen_seqi_o.convert2string()), UVM_HIGH);
        finish_item(datagen_seqi_o);
        datagen_seqr_h.item_done();
    end
endtask