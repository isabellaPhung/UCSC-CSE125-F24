// Top-level design file for the icebreaker FPGA board
//
// Wi23, Lab 3
module top
  (input [0:0] clk_12mhz_i
   // n: Negative Polarity (0 when pressed, 1 otherwise)
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
  ,input [0:0] reset_n_async_unsafe_i
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
  ,input [3:0] kpyd_row_i
  ,output [3:0] kpyd_col_o
  ,output [7:0] ssd_o);

   // These two D Flip Flops form what is known as a Synchronizer. We
   // will learn about these in Week 5, but you can see more here:
   // https://inst.eecs.berkeley.edu/~cs150/sp12/agenda/lec/lec16-synch.pdf
   wire reset_n_sync_r;
   wire reset_sync_r;
   wire reset_r; // Use this as your reset_signal
   dff
     #()
   sync_a
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.en_i(1'b1)
     ,.d_i(reset_n_async_unsafe_i)
     ,.q_o(reset_n_sync_r));

   inv
     #()
   inv
     (.a_i(reset_n_sync_r)
     ,.b_o(reset_sync_r));

   dff
     #()
   sync_b
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.en_i(1'b1)
     ,.d_i(reset_sync_r)
     ,.q_o(reset_r));
       

   // Your code here
   wire [3:0] hex;
   kpyd2hex
   #()
   keypadToHex
   (.kpyd_i(~{kpyd_col_o,kpyd_row_i})
   ,.hex_o(hex)
   );

   hex2ssd
   #()
   hexToSeven
   (.hex_i(hex)
   ,.ssd_o(ssd_o[6:0])
   );

   assign ssd_o[7] = clk_12mhz_i;


endmodule
