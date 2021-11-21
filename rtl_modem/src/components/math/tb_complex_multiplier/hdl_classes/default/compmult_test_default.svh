//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_test_default
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_test_default #(
          A_DW
        , B_DW
        , CONJ_MULT
) extends compmult_base_test #(
          A_DW
        , B_DW
        , CONJ_MULT
);

    typedef uvm_component_registry #(compmult_test_default #(
          A_DW
        , B_DW
        , CONJ_MULT
    ), "compmult_test_default") type_id;

    `uvm_component_new

    // functions
    extern function void build_phase(uvm_phase phase);
    // extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_test_default::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task compmult_test_default::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask