module inelastic
  #(parameter [31:0] width_p = 8
  /* verilator lint_off WIDTHTRUNC*/
   ,parameter [0:0] datapath_reset_p = 0
  /* verilator lint_off WIDTHTRUNC*/
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] en_i

  // Fill in the ranges of the busses below
  ,input [width_p-1 : 0] data_i
  ,output [width_p-1 : 0] data_o);

for(genvar i = 0; i<width_p; i++) begin
 dff
 #()
 FlipFlop
 (.clk_i(clk_i)
 ,.reset_i(datapath_reset_p && reset_i)
 ,.d_i(data_i[i])
 ,.en_i(en_i)
 ,.q_o(data_o[i]));

end

endmodule
