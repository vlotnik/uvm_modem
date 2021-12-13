//--------------------------------------------------------------------------------------------------------------------------------
// name : simplefir_seqc_coef
//--------------------------------------------------------------------------------------------------------------------------------
class simplefir_seqc_coef #(
      NOF_TAPS = 32
) extends uvm_sequence #(raxi_seqi);
    `uvm_object_param_utils(simplefir_seqc_coef #(NOF_TAPS))
    `uvm_object_new

    extern task body();

    filter_design                       filter_design_h;
    real fir_coefficients[];
    int rg_firwr_cv[];

    raxi_seqi                           raxi_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task simplefir_seqc_coef::body();
    bit[15:0] coef;

    `uvm_object_create(raxi_seqi, raxi_seqi_h);

    filter_design_h = new();
    fir_coefficients = filter_design_h.get_coefs_rcos(0.35, 0.1, NOF_TAPS);
    rg_firwr_cv = new[fir_coefficients.size];
    for (int ii = 0; ii < fir_coefficients.size; ii++)
        rg_firwr_cv[ii] = $rtoi(fir_coefficients[ii] * $pow(2, 15));

    start_item(raxi_seqi_h);
        raxi_seqi_h.rst = 1;
    finish_item(raxi_seqi_h);

    for (int ii = 0; ii < rg_firwr_cv.size; ii++) begin
        start_item(raxi_seqi_h);
            coef = rg_firwr_cv[ii];
            $display("coefficient: %d", $signed(coef));
            raxi_seqi_h.rst = 0;
            raxi_seqi_h.valid = 1;
            raxi_seqi_h.data = {<<{coef}};
        finish_item(raxi_seqi_h);
    end

    start_item(raxi_seqi_h);
        raxi_seqi_h.valid = 0;
    finish_item(raxi_seqi_h);
endtask