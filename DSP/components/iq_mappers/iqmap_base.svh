//--------------------------------------------------------------------------------------------------------------------------------
// name : iqmap_base
//--------------------------------------------------------------------------------------------------------------------------------
class iqmap_base extends uvm_object;
    `uvm_object_utils(iqmap_base)
    `uvm_object_new

    // this array will be used to fill I/Q data
    real plane[];

    virtual function void init_plane(t_modulation mod);
    endfunction

    extern function void get_iq(ref datagen_seqi datagen_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void iqmap_base::get_iq(ref datagen_seqi datagen_seqi_h);
    // initialize plane for selected modulation
    init_plane(datagen_seqi_h.tr_mod);

    // fill I/Q data
    for (int ii = 0; ii < datagen_seqi_h.iq_sym.size(); ii++) begin
        datagen_seqi_h.iq_i[ii] = plane[2 * datagen_seqi_h.iq_sym[ii] + 0];
        datagen_seqi_h.iq_q[ii] = plane[2 * datagen_seqi_h.iq_sym[ii] + 1];
    end
endfunction