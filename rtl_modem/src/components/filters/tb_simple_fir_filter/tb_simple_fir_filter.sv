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
    parameter                           G_SAMPLE_DW = 12;

    localparam                          IRAXI_DW_COEF = 16;
    localparam                          IRAXI_DW = G_SAMPLE_DW;
    localparam                          ORAXI_DW = 48;

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
          .DW(IRAXI_DW_COEF)
    )                                   iraxi_bfm_coef();
    raxi_bfm #(
          .DW(IRAXI_DW)
    )                                   iraxi_bfm();
    raxi_bfm #(
          .DW(ORAXI_DW)
    )                                   oraxi_bfm();

    assign iraxi_bfm_coef.clk           = clk;
    assign iraxi_bfm.clk                = clk;
    assign oraxi_bfm.clk                = clk;

//--------------------------------------------------------------------------------------------------------------------------------
// DUT connection
    bit                                 idut_clk;
    bit                                 idut_coef_rst;
    bit                                 idut_coef_valid;
    bit[15:0]                           idut_coef_data;
    bit                                 idut_valid;
    bit[IRAXI_DW-1:0]                   idut_data;
    bit                                 odut_valid;
    bit[ORAXI_DW-1:0]                   odut_data;
//--------------------------------------------------------------------------------------------------------------------------------
    simple_fir_filter #(
          .g_nof_taps                   (G_NOF_TAPS)
        , .g_sample_dw                  (G_SAMPLE_DW)
        , .g_iraxi_dw                   (IRAXI_DW)
        , .g_oraxi_dw                   (ORAXI_DW)
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
        , .G_SAMPLE_DW(G_SAMPLE_DW)
        , .IRAXI_DW_COEF(IRAXI_DW_COEF)
        , .IRAXI_DW(IRAXI_DW)
        , .ORAXI_DW(ORAXI_DW)
    )                                   simplefir_base_test_h;

    initial begin
        uvm_config_db #(virtual raxi_bfm #(IRAXI_DW_COEF))::set(null, "*", "iraxi_bfm_coef", iraxi_bfm_coef);
        uvm_config_db #(virtual raxi_bfm #(IRAXI_DW))::set(null, "*", "iraxi_bfm", iraxi_bfm);
        uvm_config_db #(virtual raxi_bfm #(ORAXI_DW))::set(null, "*", "oraxi_bfm", oraxi_bfm);
        run_test();
    end

endmodule