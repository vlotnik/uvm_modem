//--------------------------------------------------------------------------------------------------------------------------------
// name : lib_c_math
//--------------------------------------------------------------------------------------------------------------------------------

// Wrapper for standart C function
#include "svdpi.h"
#include "lib_c_math.h"
#include <stdio.h>
#include <stdlib.h>
#include "math.h"

// sin
int c_math_sin(int phase, int max, int phase_w)
{
    double phase_r = 0;
    double sin_r = 0;
    double sin_i = 0;
    double sin_floor = 0;
    int sin_int = 0;

    phase_r = phase * 2.0 * M_PI / pow(2, phase_w);
    sin_r = sin(phase_r);
    sin_i = sin_r * max;
    sin_floor = floor(sin_i + 0.5);
    sin_int = sin_floor;

    return sin_int;
}

// cos
int c_math_cos(int phase, int max, int phase_w)
{
    double phase_r = 0;
    double cos_r = 0;
    double cos_i = 0;
    double cos_floor = 0;
    int cos_int = 0;

    phase_r = phase * 2.0 * M_PI / pow(2, phase_w);
    cos_r = cos(phase_r);
    cos_i = cos_r * max;
    cos_floor = floor(cos_i + 0.5);
    cos_int = cos_floor;

    return cos_int;
}

// real part of complex (a x b)
int c_math_complex_mult_re(int a_re, int a_im, int b_re, int b_im, int conj_mult)
{
    int result = 0;

    if (conj_mult == 0)
        result = a_re * b_re - a_im * b_im;
    else
        result = a_re * b_re + a_im * b_im;

    return result;
}

// imag part of complex (a x b)
int c_math_complex_mult_im(int a_re, int a_im, int b_re, int b_im, int conj_mult)
{
    int result = 0;

    if (conj_mult == 0)
        result = a_im * b_re + a_re * b_im;
    else
        result = a_im * b_re - a_re * b_im;

    return result;
}