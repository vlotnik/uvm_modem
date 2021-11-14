//--------------------------------------------------------------------------------------------------------------------------------
// name : sincos_mont
//--------------------------------------------------------------------------------------------------------------------------------
class sincos_mont extends uvm_component;
    `uvm_component_utils(sincos_mont);
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    virtual sincos_bfm              sincos_bfm_h;

    sincos_aprt                     sincos_aprt_i;
    sincos_seqi                     sincos_seqi_i;
    sincos_aprt                     sincos_aprt_o;
    sincos_seqi                     sincos_seqi_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void sincos_mont::build_phase(uvm_phase phase);
    // build analysis ports
    sincos_aprt_i = new("sincos_aprt_i", this);
    sincos_aprt_o = new("sincos_aprt_o", this);
endfunction

task sincos_mont::run_phase(uvm_phase phase);
    forever @(posedge sincos_bfm_h.iclk) begin
        if (sincos_bfm_h.iv == 1) begin
            `uvm_object_create(sincos_seqi, sincos_seqi_i)
            sincos_seqi_i.phase = sincos_bfm_h.iphase;
            sincos_aprt_i.write(sincos_seqi_i);
        end

        if (sincos_bfm_h.ov == 1) begin
            `uvm_object_create(sincos_seqi, sincos_seqi_o)
            sincos_seqi_o.sin = $signed(sincos_bfm_h.osin);
            sincos_seqi_o.cos = $signed(sincos_bfm_h.ocos);
            sincos_aprt_o.write(sincos_seqi_o);
        end
    end
endtask