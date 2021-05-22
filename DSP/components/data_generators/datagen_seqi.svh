//--------------------------------------------------------------------------------------------------------------------------------
// name : datagen_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class datagen_seqi extends uvm_sequence_item;
    `uvm_object_utils(datagen_seqi)
    `uvm_object_new

    // data
    rand bit                        bitstream[];
    int                             iq_sym[];
    real                            iq_i[];
    real                            iq_q[];

    // settings
    int                             tr_pldsz = 0;           // payload size
    int                             tr_frsz = 0;            // frames size
    t_modulation                    tr_mod = BPSK;          // modulation
    real                            tr_sym_f = 1.0;         // symbol frequency
    real                            tr_rsmp_f = 2.0;        // resampling frequency

    extern function void do_copy(uvm_object rhs);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void datagen_seqi::do_copy(uvm_object rhs);
    datagen_seqi that;

    if (!$cast(that, rhs)) begin
        `uvm_fatal(get_name(), "Type cast error");
    end

    super.do_copy(rhs);
    this.bitstream                  = that.bitstream;
    this.iq_sym                     = that.iq_sym;
    this.iq_i                       = that.iq_i;
    this.iq_q                       = that.iq_q;
    this.tr_pldsz                   = that.tr_pldsz;
    this.tr_frsz                    = that.tr_frsz;
    this.tr_mod                     = that.tr_mod;
    this.tr_sym_f                   = that.tr_sym_f;
    this.tr_rsmp_f                  = that.tr_rsmp_f;
endfunction