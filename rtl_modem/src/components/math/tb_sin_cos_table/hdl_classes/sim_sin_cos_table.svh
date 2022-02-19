//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_sin_cos_table
//--------------------------------------------------------------------------------------------------------------------------------
class sim_sin_cos_table #(
      GP_DW = 10
    , PIPE_CE = 0
    , PHASE_DW = 12
    , SINCOS_DW = 16
) extends uvm_object;
    `uvm_object_param_utils(sim_sin_cos_table #(GP_DW, PIPE_CE, PHASE_DW, SINCOS_DW))

    localparam                          LATENCY = 3;
    localparam                          SINCOS_MAX = 2**(SINCOS_DW-1)-1;

    localparam                          IRAXI_DW = GP_DW + PHASE_DW;
    localparam                          ORAXI_DW = GP_DW + SINCOS_DW*2;

    // variables
    int sin;
    int cos;

    // components
    sim_pipe #(
          .DW(ORAXI_DW)
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
function sim_sin_cos_table::new(string name = "");
    `uvm_object_create(sim_pipe #(ORAXI_DW, LATENCY, PIPE_CE), sim_pipe_h)
    `uvm_object_create(raxi_seqi, raxi_seqi_h_pipe)
endfunction

function automatic void sim_sin_cos_table::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[PHASE_DW-1:0] raxi_data_iphase;
    bit[GP_DW-1:0] raxi_data_igp;
    bit[IRAXI_DW-1:0] raxi_data_i;
    bit[SINCOS_DW-1:0] raxi_data_pipe_sin;
    bit[SINCOS_DW-1:0] raxi_data_pipe_cos;
    bit[GP_DW-1:0] raxi_data_pipe_gp;
    bit[ORAXI_DW-1:0] raxi_data_pipe;

    // parse input transaction
    raxi_data_i = {<<{raxi_seqi_i.data}};
    {raxi_data_igp, raxi_data_iphase} = raxi_data_i;

    // calculate main functions
    sin = f_sin(raxi_data_iphase, SINCOS_MAX, PHASE_DW);
    cos = f_cos(raxi_data_iphase, SINCOS_MAX, PHASE_DW);

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