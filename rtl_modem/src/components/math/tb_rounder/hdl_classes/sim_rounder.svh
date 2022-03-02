//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_rounder
//--------------------------------------------------------------------------------------------------------------------------------
class sim_rounder #(
      GP_DW
    , NOF_SAMPLES
    , SAMPLE_DW
    , RND_LSB
    , PIPE_CE
) extends uvm_object;
    `uvm_object_param_utils(sim_rounder #(GP_DW, NOF_SAMPLES, SAMPLE_DW, RND_LSB, PIPE_CE))

    // settings
    localparam                          LATENCY = 1;

    // input
    localparam                          IRAXI_DW = GP_DW + SAMPLE_DW*NOF_SAMPLES;

    // output
    localparam                          C_DW = SAMPLE_DW - RND_LSB + 1;
    localparam                          ORAXI_DW = GP_DW + C_DW*NOF_SAMPLES;

    // input pipeline
    sim_pipe #(
          .DW(IRAXI_DW)
        , .SIZE(LATENCY)
        , .PIPE_CE(PIPE_CE)
    )                                   isim_pipe;

    // output pipeline
    sim_pipe #(
          .DW(ORAXI_DW)
        , .SIZE(LATENCY)
        , .PIPE_CE(PIPE_CE)
    )                                   sim_pipe_h;
    raxi_seqi                           sim_pipe_iraxi_seqi;

    extern function new(string name = "");
    extern function automatic void pipe_input(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    extern function automatic void simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);

    extern function string iraxi_2string(raxi_seqi raxi_seqi_h);
    extern function string oraxi_2string(raxi_seqi raxi_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function sim_rounder::new(string name = "");
    `uvm_object_create(sim_pipe #(IRAXI_DW, LATENCY, PIPE_CE), isim_pipe)
    `uvm_object_create(sim_pipe #(ORAXI_DW, LATENCY, PIPE_CE), sim_pipe_h)
    `uvm_object_create(raxi_seqi, sim_pipe_iraxi_seqi)
endfunction

function automatic void sim_rounder::pipe_input(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    isim_pipe.simulate(raxi_seqi_i, raxi_seqi_o);
endfunction

function automatic void sim_rounder::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[IRAXI_DW-1:0] ib_data;
    bit[SAMPLE_DW*NOF_SAMPLES-1:0] ib_samples;
    bit[SAMPLE_DW-1:0] ib_sample[NOF_SAMPLES];
    bit[GP_DW-1:0] ib_gp;

    bit[C_DW-1:0] rnd_sample[NOF_SAMPLES];
    bit[C_DW*NOF_SAMPLES-1:0] rnd_samples;
    bit[GP_DW-1:0] rnd_gp;

    bit[ORAXI_DW-1:0] pipe_raxi_data_i;

    // parse input transaction
    ib_data = {<<{raxi_seqi_i.data}};
    {ib_gp, ib_samples} = ib_data;

    // stream bit vector into array
    ib_sample = {<<{ib_samples}};
    // swap bits in each element
    for (int ii = 0; ii < NOF_SAMPLES; ii++) begin
        ib_sample[ii] = {<<{ib_sample[ii]}};
    end

    for (int ii = 0; ii < NOF_SAMPLES; ii++) begin
        rnd_sample[ii] = f_divide_and_round($signed(ib_sample[ii]), RND_LSB);
        rnd_sample[ii] = {<<{rnd_sample[ii]}};
    end
    rnd_samples = {<<{rnd_sample}};
    rnd_gp = ib_gp;

    pipe_raxi_data_i = {rnd_gp, rnd_samples};
    sim_pipe_iraxi_seqi.valid = raxi_seqi_i.valid;
    sim_pipe_iraxi_seqi.data = {<<{pipe_raxi_data_i}};

    // output pipeline
    sim_pipe_h.simulate(sim_pipe_iraxi_seqi, raxi_seqi_o);
endfunction

function string sim_rounder::iraxi_2string(raxi_seqi raxi_seqi_h);
    bit[IRAXI_DW-1:0] raxi_data = 0;
    bit[SAMPLE_DW*NOF_SAMPLES-1:0] raxi_data_samples = 0;
    bit[SAMPLE_DW-1:0] raxi_data_sample[NOF_SAMPLES];
    bit[GP_DW-1:0] raxi_data_gp = 0;
    string s_valid;
    string s_sample;
    string s_gp;
    string s_data;

    s_valid = $sformatf("valid = %0b", raxi_seqi_h.valid);

    if (raxi_seqi_h.data.size() > 0) begin
        raxi_data = {<<{raxi_seqi_h.data}};

        {raxi_data_gp, raxi_data_samples} = raxi_data;
        raxi_data_sample = {<<{raxi_data_samples}};
        for (int ii = 0; ii < NOF_SAMPLES; ii++) begin
            raxi_data_sample[ii] = {<<{raxi_data_sample[ii]}};
        end

        s_data = s_valid;
        for (int ii = 0; ii < NOF_SAMPLES; ii++) begin
            s_sample = $sformatf("sample # %0d = %b", ii, raxi_data_sample[ii]);
            s_data = {s_data, ", " , s_sample};
        end

        s_gp = $sformatf("gp = %0d", raxi_data_gp);

        s_data = {s_data, ", " , s_gp};
    end else
        s_data = {s_valid, ", no data"};

    return s_data;
endfunction

function string sim_rounder::oraxi_2string(raxi_seqi raxi_seqi_h);
    bit[ORAXI_DW-1:0] raxi_data = 0;
    bit[C_DW*NOF_SAMPLES-1:0] raxi_data_samples = 0;
    bit[C_DW-1:0] raxi_data_sample[NOF_SAMPLES];
    bit[GP_DW-1:0] raxi_data_gp = 0;
    string s_valid;
    string s_sample;
    string s_gp;
    string s_data;

    s_valid = $sformatf("valid = %0b", raxi_seqi_h.valid);

    if (raxi_seqi_h.data.size() > 0) begin
        raxi_data = {<<{raxi_seqi_h.data}};

        {raxi_data_gp, raxi_data_samples} = raxi_data;
        // stream bit vector into array
        raxi_data_sample = {<<{raxi_data_samples}};
        // swap bits in each element
        for (int ii = 0; ii < NOF_SAMPLES; ii++) begin
            raxi_data_sample[ii] = {<<{raxi_data_sample[ii]}};
        end

        s_data = s_valid;
        for (int ii = 0; ii < NOF_SAMPLES; ii++) begin
            s_sample = $sformatf("sample # %0d = %b", ii, raxi_data_sample[ii]);
            s_data = {s_data, ", " , s_sample};
        end

        s_gp = $sformatf("gp = %0d", raxi_data_gp);

        s_data = {s_data, ", " , s_gp};
    end else
        s_data = {s_valid, ", no data"};

    return s_data;
endfunction