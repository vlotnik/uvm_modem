//--------------------------------------------------------------------------------------------------------------------------------
// name : simplefir_seqc_coef
//--------------------------------------------------------------------------------------------------------------------------------
class simplefir_seqc_coef #(
      G_NOF_TAPS = 32
    , G_COEF_DW = 16
) extends uvm_sequence #(raxi_seqi);
    `uvm_object_param_utils(simplefir_seqc_coef #(G_NOF_TAPS, G_COEF_DW))
    `uvm_object_new

    extern task pre_body();
    extern task body();

    filter_design                       filter_design_h;
    real fir_coefficients[];
    int rg_firwr_cv[];

    raxi_seqi                           raxi_seqi_h;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
task simplefir_seqc_coef::pre_body();
    `uvm_object_create(raxi_seqi, raxi_seqi_h);
endtask

task simplefir_seqc_coef::body();
    bit[G_COEF_DW-1:0] coef;

    filter_design_h = new();
    fir_coefficients = new[G_NOF_TAPS];
    filter_design_h.get_coefs_rcos(0.35, 0.1, G_NOF_TAPS, fir_coefficients);

    rg_firwr_cv = new[G_NOF_TAPS];
    for (int ii = 0; ii < G_NOF_TAPS; ii++)
        rg_firwr_cv[ii] = $rtoi(fir_coefficients[ii] * $pow(2, G_COEF_DW-1));

    start_item(raxi_seqi_h);
        raxi_seqi_h.rst = 1;
    finish_item(raxi_seqi_h);

    for (int ii = 0; ii < rg_firwr_cv.size; ii++) begin
        start_item(raxi_seqi_h);
            coef = rg_firwr_cv[ii];
            raxi_seqi_h.rst = 0;
            raxi_seqi_h.valid = 1;
            raxi_seqi_h.data = {<<{coef}};
        finish_item(raxi_seqi_h);
    end

    start_item(raxi_seqi_h);
        raxi_seqi_h.valid = 0;
    finish_item(raxi_seqi_h);
endtask