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
    parameter                           GPDW = 10;
    parameter                           FULL_TABLE = 0;
    parameter                           PHASE_W = 12;
    parameter                           SINCOS_W = 16;
    parameter                           PIPE_CE = 0;

    localparam                          RAXI_DWI = GPDW + PHASE_W;
    localparam                          RAXI_DWO = GPDW + SINCOS_W*2;

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
          .DW(RAXI_DWI)
    )                                   raxi_bfm_i();
    raxi_bfm #(
          .DW(RAXI_DWO)
    )                                   raxi_bfm_o();

//--------------------------------------------------------------------------------------------------------------------------------
// DUT connection
    bit                                 idut_clk;
    bit                                 idut_valid;
    bit[RAXI_DWI-1:0]                   idut_data;
    bit                                 odut_valid;
    bit[RAXI_DWO-1:0]                   odut_data;
//--------------------------------------------------------------------------------------------------------------------------------
    sin_cos_table #(
          .g_raxi_dwi                   (RAXI_DWI)
        , .g_raxi_dwo                   (RAXI_DWO)
        , .g_gpdw                       (GPDW)
        , .g_full_table                 (FULL_TABLE)
        , .g_phase_w                    (PHASE_W)
        , .g_sincos_w                   (SINCOS_W)
        , .g_pipe_ce                    (PIPE_CE)
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
          .GPDW(GPDW)
        , .FULL_TABLE(FULL_TABLE)
        , .PHASE_W(PHASE_W)
        , .SINCOS_W(SINCOS_W)
        , .PIPE_CE(PIPE_CE)
        , .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                                   sincos_base_test_h;

    initial begin
        uvm_config_db #(virtual raxi_bfm #(RAXI_DWI))::set(null, "*", "raxi_bfm_i", raxi_bfm_i);
        uvm_config_db #(virtual raxi_bfm #(RAXI_DWO))::set(null, "*", "raxi_bfm_o", raxi_bfm_o);
        run_test();
    end

endmodule