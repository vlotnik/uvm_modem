//--------------------------------------------------------------------------------------------------------------------------------
// name : tb_sin_cos_table
//--------------------------------------------------------------------------------------------------------------------------------
`timescale 100ps/100ps

module tb_sin_cos_table;
//--------------------------------------------------------------------------------------------------------------------------------
// settings
//--------------------------------------------------------------------------------------------------------------------------------
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // main test package
    import pkg_sincos::*;

    // main settings
    parameter                           GP_DW = 10;
    parameter                           FULL_TABLE = 0;
    parameter                           PHASE_DW = 12;
    parameter                           SINCOS_DW = 16;
    parameter                           PIPE_CE = 0;

    localparam                          IRAXI_DW = GP_DW + PHASE_DW;
    localparam                          ORAXI_DW = GP_DW + SINCOS_DW*2;

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
          .DW(IRAXI_DW)
    )                                   raxi_bfm_i();
    raxi_bfm #(
          .DW(ORAXI_DW)
    )                                   raxi_bfm_o();

//--------------------------------------------------------------------------------------------------------------------------------
// DUT connection
    bit                                 idut_clk;
    bit                                 idut_valid;
    bit[IRAXI_DW-1:0]                   idut_data;
    bit                                 odut_valid;
    bit[ORAXI_DW-1:0]                   odut_data;
//--------------------------------------------------------------------------------------------------------------------------------
    sin_cos_table #(
          .g_gp_dw                      (GP_DW)
        , .g_full_table                 (FULL_TABLE)
        , .g_phase_dw                   (PHASE_DW)
        , .g_sincos_dw                  (SINCOS_DW)
        , .g_pipe_ce                    (PIPE_CE)
        , .g_iraxi_dw                   (IRAXI_DW)
        , .g_oraxi_dw                   (ORAXI_DW)
    )
    dut(
          .iCLK                         (idut_clk)
        , .iVALID                       (idut_valid)
        , .iDATA                        (idut_data)
        , .oVALID                       (odut_valid)
        , .oDATA                        (odut_data)
    );

    assign idut_clk                     = clk;
    assign idut_valid                   = raxi_bfm_i.valid;
    assign idut_data                    = raxi_bfm_i.data;

    assign raxi_bfm_i.clk               = idut_clk;
    assign raxi_bfm_o.clk               = idut_clk;
    assign raxi_bfm_o.valid             = odut_valid;
    assign raxi_bfm_o.data              = odut_data;

//--------------------------------------------------------------------------------------------------------------------------------
// UVM test
//--------------------------------------------------------------------------------------------------------------------------------
    typedef sincos_base_test #(
          .GP_DW(GP_DW)
        , .FULL_TABLE(FULL_TABLE)
        , .PHASE_DW(PHASE_DW)
        , .SINCOS_DW(SINCOS_DW)
        , .PIPE_CE(PIPE_CE)
        , .IRAXI_DW(IRAXI_DW)
        , .ORAXI_DW(ORAXI_DW)
    )                                   sincos_base_test_h;

    initial begin
        uvm_config_db #(virtual raxi_bfm #(IRAXI_DW))::set(null, "*", "raxi_bfm_i", raxi_bfm_i);
        uvm_config_db #(virtual raxi_bfm #(ORAXI_DW))::set(null, "*", "raxi_bfm_o", raxi_bfm_o);
        run_test();
    end

endmodule