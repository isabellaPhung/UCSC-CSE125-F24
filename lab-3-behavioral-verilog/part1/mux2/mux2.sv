
module mux2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] select_i
  ,output [0:0] c_o);

    // Your code here:
  SB_LUT4 
  #(.LUT_INIT(16'b0000_0000_1100_1010))
  LUT4_inst
  (.O(c_o)
  ,.I0(a_i)
  ,.I1(b_i)
  ,.I2(select_i)
  ,.I3(1'b0)
  );

endmodule
