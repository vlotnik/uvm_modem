//--------------------------------------------------------------------------------------------------------------------------------
// name : datagen_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class datagen_seqi extends uvm_sequence_item;
    `uvm_object_utils(datagen_seqi)
    `uvm_object_new

    // data
    bit                                 bitstream[];
    int                                 iq_sym[];
    t_modulation                        mod[];
    int                                 iq_i[];
    int                                 iq_q[];
    bit                                 iq_v[][];
    bit                                 sof[];
    bit                                 eof[];
    int                                 m[];
    bit[1:0]                            iq_scr[];
    int                                 ch[];

    // settings
    int                                 tr_channel = 0;                         // channel
    bit                                 tr_idle = 0;                            // idle transaction
    bit                                 tr_last = 0;                            // last transaction
    int                                 tr_modcod = 0;                          // modcod of the current transaction
    int                                 tr_modcod_n = 0;                        // modcod of the next transaction
    int                                 tr_pldsz = 0;                           // payload size
    int                                 tr_nofs = 0;                            // number of slots
    int                                 tr_frsz = 0;                            // frame size
    int                                 tr_pause_sz = 0;                        // pause size
    t_modulation                        tr_mod = BPSK;                          // modulation
    real                                tr_fsk_dev = 1.0;                       // FSK deviation
    real                                tr_gain = 1.0;                          // gain
    int                                 tr_power = 0;                           // power
    real                                tr_snr = 200.0;                         // signal-to-noise ratio
    real                                tr_sym_f = 1.0;                         // symbol frequency
    real                                tr_sys_f = 1.0;                         // system frequency
    real                                tr_rsmp_f = 2.0;                        // resampling frequency
    real                                tr_rsmp_ps = 0.0;                       // resampling phase shift
    real                                tr_car_f = 0.0;                         // carrier frequency
    real                                tr_car_ps = 0.0;                        // carrier phase shift
    int                                 tr_time = 0;                            // time

    extern function void new_seqi(int size);
    extern function void do_copy(uvm_object rhs);

    extern function string convert2string();
    extern function string convert2string_mux(int dmps = 0);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void datagen_seqi::new_seqi(int size);
    iq_sym                              = new[size];
    mod                                 = new[size];
    iq_v                                = new[size];
    iq_i                                = new[size];
    iq_q                                = new[size];
    sof                                 = new[size];
    eof                                 = new[size];
    m                                   = new[size];
    iq_scr                              = new[size];
    ch                                  = new[size];
endfunction

function void datagen_seqi::do_copy(uvm_object rhs);
    datagen_seqi that;

    if (!$cast(that, rhs)) begin
        `uvm_fatal(get_name(), "Type cast error");
    end

    super.do_copy(rhs);
    this.bitstream                      = that.bitstream;
    this.mod                            = that.mod;
    this.iq_sym                         = that.iq_sym;
    this.iq_v                           = that.iq_v;
    this.iq_i                           = that.iq_i;
    this.iq_q                           = that.iq_q;
    this.sof                            = that.sof;
    this.eof                            = that.eof;
    this.m                              = that.m;
    this.iq_scr                         = that.iq_scr;
    this.ch                             = that.ch;
    this.tr_channel                     = that.tr_channel;
    this.tr_idle                        = that.tr_idle;
    this.tr_last                        = that.tr_last;
    this.tr_modcod                      = that.tr_modcod;
    this.tr_modcod_n                    = that.tr_modcod_n;
    this.tr_pldsz                       = that.tr_pldsz;
    this.tr_nofs                        = that.tr_nofs;
    this.tr_frsz                        = that.tr_frsz;
    this.tr_pause_sz                    = that.tr_pause_sz;
    this.tr_mod                         = that.tr_mod;
    this.tr_fsk_dev                     = that.tr_fsk_dev;
    this.tr_gain                        = that.tr_gain;
    this.tr_power                       = that.tr_power;
    this.tr_snr                         = that.tr_snr;
    this.tr_sym_f                       = that.tr_sym_f;
    this.tr_rsmp_f                      = that.tr_rsmp_f;
    this.tr_sys_f                       = that.tr_sys_f;
    this.tr_car_f                       = that.tr_car_f;
    this.tr_car_ps                      = that.tr_car_ps;
    this.tr_time                        = that.tr_time;
endfunction

function string datagen_seqi::convert2string();
    string result;

    result = "";
    if (tr_idle == 1)
        result = {result, $sformatf("tr_idle = %b", tr_idle)};
    if (tr_last == 1)
        result = {result, $sformatf(", tr_last = %b", tr_last)};
    result = {result, $sformatf(", tr_time = %0d", tr_time)};
    result = {result, $sformatf(", tr_channel = %0d", tr_channel)};
    result = {result, $sformatf(", tr_modcod = %0d", tr_modcod)};
    result = {result, $sformatf(", tr_pldsz = %0d bit", tr_pldsz)};
    result = {result, $sformatf(", tr_mod = %0s", tr_mod)};
    result = {result, $sformatf(", tr_fsk_dev = %0.2f", tr_fsk_dev)};
    result = {result, $sformatf(", tr_nofs = %0d", tr_nofs)};
    result = {result, $sformatf(", tr_frsz = %0d", tr_frsz)};
    result = {result, $sformatf(", tr_power = %0d", tr_power)};
    result = {result, $sformatf(", tr_snr = %0.2f dB", tr_snr)};
    result = {result, $sformatf(", tr_sys_f = %0.6f", tr_sys_f)};
    result = {result, $sformatf(", tr_sym_f = %0.6f", tr_sym_f)};
    result = {result, $sformatf(", tr_car_f = %0.6f", tr_car_f)};

    return result;
endfunction

function string datagen_seqi::convert2string_mux(int dmps = 0);
    string result;

    result = "";
    case (dmps)
        0 : result = {result, $sformatf("\nbitstream = %p", bitstream)};
        1 : result = {result, $sformatf("\niq_sym    = %p", iq_sym)};
        2 : result = {result, $sformatf("\nmod       = %p", mod)};
        3 : result = {result, $sformatf("\niq_v      = %p", iq_v)};
        4 : result = {result, $sformatf("\niq_i      = %p", iq_i)};
        5 : result = {result, $sformatf("\niq_q      = %p", iq_q)};
        6 : result = {result, $sformatf("\nsof       = %p", sof)};
        7 : result = {result, $sformatf("\neof       = %p", eof)};
        8 : result = {result, $sformatf("\nm         = %p", m)};
        9 : result = {result, $sformatf("\niq scr    = %p", iq_scr)};
        10 : result = {result, $sformatf("\nch        = %p", ch)};
        default : result = {result, $sformatf("\nnbitstream = %p", bitstream)};
    endcase

    return result;
endfunction