//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_seqi extends uvm_sequence_item;
    `uvm_object_param_utils(raxi_seqi)
    `uvm_object_new

    extern function string convert2string();

    bit valid;
    bit data[];
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function string raxi_seqi::convert2string();
    string s_v;
    string s_d;
    string s;

    s_v = $sformatf("valid = %0d", valid);
    s_d = $sformatf("data = %0p", data);

    s = {s_v, " ", s_d};
    return s;
endfunction