interface compmult_bfm #(
          A_DW = 25
        , B_DW = 18
    );

    bit                                 iclk;
    bit                                 iv;
    bit[A_DW-1:0]                       ia_i;
    bit[A_DW-1:0]                       ia_q;
    bit[B_DW-1:0]                       ib_i;
    bit[B_DW-1:0]                       ib_q;
    bit                                 ov;
    bit[A_DW+B_DW:0]                    oc_i;
    bit[A_DW+B_DW:0]                    oc_q;
endinterface