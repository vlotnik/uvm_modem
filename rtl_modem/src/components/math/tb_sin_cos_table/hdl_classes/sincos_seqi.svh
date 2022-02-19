//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_seqi #(
      GP_DW = 10
    , PHASE_DW = 12
    , SINCOS_DW = 12
) extends raxi_seqi;
    `uvm_object_utils(sincos_seqi #(GP_DW, PHASE_DW, SINCOS_DW))
    `uvm_object_new

    extern function void post_randomize();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);

    // rAXI converters
    extern function void raxi2this_i(raxi_seqi raxi_seqi_h);
    extern function void raxi2this_o(raxi_seqi raxi_seqi_h);

    // data to string converters
    extern function string i2string();
    extern function string o2string();

    localparam GP_MAX = 2**(GP_DW) - 1;
    localparam PHASE_MAX = 2**(PHASE_DW) - 1;

    localparam RAXI_DWI = GP_DW + PHASE_DW;
    localparam RAXI_DWO = GP_DW + SINCOS_DW*2;

    int igp;
    int iphase_v;
    int iphase;
    int ogp;
    int osincos_v;
    int osin;
    int ocos;

    bit[PHASE_DW-1:0]                    raxi_data_iphase;
    bit[GP_DW-1:0]                       raxi_data_igp;
    bit[RAXI_DWI-1:0]                   raxi_data_i;
    bit[SINCOS_DW-1:0]                   raxi_data_osin;
    bit[SINCOS_DW-1:0]                   raxi_data_ocos;
    bit[GP_DW-1:0]                       raxi_data_ogp;
    bit[RAXI_DWO-1:0]                   raxi_data_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_seqi::post_randomize();
    iphase_v = $urandom_range(0, 1);
    if (iphase_v == 1) begin
        igp = $urandom_range(0, GP_MAX);
        iphase = $urandom_range(0, PHASE_MAX);
    end

    // rAXI
    raxi_data_iphase = iphase;
    raxi_data_igp = igp;
    raxi_data_i = {raxi_data_igp, raxi_data_iphase};
    this.valid = iphase_v;
    this.data = {<<{raxi_data_i}};
endfunction

function void sincos_seqi::raxi2this_i(raxi_seqi raxi_seqi_h);
    raxi_data_i = {<<{raxi_seqi_h.data}};
    {raxi_data_igp, raxi_data_iphase} = raxi_data_i;

    this.iphase_v = raxi_seqi_h.valid;
    this.iphase = raxi_data_iphase;
    this.igp = raxi_data_igp;
endfunction

function void sincos_seqi::raxi2this_o(raxi_seqi raxi_seqi_h);
    raxi_data_o = {<<{raxi_seqi_h.data}};
    {raxi_data_ogp, raxi_data_ocos, raxi_data_osin} = raxi_data_o;

    this.osincos_v = raxi_seqi_h.valid;
    this.osin = $signed(raxi_data_osin);
    this.ocos = $signed(raxi_data_ocos);
    this.ogp = raxi_data_ogp;
endfunction

function string sincos_seqi::i2string();
    string s_v;
    string s_gp;
    string s_phase;
    string s;

    s_v = $sformatf("valid = %0d", iphase_v);
    s_gp = $sformatf("GP = %0d", igp);
    s_phase = $sformatf("phase = %0d", iphase);

    s = {s_v, " ", s_gp, " ", s_phase};
    return s;
endfunction

function string sincos_seqi::o2string();
    string s_v;
    string s_gp;
    string s_sin;
    string s_cos;
    string s;

    s_v = $sformatf("valid = %0d", osincos_v);
    s_gp = $sformatf("GP = %0d", ogp);
    s_sin = $sformatf("sin = %0d", osin);
    s_cos = $sformatf("cos = %0d", ocos);

    s = {s_v, " ", s_gp, " ", s_sin, " ", s_cos};
    return s;
endfunction

function bit sincos_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    sincos_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (
           osincos_v == RHS.osincos_v
        && ogp == RHS.ogp
        && osin == RHS.osin
        && ocos == RHS.ocos
    ) && same;
    return same;
endfunction