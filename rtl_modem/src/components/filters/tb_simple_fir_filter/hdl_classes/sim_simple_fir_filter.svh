//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_simple_fir_filter
//--------------------------------------------------------------------------------------------------------------------------------
class sim_simple_fir_filter #(
      G_NOF_TAPS
    , G_COEF_DW
    , G_SAMPLE_DW
) extends uvm_object;
    `uvm_object_param_utils(sim_simple_fir_filter #(G_NOF_TAPS, G_COEF_DW, G_SAMPLE_DW))

    localparam                          LATENCY = G_NOF_TAPS + 3;

    protected real coefficients[G_NOF_TAPS];

    // components
    fir_filter                          fir_filter_h;
    datagen_seqi                        fir_seqi_h;
    sim_pipe #(
          .DW(48)
        , .SIZE(LATENCY)
        , .PIPE_CE(0)
    )                                   sim_pipe_h;
    raxi_seqi                           raxi_seqi_h_pipe;

    extern function new(string name = "");
    extern function automatic void simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);

    extern function void add_coefficient(raxi_seqi raxi_seqi_h);

    extern function string iraxi_iq_2string(raxi_seqi raxi_seqi_h);
    extern function string oraxi_iq_2string(raxi_seqi raxi_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function sim_simple_fir_filter::new(string name = "");
    `uvm_object_create(fir_filter, fir_filter_h)
    `uvm_object_create(datagen_seqi, fir_seqi_h)
    `uvm_object_create(sim_pipe #(48, LATENCY, 0), sim_pipe_h)
    `uvm_object_create(raxi_seqi, raxi_seqi_h_pipe)
endfunction

function void sim_simple_fir_filter::add_coefficient(raxi_seqi raxi_seqi_h);
    bit[G_COEF_DW-1:0] coefficient;

    if (raxi_seqi_h.valid == 1) begin
        coefficient = {<<{raxi_seqi_h.data}};
        coefficients = {$signed(coefficient), coefficients[0:G_NOF_TAPS-1]};
        $display("COEFS: %p", coefficients);
        fir_filter_h.set_coefficients(coefficients);
    end
endfunction

function automatic void sim_simple_fir_filter::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[G_SAMPLE_DW-1:0] data_bit;
    int data_int;
    int conv_data;
    bit[47:0] conv_data_bit;
    bit[47:0] raxi_data_pipe;

    if (raxi_seqi_i.valid == 1) begin
        // get data from transaction
        data_bit = {<<{raxi_seqi_i.data}};
        data_int = $signed(data_bit);

        // create datagen_seqi transaction
        fir_seqi_h.new_seqi(1);
        fir_seqi_h.iq_i[0] = data_int;

        // apply filter
        fir_filter_h.filt(fir_seqi_h);

        // get results
        conv_data = fir_seqi_h.iq_i[0];
    end

    // apply data
    conv_data_bit = conv_data;
    raxi_data_pipe = conv_data_bit;
    raxi_seqi_h_pipe.valid = raxi_seqi_i.valid;
    raxi_seqi_h_pipe.data = {<<{raxi_data_pipe}};

    // pipeline
    sim_pipe_h.simulate(raxi_seqi_h_pipe, raxi_seqi_o);
endfunction

function string sim_simple_fir_filter::iraxi_iq_2string(raxi_seqi raxi_seqi_h);
    bit[G_SAMPLE_DW-1:0] raxi_data = 0;
    string s_v;
    string s_d;
    string s;

    s_v = $sformatf("valid = %0b", raxi_seqi_h.valid);

    if (raxi_seqi_h.data.size() > 0) begin
        raxi_data = {<<{raxi_seqi_h.data}};

        s_d = $sformatf("data = %0d", $signed(raxi_data));

        s = {s_v
            , ", " , s_d
        };
        return s;
    end else
        s = {s_v, ", no data"};

    return s;
endfunction

function string sim_simple_fir_filter::oraxi_iq_2string(raxi_seqi raxi_seqi_h);
    bit[47:0] raxi_data = 0;
    string s_v;
    string s_d;
    string s;

    s_v = $sformatf("valid = %0b", raxi_seqi_h.valid);

    if (raxi_seqi_h.data.size() > 0) begin
        raxi_data = {<<{raxi_seqi_h.data}};

        s_d = $sformatf("data = %0d", $signed(raxi_data));

        s = {s_v
            , ", " , s_d
        };
        return s;
    end else
        s = {s_v, ", no data"};

    return s;
endfunction