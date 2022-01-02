//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_base_seqc
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_base_seqc extends uvm_sequence #(datagen_seqi);
    `uvm_object_utils(dsp_base_seqc)
    `uvm_object_new

    extern task pre_body();
    extern task body();

    extern function void copy_item();

    // transactions
    datagen_seqi                        datagen_seqi_i;
    datagen_seqi                        datagen_seqi_o;

    // sequencer
    datagen_seqr                        datagen_seqr_h;

    // analysis ports
    datagen_aprt                        datagen_aprt_i;
    datagen_aprt                        datagen_aprt_o;

    // bitstream
    bit random_data = 1;
    bit bitstream[];

    // datagen_seqi settings
    int                                 tr_channel = 0;
    bit                                 tr_idle = 0;
    bit                                 tr_last = 0;
    int                                 tr_modcod = 0;
    int                                 tr_modcod_n = 0;
    int                                 tr_pldsz = 1024;
    int                                 tr_nofs = 0;
    int                                 tr_frsz = 0;
    int                                 tr_pause_sz = 0;
    t_modulation                        tr_mod = BPSK;
    real                                tr_fsk_dev = 1.0;
    real                                tr_gain = 1.0;
    int                                 tr_power = 0;
    real                                tr_snr = 200;
    real                                tr_sym_f = 1.0;
    real                                tr_sys_f = 4.0;
    real                                tr_rsmp_f = 2.0;
    real                                tr_rsmp_ps = 0.0;
    real                                tr_car_f = 0.0;
    real                                tr_car_ps = 0.0;
    int                                 tr_time = 0;

    // others
    int sym_ptr = 0;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task dsp_base_seqc::pre_body();
    `uvm_object_create(datagen_seqi, datagen_seqi_i)
endtask

task dsp_base_seqc::body();
    if (random_data == 1) begin
        bitstream = new[tr_pldsz];
        foreach (bitstream[ii]) begin
            bitstream[ii] = $urandom_range(0, 1);
        end
    end

    datagen_seqi_i.bitstream            = bitstream;
    datagen_seqi_i.tr_pldsz             = tr_pldsz;
    datagen_seqi_i.tr_channel           = tr_channel;
    datagen_seqi_i.tr_idle              = tr_idle;
    datagen_seqi_i.tr_last              = tr_last;
    datagen_seqi_i.tr_modcod            = tr_modcod;
    datagen_seqi_i.tr_modcod_n          = tr_modcod_n;
    datagen_seqi_i.tr_pldsz             = tr_pldsz;
    datagen_seqi_i.tr_nofs              = tr_nofs;
    datagen_seqi_i.tr_pause_sz          = tr_pause_sz;
    datagen_seqi_i.tr_mod               = tr_mod;
    datagen_seqi_i.tr_fsk_dev           = tr_fsk_dev;
    datagen_seqi_i.tr_gain              = tr_gain;
    datagen_seqi_i.tr_snr               = tr_snr;
    datagen_seqi_i.tr_sym_f             = tr_sym_f;
    datagen_seqi_i.tr_rsmp_f            = tr_rsmp_f;
    datagen_seqi_i.tr_sys_f             = tr_sys_f;
    datagen_seqi_i.tr_car_f             = tr_car_f;
    datagen_seqi_i.tr_car_ps            = tr_car_ps;
    datagen_seqi_i.tr_time              = tr_time;

    start_item(datagen_seqi_i);
        `uvm_info(get_name(), $sformatf("\npong sequence with %s", datagen_seqi_i.convert2string()), UVM_HIGH);
    finish_item(datagen_seqi_i);
endtask

function void dsp_base_seqc::copy_item();
    `uvm_object_create(datagen_seqi, datagen_seqi_o)
    datagen_seqi_o.copy(datagen_seqi_i);
endfunction