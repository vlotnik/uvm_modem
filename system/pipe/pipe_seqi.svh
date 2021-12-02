//--------------------------------------------------------------------------------------------------------------------------------
// name : pipe_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class pipe_seqi #(
      DW = 10
) extends raxi_seqi;
    `uvm_object_param_utils(pipe_seqi #(DW))
    `uvm_object_new

    extern function void post_randomize();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);

    // rAXI converters
    extern function void raxi2this_i(raxi_seqi raxi_seqi_h);
    extern function void raxi2this_o(raxi_seqi raxi_seqi_h);

    // data to string converters
    extern function string i2string();
    extern function string o2string();

    localparam DATA_MAX = 2**(DW) - 1;

    int iv;
    int id;
    int ov;
    int od;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void pipe_seqi::post_randomize();
    bit[DW-1:0] raxi_data;

    iv = $urandom_range(0, 1);
    if (iv == 1) begin
        id = $urandom_range(0, DATA_MAX);
    end

    // rAXI
    raxi_data = id;
    this.valid = iv;
    this.data = new[DW];
    // foreach (raxi_data[ii])
    //     this.data[ii] = raxi_data[ii];
     this.data = {<<{raxi_data}};
endfunction

function void pipe_seqi::raxi2this_i(raxi_seqi raxi_seqi_h);
    bit[DW-1:0] raxi_data;

    // foreach (raxi_data[ii])
    //     raxi_data[ii] = raxi_seqi_h.data[ii];
    raxi_data = {<<{raxi_seqi_h.data}};

    this.iv = raxi_seqi_h.valid;
    this.id = raxi_data;
endfunction

function void pipe_seqi::raxi2this_o(raxi_seqi raxi_seqi_h);
    bit[DW-1:0] raxi_data;

    // foreach (raxi_data[ii])
    //     raxi_data[ii] = raxi_seqi_h.data[ii];
    raxi_data = {<<{raxi_seqi_h.data}};

    this.ov = raxi_seqi_h.valid;
    this.od = raxi_data;
endfunction

function string pipe_seqi::i2string();
    string s_v;
    string s_d;
    string s;

    s_v = $sformatf("valid = %0d", iv);
    s_d = $sformatf("data = %0d", id);

    s = {s_v, " ", s_d};
    return s;
endfunction

function string pipe_seqi::o2string();
    string s_v;
    string s_d;
    string s;

    s_v = $sformatf("valid = %0d", ov);
    s_d = $sformatf("data = %0d", od);

    s = {s_v, " ", s_d};
    return s;
endfunction

function bit pipe_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    pipe_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (
           ov == RHS.ov
        && od == RHS.od
    ) && same;
    return same;
endfunction