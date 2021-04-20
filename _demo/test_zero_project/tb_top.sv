`timescale 100ps/100ps

module tb_top;
//--------------------------------------------------------------------------------------------------------------------------------
// libraries
//--------------------------------------------------------------------------------------------------------------------------------
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "common_macros.svh"

    import pkg_modem::*;

    `print_logo

//--------------------------------------------------------------------------------------------------------------------------------
// clock generator
//--------------------------------------------------------------------------------------------------------------------------------
    bit clk = 0;
    // 100 MHz
    always #50 clk = ~clk;

endmodule