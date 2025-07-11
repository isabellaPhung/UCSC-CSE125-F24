module lfsr
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] en_i
   ,output [8:0] data_o);

wire [0:0] data_in;

xor2
   #()
   xor_inst
   (.a_i(data_o[3])
   ,.b_i(data_o[8])
   ,.c_o(data_in)
   );

shift
   #(.depth_p(4'b1001), .reset_val_p({{8{1'b0}}, 1'b1}))
   shift_inst
   (.clk_i(clk_i)
   ,.reset_i(reset_i)
   ,.data_i(data_in)
   ,.enable_i(en_i)
   ,.data_o(data_o)
   );

endmodule
