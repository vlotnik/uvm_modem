//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_sin_cos_table_fg
//--------------------------------------------------------------------------------------------------------------------------------
class sim_sin_cos_table_fg #(
      GPDW = 10
    , PIPE_CE = 0
    , PHASE_W = 12
    , SINCOS_W = 16
) extends uvm_object;
    `uvm_object_param_utils(sim_sin_cos_table_fg #(GPDW, PIPE_CE, PHASE_W, SINCOS_W))

    localparam                      LATENCY = 3;
    localparam                      SINCOS_MAX = 2**(SINCOS_W-1)-1;

    localparam                      RAXI_DWI = GPDW + PHASE_W;
    localparam                      RAXI_DWO = GPDW + SINCOS_W*2;

    // variables
    int sin;
    int cos;

    // components
    sim_pipe #(
          .DW(RAXI_DWO)
        , .SIZE(LATENCY)
        , .PIPE_CE(PIPE_CE)
    )                               sim_pipe_h;
    raxi_seqi                       raxi_seqi_h_pipe;

    extern function new(string name = "");
    extern function automatic void simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function sim_sin_cos_table_fg::new(string name = "");
    `uvm_object_create(sim_pipe #(RAXI_DWO, LATENCY, PIPE_CE), sim_pipe_h)
    `uvm_object_create(raxi_seqi, raxi_seqi_h_pipe)
endfunction

function automatic void sim_sin_cos_table_fg::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[PHASE_W-1:0] raxi_data_iphase;
    bit[GPDW-1:0] raxi_data_igp;
    bit[RAXI_DWI-1:0] raxi_data_i;
    bit[SINCOS_W-1:0] raxi_data_pipe_sin;
    bit[SINCOS_W-1:0] raxi_data_pipe_cos;
    bit[GPDW-1:0] raxi_data_pipe_gp;
    bit[RAXI_DWO-1:0] raxi_data_pipe;

    // parse input transaction
    raxi_data_i = {<<{raxi_seqi_i.data}};
    {raxi_data_igp, raxi_data_iphase} = raxi_data_i;

    // calculate main functions
    sin = c_math_sin(raxi_data_iphase, SINCOS_MAX, PHASE_W);
    cos = c_math_cos(raxi_data_iphase, SINCOS_MAX, PHASE_W);

    // pipeline input
    raxi_data_pipe_sin = sin;
    raxi_data_pipe_cos = cos;
    raxi_data_pipe_gp = raxi_data_igp;
    raxi_data_pipe = {raxi_data_pipe_gp, raxi_data_pipe_cos, raxi_data_pipe_sin};
    raxi_seqi_h_pipe.valid = raxi_seqi_i.valid;
    raxi_seqi_h_pipe.data = {<<{raxi_data_pipe}};

    // pipeline
    sim_pipe_h.simulate(raxi_seqi_h_pipe, raxi_seqi_o);
endfunction