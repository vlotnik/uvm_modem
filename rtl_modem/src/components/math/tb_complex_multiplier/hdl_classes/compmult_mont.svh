//--------------------------------------------------------------------------------------------------------------------------------
// name : compmult_mont
//--------------------------------------------------------------------------------------------------------------------------------
class compmult_mont #(
      A_DW = 12
    , B_DW = 12
) extends uvm_component;
    `uvm_component_utils(compmult_mont);
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    virtual compmult_bfm #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_bfm_h;

    compmult_aprt                       compmult_aprt_i;
    compmult_seqi #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_seqi_i;
    compmult_aprt                       compmult_aprt_o;
    compmult_seqi #(
          .A_DW(A_DW)
        , .B_DW(B_DW)
    )                                   compmult_seqi_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void compmult_mont::build_phase(uvm_phase phase);
    // build analysis ports
    compmult_aprt_i = new("compmult_aprt_i", this);
    compmult_aprt_o = new("compmult_aprt_o", this);
endfunction

task compmult_mont::run_phase(uvm_phase phase);
    forever @(posedge compmult_bfm_h.iclk) begin
        `uvm_object_create(compmult_seqi #(A_DW, B_DW), compmult_seqi_i)
        compmult_seqi_i.iv = compmult_bfm_h.iv;
        compmult_seqi_i.ia_i = $signed(compmult_bfm_h.ia_i);
        compmult_seqi_i.ia_q = $signed(compmult_bfm_h.ia_q);
        compmult_seqi_i.ib_i = $signed(compmult_bfm_h.ib_i);
        compmult_seqi_i.ib_q = $signed(compmult_bfm_h.ib_q);
        compmult_aprt_i.write(compmult_seqi_i);

        `uvm_object_create(compmult_seqi #(A_DW, B_DW), compmult_seqi_o)
        compmult_seqi_o.ov = compmult_bfm_h.ov;
        compmult_seqi_o.oc_i = $signed(compmult_bfm_h.oc_i);
        compmult_seqi_o.oc_q = $signed(compmult_bfm_h.oc_q);
        compmult_aprt_o.write(compmult_seqi_o);
    end
endtask