//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_modem_math
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_modem_math;

    import pkg_modem::*;

    real c_pi = 3.1415926535897932384626433832795;

    function real f_abs_real(real x);
        real result;
        result = x < 0 ? -1.0 * x : x;
        return result;
    endfunction

    function int f_sin(int phase, int max = 2**15 - 1, int phase_w = 12);
        real phase_r;
        real sin_r;
        real sin_i;
        real sin_floor;
        int sin_int;

        phase_r = $itor(phase) * 2.0 * c_pi / $itor(2**phase_w);
        sin_r = $sin(phase_r);
        sin_i = sin_r * $itor(max);
        sin_floor = $floor(sin_i + 0.5);
        sin_int = $rtoi(sin_floor);

        return sin_int;
    endfunction

    function int f_cos(int phase, int max = 2**15-1, int phase_w = 12);
        real phase_r;
        real cos_r;
        real cos_i;
        real cos_floor;
        int cos_int;

        phase_r = $itor(phase) * 2.0 * c_pi / $itor(2**phase_w);
        cos_r = $cos(phase_r);
        cos_i = cos_r * $itor(max);
        cos_floor = $floor(cos_i + 0.5);
        cos_int = $rtoi(cos_floor);

        return cos_int;
    endfunction

    function t_iq f_complex_mult(t_iq a, t_iq b, bit conj_mult);
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
endpackage