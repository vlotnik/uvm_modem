//--------------------------------------------------------------------------------------------------------------------------------
// name : basemod_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class basemod_base_seqc extends dsp_base_seqc;
    `uvm_object_utils(basemod_base_seqc)
    `uvm_object_new

    extern task body();

    dsp_base_seqc                   dsp_base_seqc_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task basemod_base_seqc::body();
    forever begin
        `uvm_object_create(dsp_base_seqc, dsp_base_seqc_h)

        dsp_base_seqc_h.tr_pldsz    = tr_pldsz;
        dsp_base_seqc_h.tr_mod      = tr_mod;
        dsp_base_seqc_h.tr_sym_f    = tr_sym_f;
        dsp_base_seqc_h.tr_rsmp_f   = tr_rsmp_f;
        dsp_base_seqc_h.tr_car_f    = tr_car_f;

        dsp_base_seqc_h.start(datagen_seqr_h, this);
    end
endtask