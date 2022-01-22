//--------------------------------------------------------------------------------------------------------------------------------
// name : filter_design
//--------------------------------------------------------------------------------------------------------------------------------
class filter_design;
    // raised cosine filter
    //
    // beta : roll-off factor
    // cutoff : cutoff frequency
    // taps : filter's length
    extern function automatic void get_coefs_rcos(real beta, real cutoff, int taps, ref real coefs[]);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function automatic void filter_design::get_coefs_rcos(real beta, real cutoff, int taps, ref real coefs[]);
    real pi;
    real epsilon;
    real t[];
    real b[];
    real fs;
    real fc;
    real x;

    pi = pkg_modem_math::c_pi;
    epsilon = $pow(2, -52);
    t = new[taps];
    b = new[taps];
    fs = 2.0;
    fc = cutoff * fs;

    // check beta, cutoff
    if ((beta <= 0) && (beta > 1.0))
        $write("beta factor must be in [0, 1) range");
    if ((cutoff <= 0) && (cutoff >= 1.0))
        $write("cutoff factor must be in [0, 1] range");

    for (int i = 0; i < taps ; i++) begin
        t[i] = ((-(taps - 1.0) / 2.0) + i) / fs;
    end

    for (int i = 0; i < taps; i++) begin
        if ((f_abs_real(f_abs_real(4.0 * beta * fc * t[i]) - 1.0)) > $sqrt(epsilon)) begin
            x = 2.0 * pi * fc * t[i];
            b[i] = ($sin(x) / x) / fs * $cos(x * beta) / (1.0 - $pow((2 * x * beta / pi), 2.0));
        end else begin
            b[i] = beta / (2 * fs) * $sin(pi / (2 * beta));
        end
        b[i] = 2 * fc * b[i];
    end

    coefs = b;
endfunction