//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_complex_multiplier
//--------------------------------------------------------------------------------------------------------------------------------
class sim_complex_multiplier #(
      GP_DW
    , A_DW
    , B_DW
    , PIPE_CE
    , CONJ_MULT
) extends uvm_object;
    `uvm_object_param_utils(sim_complex_multiplier #(GP_DW, A_DW, B_DW, PIPE_CE, CONJ_MULT))

    localparam                          LATENCY = 4;
    localparam                          A_MAX = 2**A_DW-1;
    localparam                          B_MAX = 2**B_DW-1;
    localparam                          C_W = A_DW + B_DW + 1;
    localparam                          PIPE_WIDTH = GP_DW + C_W * 2;

    localparam                          RAXI_DWI = GP_DW + A_DW*2 + B_DW*2;
    localparam                          RAXI_DWO = GP_DW + C_W*2;

    // variables
    t_iq a;
    t_iq b;
    t_iq c;
    int c_re;
    int c_im;

    // components
    sim_pipe #(
          .DW(PIPE_WIDTH)
        , .SIZE(LATENCY)
        , .PIPE_CE(PIPE_CE)
    )                                   sim_pipe_h;
    raxi_seqi                           raxi_seqi_h_pipe;

    extern function new(string name = "");
    extern function automatic void simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function sim_complex_multiplier::new(string name = "");
    `uvm_object_create(sim_pipe #(RAXI_DWO, LATENCY, PIPE_CE), sim_pipe_h)
    `uvm_object_create(raxi_seqi, raxi_seqi_h_pipe)
endfunction

function automatic void sim_complex_multiplier::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[A_DW-1:0] raxi_data_a_re;
    bit[A_DW-1:0] raxi_data_a_im;
    bit[B_DW-1:0] raxi_data_b_re;
    bit[B_DW-1:0] raxi_data_b_im;
    bit[GP_DW-1:0] raxi_data_igp;
    bit[RAXI_DWI-1:0] raxi_data_i;
    bit[C_W-1:0] raxi_data_c_re;
    bit[C_W-1:0] raxi_data_c_im;
    bit[GP_DW-1:0] raxi_data_pipe_gp;
    bit[RAXI_DWO-1:0] raxi_data_pipe;

    // parse input transaction
    raxi_data_i = {<<{raxi_seqi_i.data}};
    {raxi_data_igp, raxi_data_b_im, raxi_data_b_re, raxi_data_a_im, raxi_data_a_re} = raxi_data_i;

    // C function
    a.i = $signed(raxi_data_a_re);
    a.q = $signed(raxi_data_a_im);
    b.i = $signed(raxi_data_b_re);
    b.q = $signed(raxi_data_b_im);
    // c_re = c_math_complex_mult_re(a_re, a_im, b_re, b_im, CONJ_MULT);
    // c_im = c_math_complex_mult_im(a_re, a_im, b_re, b_im, CONJ_MULT);

    // SV function
    c = f_complex_mult(a, b, CONJ_MULT);
    c_re = c.i;
    c_im = c.q;

    // pipeline input
    raxi_data_c_re = c_re;
    raxi_data_c_im = c_im;
    raxi_data_pipe_gp = raxi_data_igp;
    raxi_data_pipe = {raxi_data_pipe_gp, raxi_data_c_im, raxi_data_c_re};
    raxi_seqi_h_pipe.valid = raxi_seqi_i.valid;
    raxi_seqi_h_pipe.data = {<<{raxi_data_pipe}};

    // pipeline
    sim_pipe_h.simulate(raxi_seqi_h_pipe, raxi_seqi_o);
endfunction