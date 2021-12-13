//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_seqi extends uvm_sequence_item;
    `uvm_object_param_utils(raxi_seqi)
    `uvm_object_new

    extern function string convert2string();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);

    bit rst;
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

function bit raxi_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    raxi_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (
           valid == RHS.valid
        && data == RHS.data
    ) && same;
    return same;
endfunction