//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_cvrb
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_cvrb extends uvm_subscriber #(sincos_seqi);
    `uvm_component_utils(sincos_cvrb)

    extern function new(string name, uvm_component parent);
    extern function void report_phase(uvm_phase phase);

    int cp_phase;

    covergroup cg_phase with function sample(int phase);
        coverpoint cp_phase {
            bins phase[] = {[0:4095]};
        }
    endgroup

    extern function void write(sincos_seqi t);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function sincos_cvrb::new(string name, uvm_component parent);
    super.new(name, parent);
    cg_phase = new();
endfunction

function void sincos_cvrb::report_phase(uvm_phase phase);
    // `uvm_info("MODCODS COVERAGE:", $sformatf("%0d%%", cg_modcod.get_coverage()), UVM_HIGH)
endfunction

function void sincos_cvrb::write(sincos_seqi t);
    cp_phase = t.phase;
    cg_phase.sample(cp_phase);
endfunction