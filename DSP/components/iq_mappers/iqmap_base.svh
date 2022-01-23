//--------------------------------------------------------------------------------------------------------------------------------
// name : iqmap_base
//--------------------------------------------------------------------------------------------------------------------------------
class iqmap_base extends uvm_object;
    `uvm_object_utils(iqmap_base)
    `uvm_object_new

    // settings
    int tr_frsz = 0;
    t_modulation tr_mod = BPSK;

    // this array will be used to fill I/Q data
    real plane[];

    // scale
    int iq_scale = 724;

    virtual function void init_plane(t_modulation mod);
    endfunction

    extern function void get_iq(ref datagen_seqi datagen_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void iqmap_base::get_iq(ref datagen_seqi datagen_seqi_h);
    // get settings from transaction
    tr_frsz = datagen_seqi_h.iq_sym.size;
    tr_mod = datagen_seqi_h.tr_mod;

    // initialize plane for selected modulation
    init_plane(tr_mod);

    // create arrays for I/Q
    datagen_seqi_h.iq_i = new[tr_frsz];
    datagen_seqi_h.iq_q = new[tr_frsz];

    // fill I/Q data
    for (int ii = 0; ii < tr_frsz; ii++) begin
        datagen_seqi_h.iq_i[ii] = $rtoi(iq_scale * plane[2 * datagen_seqi_h.iq_sym[ii] + 0]);
        datagen_seqi_h.iq_q[ii] = $rtoi(iq_scale * plane[2 * datagen_seqi_h.iq_sym[ii] + 1]);
    end
endfunction