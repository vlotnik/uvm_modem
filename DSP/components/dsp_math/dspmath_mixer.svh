//--------------------------------------------------------------------------------------------------------------------------------
// name : dspmath_mixer
//--------------------------------------------------------------------------------------------------------------------------------
class dspmath_mixer extends uvm_object;
    `uvm_object_utils(dspmath_mixer)
    `uvm_object_new

    protected real mix_step;
    protected real mix_accum;
    protected real phase;
    protected real result_i[];
    protected real result_q[];

    extern function void set_mix_freq(real mix_freq, real samp_freq);
    extern function automatic void mix(ref datagen_seqi h_datagen_seqi);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void dspmath_mixer::set_mix_freq(real mix_freq, real samp_freq);
    this.mix_step = mix_freq / samp_freq;
endfunction

function automatic void dspmath_mixer::mix(ref datagen_seqi h_datagen_seqi);
    real pi;
    int iq_length;

    pi = pkg_modem_math::c_pi;

    set_mix_freq(h_datagen_seqi.tr_car_f, h_datagen_seqi.tr_sym_f);
    iq_length = h_datagen_seqi.iq_i.size();
    result_i = new[iq_length];
    result_q = new[iq_length];

    for (int i = 0; i < iq_length; i++) begin
        phase = 2 * pi * mix_accum;
        // (I + jQ) * (cos + jsin) = (I * cos - Q * sin) + j(I * sin + Q * cos)
        result_i[i] = h_datagen_seqi.iq_i[i] * $cos(phase) - h_datagen_seqi.iq_q[i] * $sin(phase);
        result_q[i] = h_datagen_seqi.iq_i[i] * $sin(phase) + h_datagen_seqi.iq_q[i] * $cos(phase);
        mix_accum += mix_step;
    end

    h_datagen_seqi.iq_i = result_i;
    h_datagen_seqi.iq_q = result_q;
endfunction