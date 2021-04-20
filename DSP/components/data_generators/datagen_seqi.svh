class datagen_seqi extends uvm_sequence_item;
    `uvm_object_utils(datagen_seqi)
    `uvm_object_new

    // data
    rand bit                        bitstream[];
    int                             iq_sym[];

    // settings
    int                             tr_pldsz = 0;           // payload size
    int                             tr_frsz = 0;            // frames ize
    t_modulation                    tr_mod = BPSK;          // modulation

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
    this.tr_pldsz                   = that.tr_pldsz;
    this.tr_frsz                    = that.tr_frsz;
    this.tr_mod                     = that.tr_mod;
endfunction