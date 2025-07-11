module shift
  #(parameter depth_p = 5
    /* verilator lint_off WIDTHTRUNC */
   ,parameter [depth_p-1:0] reset_val_p = '0)
   /* verilator lint_on WIDTHTRUNC */   
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] data_i
   ,input [0:0] enable_i
   ,output [depth_p-1:0] data_o);


dff
    #(.reset_val_p(reset_val_p[0]))
  dff_inst
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.d_i(data_i)
    ,.en_i(enable_i)
    ,.q_o(data_o[0])
    );

genvar i;
generate
for (i = 1; i < depth_p; i++) begin: genshiftLoop
  dff #(.reset_val_p(reset_val_p[i]))
    dff_inst
      (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.d_i(data_o[i-1])
      ,.en_i(enable_i)
      ,.q_o(data_o[i])
      );
end
endgenerate

endmodule
