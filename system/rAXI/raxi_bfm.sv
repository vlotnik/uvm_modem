//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_bfm
//--------------------------------------------------------------------------------------------------------------------------------
interface raxi_bfm #(
      DW = 10
);
//--------------------------------------------------------------------------------------------------------------------------------
    bit                                 clk;
    bit                                 valid;
    bit[DW-1:0]                         data;
endinterface