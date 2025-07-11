module full_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] carry_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Your code here:
   wire [0:0] ignore;
   ICESTORM_LC
   #(.LUT_INIT(16'b1100_0011_0011_1100)
    ,.CIN_SET(1'b0)
    ,.CARRY_ENABLE(1'b1))//carry on
   IceLattice_inst
   (.I3(carry_i)
   ,.I2(b_i)
   ,.I1(a_i)
   ,.I0(1'b0)
   ,.CIN(carry_i)
   ,.CLK(1'b1)
   ,.CEN(1'b1)
   ,.SR(1'b0)
   ,.LO(sum_o)
   ,.O(ignore)
   ,.COUT(carry_o)
   );

endmodule
