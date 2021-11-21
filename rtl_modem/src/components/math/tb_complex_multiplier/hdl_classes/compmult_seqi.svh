//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_seqi #(
      A_DW = 12
    , B_DW = 12
) extends uvm_sequence_item;
    `uvm_object_param_utils(compmult_seqi #(A_DW, B_DW))
    `uvm_object_new

    extern function void post_randomize();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string i2string();
    extern function string o2string();

    localparam A_ABS_MIN = 2**(A_DW - 1);
    localparam A_ABS_MAX = 2**(A_DW) - 1;
    localparam B_ABS_MIN = 2**(B_DW - 1);
    localparam B_ABS_MAX = 2**(B_DW) - 1;

    int iv;
    int ia_i;
    int ia_q;
    int ib_i;
    int ib_q;
    int ov;
    int oc_i;
    int oc_q;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_seqi::post_randomize();
    iv = $urandom_range(0, 1);
    if (iv == 1) begin
        ia_i = $urandom_range(0, A_ABS_MAX) - A_ABS_MIN;
        ia_q = $urandom_range(0, A_ABS_MAX) - A_ABS_MIN;
        ib_i = $urandom_range(0, B_ABS_MAX) - B_ABS_MIN;
        ib_q = $urandom_range(0, B_ABS_MAX) - B_ABS_MIN;
    end
endfunction

function string compmult_seqi::i2string();
    string s_iv;
    string s_a;
    string s_b;
    string s;

    s_iv = $sformatf("iv = %1d", iv);
    if (ia_q >= 0)
        s_a = $sformatf("|A = %0d + j * %0d|", ia_i, ia_q);
    else
        s_a = $sformatf("|A = %0d - j * %0d|", ia_i, -ia_q);
    if (ib_q >= 0)
        s_b = $sformatf("|B = %0d + j * %0d|", ib_i, ib_q);
    else
        s_b = $sformatf("|B = %0d - j * %0d|", ib_i, -ib_q);

    s = {s_iv, " ", s_a, " ", s_b};

    return s;
endfunction

function string compmult_seqi::o2string();
    string s_ov;
    string s_c;
    string s;

    s_ov = $sformatf("ov = %1d", ov);
    if (oc_q >= 0)
        s_c = $sformatf("|C = %0d + j * %0d|", oc_i, oc_q);
    else
        s_c = $sformatf("|C = %0d - j * %0d|", oc_i, -oc_q);

    s = {s_ov, " ", s_c};

    return s;
endfunction

function bit compmult_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    compmult_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (
           ov == RHS.ov
        && oc_i == RHS.oc_i
        && oc_q == RHS.oc_q
    ) && same;
    return same;
endfunction