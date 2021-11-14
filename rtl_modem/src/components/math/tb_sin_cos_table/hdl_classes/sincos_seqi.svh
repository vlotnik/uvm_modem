//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_seqi
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_seqi extends uvm_sequence_item;
    `uvm_object_utils(sincos_seqi)
    `uvm_object_new

    extern function void post_randomize();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string();

    rand int phase_v[];
    rand int phase;
    int sin;
    int cos;

    constraint c_phase {
        phase inside{[0:4095]};
    }

    constraint c_phase_v {
        foreach(phase_v[i])
            phase_v[i] inside {[0:1]};
        phase_v.size inside {[5:5]};
        phase_v.sum == 1;
    }
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_seqi::post_randomize();
    int length;
    length = phase_v.size();

    if (phase_v[length - 1] == 1) begin
        phase_v[length - 2] = phase_v[length - 1];
        phase_v[length - 1] = 0;
    end;
endfunction

function string sincos_seqi::convert2string();
    string s;
    s = $sformatf("phase = %6d; sin = %6d, cos = %6d", phase, sin, cos);
    return s;
endfunction

function bit sincos_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    sincos_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (phase == RHS.phase && sin == RHS.sin && cos == RHS.cos) && same;
    return same;
endfunction