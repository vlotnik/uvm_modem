//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_complex_rotator
//--------------------------------------------------------------------------------------------------------------------------------
class sim_complex_rotator #(
      GP_DW
    , PHASE_DW
    , SAMPLE_DW
    , SINCOS_DW
    , CONJ_MULT
    , PIPE_CE
) extends uvm_object;
    `uvm_object_param_utils(sim_complex_rotator #(GP_DW, PHASE_DW, SAMPLE_DW, SINCOS_DW, CONJ_MULT, PIPE_CE))

    // settings
    localparam                          LATENCY = 1;

    // input
    localparam                          IRAXI_DW = GP_DW + PHASE_DW + SAMPLE_DW*2;
    localparam                          ORAXI_DW = GP_DW + SAMPLE_DW*2;

    // sincos
    localparam                          SIM_SINCOS_GPDW = GP_DW + SAMPLE_DW*2;
    localparam                          SIM_SINCOS_IRAXI_DW = SIM_SINCOS_GPDW + PHASE_DW;
    localparam                          SIM_SINCOS_ORAXI_DW = SIM_SINCOS_GPDW + SINCOS_DW*2;
    sim_sin_cos_table #(
          .GP_DW(SIM_SINCOS_GPDW)
        , .PIPE_CE(PIPE_CE)
        , .PHASE_DW(PHASE_DW)
        , .SINCOS_DW(SINCOS_DW)
    )                                   sim_sin_cos_table_h;
    raxi_seqi                           sim_sin_cos_iraxi_seqi;
    raxi_seqi                           sim_sin_cos_oraxi_seqi;

    // compmult
    localparam                          SIM_COMPMULT_IRAXI_DW = GP_DW + SINCOS_DW*2 + SAMPLE_DW*2;
    localparam                          SIM_COMPMULT_C_DW = SINCOS_DW + SAMPLE_DW + 1;
    localparam                          SIM_COMPMULT_ORAXI_DW = GP_DW + SIM_COMPMULT_C_DW*2;
    sim_complex_multiplier #(
          .GP_DW(GP_DW)
        , .A_DW(SAMPLE_DW)
        , .B_DW(SINCOS_DW)
        , .PIPE_CE(PIPE_CE)
        , .CONJ_MULT(CONJ_MULT)
    )                                   sim_compmult_h;
    raxi_seqi                           sim_compmult_iraxi_seqi;
    raxi_seqi                           sim_compmult_oraxi_seqi;

    // output pipeline
    sim_pipe #(
          .DW(ORAXI_DW)
        , .SIZE(LATENCY)
        , .PIPE_CE(PIPE_CE)
    )                                   sim_pipe_h;
    raxi_seqi                           sim_pipe_iraxi_seqi;

    extern function new(string name = "");
    extern function automatic void simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);

    extern function string iraxi_2string(raxi_seqi raxi_seqi_h);
    extern function string oraxi_2string(raxi_seqi raxi_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function sim_complex_rotator::new(string name = "");
    `uvm_object_create(sim_sin_cos_table #(SIM_SINCOS_GPDW, PIPE_CE, PHASE_DW, SINCOS_DW), sim_sin_cos_table_h);
    `uvm_object_create(raxi_seqi, sim_sin_cos_iraxi_seqi)
    `uvm_object_create(raxi_seqi, sim_sin_cos_oraxi_seqi)
    `uvm_object_create(sim_complex_multiplier #(GP_DW, SAMPLE_DW, SINCOS_DW, PIPE_CE, CONJ_MULT), sim_compmult_h);
    `uvm_object_create(raxi_seqi, sim_compmult_iraxi_seqi)
    `uvm_object_create(raxi_seqi, sim_compmult_oraxi_seqi)
    `uvm_object_create(sim_pipe #(ORAXI_DW, LATENCY, PIPE_CE), sim_pipe_h)
    `uvm_object_create(raxi_seqi, sim_pipe_iraxi_seqi)
endfunction

function automatic void sim_complex_rotator::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[IRAXI_DW-1:0] ib_data;
    bit[SAMPLE_DW-1:0] ib_re;
    bit[SAMPLE_DW-1:0] ib_im;
    bit[PHASE_DW-1:0] ib_phase;
    bit[GP_DW-1:0] ib_gp;

    bit[SIM_SINCOS_IRAXI_DW-1:0] irsctbl_data;
    bit[SIM_SINCOS_ORAXI_DW-1:0] orsctbl_data;

    bit[SAMPLE_DW-1:0] sincos_re;
    bit[SAMPLE_DW-1:0] sincos_im;
    bit[SINCOS_DW-1:0] sincos_cos;
    bit[SINCOS_DW-1:0] sincos_sin;
    bit[GP_DW-1:0] sincos_gp;

    bit[SIM_COMPMULT_IRAXI_DW-1:0] compmult_raxi_data_i;
    bit[SIM_COMPMULT_ORAXI_DW-1:0] compmult_raxi_data_o;

    bit[SIM_COMPMULT_C_DW-1:0] cmult_re;
    bit[SIM_COMPMULT_C_DW-1:0] cmult_im;
    bit[GP_DW-1:0] cmult_gp;

    bit[SIM_COMPMULT_C_DW-1:0] rnd_re;
    bit[SIM_COMPMULT_C_DW-1:0] rnd_im;
    bit[GP_DW-1:0] rnd_gp;

    bit[SAMPLE_DW-1:0] pipe_re;
    bit[SAMPLE_DW-1:0] pipe_im;
    bit[GP_DW-1:0] pipe_gp;
    bit[ORAXI_DW-1:0] pipe_raxi_data_i;

    // parse input transaction
    ib_data = {<<{raxi_seqi_i.data}};
    {ib_gp, ib_phase, ib_im, ib_re} = ib_data;

    // sin cos table
    irsctbl_data = {ib_gp, ib_im, ib_re, ib_phase};
    sim_sin_cos_iraxi_seqi.valid = raxi_seqi_i.valid;
    sim_sin_cos_iraxi_seqi.data = {<<{irsctbl_data}};
    sim_sin_cos_table_h.simulate(sim_sin_cos_iraxi_seqi, sim_sin_cos_oraxi_seqi);

    // parse sincos output
    orsctbl_data = {<<{sim_sin_cos_oraxi_seqi.data}};
    {sincos_gp, sincos_im, sincos_re, sincos_cos, sincos_sin} = orsctbl_data;

    // complex multiplier
    compmult_raxi_data_i = {sincos_gp, sincos_sin, sincos_cos, sincos_im, sincos_re};
    sim_compmult_iraxi_seqi.valid = sim_sin_cos_oraxi_seqi.valid;
    sim_compmult_iraxi_seqi.data = {<<{compmult_raxi_data_i}};
    sim_compmult_h.simulate(sim_compmult_iraxi_seqi, sim_compmult_oraxi_seqi);

    // parse compmult output
    compmult_raxi_data_o = {<<{sim_compmult_oraxi_seqi.data}};
    {cmult_gp, cmult_im, cmult_re} = compmult_raxi_data_o;

    // rounding
    rnd_re = f_divide_and_round(cmult_re, SINCOS_DW-1);
    rnd_im = f_divide_and_round(cmult_im, SINCOS_DW-1);
    rnd_gp = cmult_gp;

    // pipe_re = rnd_re[SAMPLE_DW-1:0];
    // pipe_im = rnd_im[SAMPLE_DW-1:0];
    pipe_re = cmult_re[SAMPLE_DW + SINCOS_DW - 2 : SINCOS_DW - 1];
    pipe_im = cmult_im[SAMPLE_DW + SINCOS_DW - 2 : SINCOS_DW - 1];
    pipe_gp = rnd_gp;

    pipe_raxi_data_i = {pipe_gp, pipe_im, pipe_re};
    sim_pipe_iraxi_seqi.valid = sim_compmult_oraxi_seqi.valid;
    sim_pipe_iraxi_seqi.data = {<<{pipe_raxi_data_i}};

    // output pipeline
    sim_pipe_h.simulate(sim_pipe_iraxi_seqi, raxi_seqi_o);
endfunction

function string sim_complex_rotator::iraxi_2string(raxi_seqi raxi_seqi_h);
    bit[IRAXI_DW-1:0] raxi_data = 0;
    bit[SAMPLE_DW-1:0] raxi_data_re = 0;
    bit[SAMPLE_DW-1:0] raxi_data_im = 0;
    bit[PHASE_DW-1:0] raxi_data_phase = 0;
    bit[GP_DW-1:0] raxi_data_gp = 0;
    string s_valid;
    string s_re;
    string s_im;
    string s_phase;
    string s_gp;
    string s_data;

    s_valid = $sformatf("valid = %0b", raxi_seqi_h.valid);

    if (raxi_seqi_h.data.size() > 0) begin
        raxi_data = {<<{raxi_seqi_h.data}};

        {raxi_data_gp, raxi_data_phase, raxi_data_im, raxi_data_re} = raxi_data;

        s_re = $sformatf("re = %0d", $signed(raxi_data_re));
        s_im = $sformatf("im = %0d", $signed(raxi_data_im));
        s_phase = $sformatf("phase = %0d", $unsigned(raxi_data_phase));
        s_gp = $sformatf("gp = %0d", $unsigned(raxi_data_gp));

        s_data = {s_valid
            , ", " , s_re
            , ", " , s_im
            , ", " , s_phase
            , ", " , s_gp
        };
    end else
        s_data = {s_valid, ", no data"};

    return s_data;
endfunction

function string sim_complex_rotator::oraxi_2string(raxi_seqi raxi_seqi_h);
    bit[ORAXI_DW-1:0] raxi_data = 0;
    bit[SAMPLE_DW-1:0] raxi_data_re = 0;
    bit[SAMPLE_DW-1:0] raxi_data_im = 0;
    bit[GP_DW-1:0] raxi_data_gp = 0;
    string s_valid;
    string s_re;
    string s_im;
    string s_gp;
    string s_data;

    s_valid = $sformatf("valid = %0b", raxi_seqi_h.valid);

    if (raxi_seqi_h.data.size() > 0) begin
        raxi_data = {<<{raxi_seqi_h.data}};

        {raxi_data_gp, raxi_data_im, raxi_data_re} = raxi_data;

        s_re = $sformatf("re = %0d", $signed(raxi_data_re));
        s_im = $sformatf("im = %0d", $signed(raxi_data_im));
        s_gp = $sformatf("gp = %0d", $unsigned(raxi_data_gp));

        s_data = {s_valid
            , ", " , s_re
            , ", " , s_im
            , ", " , s_gp
        };
    end else
        s_data = {s_valid, ", no data"};

    return s_data;
endfunction