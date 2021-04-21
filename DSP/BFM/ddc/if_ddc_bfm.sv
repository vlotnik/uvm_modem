interface if_ddc_bfm #(
          INCH_NUMBER = 1
        , SIGNAL_TYPE = 0
    );

    bit                             clk;
    bit                             iq_v;
    bit[15:0]                       iq_i[INCH_NUMBER];
    bit[15:0]                       iq_q[INCH_NUMBER];
endinterface