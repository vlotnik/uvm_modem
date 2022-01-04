//--------------------------------------------------------------------------------------------------------------------------------
// name : tb_simple_fir_filter
//--------------------------------------------------------------------------------------------------------------------------------
`timescale 100ps/100ps

module tb_simple_fir_filter;
//--------------------------------------------------------------------------------------------------------------------------------
// settings
//--------------------------------------------------------------------------------------------------------------------------------
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // main test package
    import pkg_simplefir::*;

    // main settings
    parameter                           G_NOF_TAPS = 32;
    parameter                           G_COEF_DW = 16;
    parameter                           G_SAMPLE_DW = 12;

    localparam                          G_IRAXI_DW_COEF = G_COEF_DW;
    localparam                          G_IRAXI_DW = G_SAMPLE_DW;
    localparam                          G_ORAXI_DW = 48;

//--------------------------------------------------------------------------------------------------------------------------------
// clock generator
//--------------------------------------------------------------------------------------------------------------------------------
    bit clk = 0;
    // 100 MHz
    always #5 clk = ~clk;

//--------------------------------------------------------------------------------------------------------------------------------
// interfaces
//--------------------------------------------------------------------------------------------------------------------------------
    raxi_bfm #(
          .DW(G_IRAXI_DW_COEF)
    )                                   iraxi_bfm_coef();
    raxi_bfm #(
          .DW(G_IRAXI_DW)
    )                                   iraxi_bfm();
    raxi_bfm #(
          .DW(G_ORAXI_DW)
    )                                   oraxi_bfm();

    assign iraxi_bfm_coef.clk           = clk;
    assign iraxi_bfm.clk                = clk;
    assign oraxi_bfm.clk                = clk;

//--------------------------------------------------------------------------------------------------------------------------------
// DUT connection
    bit                                 idut_clk;
    bit                                 idut_coef_rst;
    bit                                 idut_coef_valid;
    bit[G_IRAXI_DW_COEF-1:0]            idut_coef_data;
    bit                                 idut_valid;
    bit[G_IRAXI_DW-1:0]                 idut_data;
    bit                                 odut_valid;
    bit[G_ORAXI_DW-1:0]                 odut_data;
//--------------------------------------------------------------------------------------------------------------------------------
    simple_fir_filter #(
          .g_nof_taps                   (G_NOF_TAPS)
        , .g_sample_dw                  (G_SAMPLE_DW)
        , .g_coef_dw                    (G_COEF_DW)
        , .g_iraxi_dw_coef              (G_IRAXI_DW_COEF)
        , .g_iraxi_dw                   (G_IRAXI_DW)
        , .g_oraxi_dw                   (G_ORAXI_DW)
    )
    dut(
          .iclk                         (idut_clk)
        , .icoef_rst                    (idut_coef_rst)
        , .icoef_valid                  (idut_coef_valid)
        , .icoef_data                   (idut_coef_data)
        , .ivalid                       (idut_valid)
        , .idata                        (idut_data)
        , .ovalid                       (odut_valid)
        , .odata                        (odut_data)
    );

    assign idut_clk                     = iraxi_bfm.clk;

    assign idut_coef_rst                = iraxi_bfm_coef.rst;
    assign idut_coef_valid              = iraxi_bfm_coef.valid;
    assign idut_coef_data               = iraxi_bfm_coef.data;

    assign idut_valid                   = iraxi_bfm.valid;
    assign idut_data                    = iraxi_bfm.data;

    assign oraxi_bfm.valid              = odut_valid;
    assign oraxi_bfm.data               = odut_data;

//--------------------------------------------------------------------------------------------------------------------------------
// UVM test
//--------------------------------------------------------------------------------------------------------------------------------
    typedef simplefir_base_test #(
          .G_NOF_TAPS(G_NOF_TAPS)
        , .G_COEF_DW(G_COEF_DW)
        , .G_SAMPLE_DW(G_SAMPLE_DW)
        , .G_IRAXI_DW_COEF(G_IRAXI_DW_COEF)
        , .G_IRAXI_DW(G_IRAXI_DW)
        , .G_ORAXI_DW(G_ORAXI_DW)
    )                                   simplefir_base_test_h;

    initial begin
        uvm_config_db #(virtual raxi_bfm #(G_IRAXI_DW_COEF))::set(null, "*", "iraxi_bfm_coef", iraxi_bfm_coef);
        uvm_config_db #(virtual raxi_bfm #(G_IRAXI_DW))::set(null, "*", "iraxi_bfm", iraxi_bfm);
        uvm_config_db #(virtual raxi_bfm #(G_ORAXI_DW))::set(null, "*", "oraxi_bfm", oraxi_bfm);
        run_test();
    end

endmodule