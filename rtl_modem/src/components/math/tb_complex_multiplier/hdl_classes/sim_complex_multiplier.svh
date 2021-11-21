//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_complex_multiplier
//--------------------------------------------------------------------------------------------------------------------------------
class sim_complex_multiplier extends uvm_object;
    `uvm_object_utils(sim_complex_multiplier)
    `uvm_object_new

    // settings
    bit conj_mult = 0;
    localparam LATENCY = 4;

    typedef struct{
        int i;
        int q;
    } t_iq;

    protected bit[0:LATENCY-1] pipe_v;
    protected int pipe_ia_i[LATENCY];
    protected int pipe_ia_q[LATENCY];
    protected int pipe_ib_i[LATENCY];
    protected int pipe_ib_q[LATENCY];
    protected t_iq a, b, c;

    extern function automatic void simulate(ref compmult_seqi compmult_seqi_h);
    extern virtual function t_iq get_ideal_value(t_iq a, t_iq b, bit conj_mult);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function automatic void sim_complex_multiplier::simulate(ref compmult_seqi compmult_seqi_h);
    compmult_seqi_h.ov = pipe_v[LATENCY-1];
    compmult_seqi_h.oc_i = c.i;
    compmult_seqi_h.oc_q = c.q;

    pipe_v = {compmult_seqi_h.iv, pipe_v[0:LATENCY-2]};

    if (pipe_v[3] == 1) begin
        a.i = pipe_ia_i[2];
        a.q = pipe_ia_q[2];
        b.i = pipe_ib_i[2];
        b.q = pipe_ib_q[2];
        c = get_ideal_value(a, b, conj_mult);
    end
    if (pipe_v[2] == 1) begin
        pipe_ia_i[2] = pipe_ia_i[1];
        pipe_ia_q[2] = pipe_ia_q[1];
        pipe_ib_i[2] = pipe_ib_i[1];
        pipe_ib_q[2] = pipe_ib_q[1];
    end
    if (pipe_v[1] == 1) begin
        pipe_ia_i[1] = pipe_ia_i[0];
        pipe_ia_q[1] = pipe_ia_q[0];
        pipe_ib_i[1] = pipe_ib_i[0];
        pipe_ib_q[1] = pipe_ib_q[0];
    end
    if (pipe_v[0] == 1) begin
        pipe_ia_i[0] = compmult_seqi_h.ia_i;
        pipe_ia_q[0] = compmult_seqi_h.ia_q;
        pipe_ib_i[0] = compmult_seqi_h.ib_i;
        pipe_ib_q[0] = compmult_seqi_h.ib_q;
    end

endfunction

function sim_complex_multiplier::t_iq sim_complex_multiplier::get_ideal_value(t_iq a, t_iq b, bit conj_mult);
    t_iq c;

    if (conj_mult == 0) begin
        c.i = a.i * b.i - a.q * b.q;
        c.q = a.q * b.i + a.i * b.q;
    end else begin
        c.i = a.i * b.i + a.q * b.q;
        c.q = a.q * b.i - a.i * b.q;
    end

    return c;
endfunction