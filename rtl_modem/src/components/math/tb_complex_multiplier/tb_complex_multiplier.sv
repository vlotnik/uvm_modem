//--------------------------------------------------------------------------------------------------------------------------------
// name : tb_complex_multiplier
//--------------------------------------------------------------------------------------------------------------------------------
`timescale 100ps/100ps

module tb_complex_multiplier;
//--------------------------------------------------------------------------------------------------------------------------------
// settings
//--------------------------------------------------------------------------------------------------------------------------------
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // main test package
    import pkg_compmult::*;

    // main settings
    parameter                           GPDW = 10;
    parameter                           A_W = 12;
    parameter                           B_W = 12;
    parameter                           TYPE = 0;
    parameter                           CONJ_MULT = 0;
    parameter                           PIPE_CE = 0;

    localparam                          C_DW = A_W + B_W + 1;
    localparam                          RAXI_DWI = GPDW + A_W*2 + B_W*2;
    localparam                          RAXI_DWO = GPDW + C_DW*2;

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
    )                               raxi_bfm_i();
    raxi_bfm #(
          .DW(RAXI_DWO)
    )                               raxi_bfm_o();

//--------------------------------------------------------------------------------------------------------------------------------
// DUT connection
    bit                                 idut_clk;
    bit                                 idut_v;
    bit[GPDW-1:0]                       idut_gp;
    bit[A_W-1:0]                        idut_a_i;
    bit[A_W-1:0]                        idut_a_q;
    bit[B_W-1:0]                        idut_b_i;
    bit[B_W-1:0]                        idut_b_q;
    bit                                 odut_v;
    bit[GPDW-1:0]                       odut_gp;
    bit[C_DW-1:0]                       odut_c_i;
    bit[C_DW-1:0]                       odut_c_q;
//--------------------------------------------------------------------------------------------------------------------------------
    complex_multiplier_wrap #(
          .g_gpdw                       (GPDW)
        , .g_a_w                        (A_W)
        , .g_b_w                        (B_W)
        , .g_type                       (TYPE)
        , .g_conj_mult                  (CONJ_MULT)
        , .g_pipe_ce                    (PIPE_CE)
    )
    dut (
          .iCLK                         (idut_clk)
        , .iV                           (idut_v)
        , .iGP                          (idut_gp)
        , .iA_I                         (idut_a_i)
        , .iA_Q                         (idut_a_q)
        , .iB_I                         (idut_b_i)
        , .iB_Q                         (idut_b_q)
        , .oV                           (odut_v)
        , .oGP                          (odut_gp)
        , .oC_I                         (odut_c_i)
        , .oC_Q                         (odut_c_q)
    );

    assign idut_clk = clk;
    assign idut_v = raxi_bfm_i.valid;
    assign {idut_gp, idut_b_q, idut_b_i, idut_a_q, idut_a_i} = raxi_bfm_i.data;

    assign raxi_bfm_i.clk = idut_clk;
    assign raxi_bfm_o.clk = idut_clk;
    assign raxi_bfm_o.valid = odut_v;
    assign raxi_bfm_o.data = {odut_gp, odut_c_q, odut_c_i};

//--------------------------------------------------------------------------------------------------------------------------------
// UVM test
//--------------------------------------------------------------------------------------------------------------------------------
    typedef compmult_base_test #(
          .GPDW(GPDW)
        , .A_W(A_W)
        , .B_W(B_W)
        , .CONJ_MULT(CONJ_MULT)
        , .PIPE_CE(PIPE_CE)
        , .RAXI_DWI(RAXI_DWI)
        , .RAXI_DWO(RAXI_DWO)
    )                                   compmult_base_test_h;

    initial begin
        uvm_config_db #(virtual raxi_bfm #(RAXI_DWI))::set(null, "*", "raxi_bfm_i", raxi_bfm_i);
        uvm_config_db #(virtual raxi_bfm #(RAXI_DWO))::set(null, "*", "raxi_bfm_o", raxi_bfm_o);
        run_test();
    end

endmodule