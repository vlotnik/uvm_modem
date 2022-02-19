//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_seqi #(
      GP_DW = 10
    , A_DW = 12
    , B_DW = 12
) extends raxi_seqi;
    `uvm_object_param_utils(compmult_seqi #(GP_DW, A_DW, B_DW))
    `uvm_object_new

    extern function void post_randomize();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);

    // rAXI converters
    extern function void raxi2this_i(raxi_seqi raxi_seqi_h);
    extern function void raxi2this_o(raxi_seqi raxi_seqi_h);

    // data to string converters
    extern function string i2string();
    extern function string o2string();

    localparam RAXI_DATA_DWIDTH_I = GP_DW + A_DW*2 + B_DW*2;
    localparam C_W = A_DW + B_DW + 1;
    localparam RAXI_DATA_DWIDTH_O = GP_DW + C_W*2;
    localparam GP_MAX = 2**(GP_DW) - 1;
    localparam A_ABS_MIN = 2**(A_DW - 1);
    localparam A_ABS_MAX = 2**(A_DW) - 1;
    localparam B_ABS_MIN = 2**(B_DW - 1);
    localparam B_ABS_MAX = 2**(B_DW) - 1;

    int iiq_v;
    int igp;
    t_iq iiqa;
    t_iq iiqb;
    int ogp;
    int oiq_v;
    t_iq oiq;

    bit[A_DW-1:0]                       raxi_data_iiqa_i;
    bit[A_DW-1:0]                       raxi_data_iiqa_q;
    bit[B_DW-1:0]                       raxi_data_iiqb_i;
    bit[B_DW-1:0]                       raxi_data_iiqb_q;
    bit[GP_DW-1:0]                      raxi_data_igp;
    bit[RAXI_DATA_DWIDTH_I-1:0]         raxi_data_i;
    bit[C_W-1:0]                        raxi_data_oiq_i;
    bit[C_W-1:0]                        raxi_data_oiq_q;
    bit[GP_DW-1:0]                      raxi_data_ogp;
    bit[RAXI_DATA_DWIDTH_O-1:0]         raxi_data_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_seqi::post_randomize();
    iiq_v = $urandom_range(0, 1);
    if (iiq_v == 1) begin
        igp = $urandom_range(0, GP_MAX);
        iiqa.i = $urandom_range(0, A_ABS_MAX) - A_ABS_MIN;
        iiqa.q = $urandom_range(0, A_ABS_MAX) - A_ABS_MIN;
        iiqb.i = $urandom_range(0, B_ABS_MAX) - B_ABS_MIN;
        iiqb.q = $urandom_range(0, B_ABS_MAX) - B_ABS_MIN;
    end

    // rAXI
    raxi_data_iiqa_i = iiqa.i;
    raxi_data_iiqa_q = iiqa.q;
    raxi_data_iiqb_i = iiqb.i;
    raxi_data_iiqb_q = iiqb.q;
    raxi_data_igp = igp;
    raxi_data_i = {raxi_data_igp, raxi_data_iiqb_q, raxi_data_iiqb_i, raxi_data_iiqa_q, raxi_data_iiqa_i};
    this.valid = iiq_v;
    this.data = {<<{raxi_data_i}};
endfunction

function void compmult_seqi::raxi2this_i(raxi_seqi raxi_seqi_h);
    raxi_data_i = {<<{raxi_seqi_h.data}};
    {raxi_data_igp, raxi_data_iiqb_q, raxi_data_iiqb_i, raxi_data_iiqa_q, raxi_data_iiqa_i} = raxi_data_i;

    this.iiq_v = raxi_seqi_h.valid;
    this.iiqa.i = $signed(raxi_data_iiqa_i);
    this.iiqa.q = $signed(raxi_data_iiqa_q);
    this.iiqb.i = $signed(raxi_data_iiqb_i);
    this.iiqb.q = $signed(raxi_data_iiqb_q);
    this.igp = raxi_data_igp;
endfunction

function void compmult_seqi::raxi2this_o(raxi_seqi raxi_seqi_h);
    raxi_data_o = {<<{raxi_seqi_h.data}};
    {raxi_data_ogp, raxi_data_oiq_q, raxi_data_oiq_i} = raxi_data_o;

    this.oiq_v = raxi_seqi_h.valid;
    this.oiq.i = $signed(raxi_data_oiq_i);
    this.oiq.q = $signed(raxi_data_oiq_q);
    this.ogp = raxi_data_ogp;
endfunction

function string compmult_seqi::i2string();
    string s_v;
    string s_gp;
    string s_a;
    string s_b;
    string s;

    s_v = $sformatf("valid = %0d", iiq_v);
    s_gp = $sformatf("GP = %0d", igp);
    if (iiqa.q >= 0)
        s_a = $sformatf("|A = %0d + j * %0d|", iiqa.i, iiqa.q);
    else
        s_a = $sformatf("|A = %0d - j * %0d|", iiqa.i, -iiqa.q);
    if (iiqb.q >= 0)
        s_b = $sformatf("|B = %0d + j * %0d|", iiqb.i, iiqb.q);
    else
        s_b = $sformatf("|B = %0d - j * %0d|", iiqb.i, -iiqb.q);

    s = {s_v, " ", s_gp, " ", s_a, " ", s_b};
    return s;
endfunction

function string compmult_seqi::o2string();
    string s_v;
    string s_gp;
    string s_c;
    string s;

    s_v = $sformatf("valid = %0d", oiq_v);
    s_gp = $sformatf("GP = %0d", ogp);
    if (oiq.q >= 0)
        s_c = $sformatf("|C = %0d + j * %0d|", oiq.i, oiq.q);
    else
        s_c = $sformatf("|C = %0d - j * %0d|", oiq.i, -oiq.q);

    s = {s_v, " ", s_gp, " ", s_c};
    return s;
endfunction

function bit compmult_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    compmult_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (
           oiq_v == RHS.oiq_v
        && ogp == RHS.ogp
        && oiq.i == RHS.oiq.i
        && oiq.q == RHS.oiq.q
    ) && same;
    return same;
endfunction