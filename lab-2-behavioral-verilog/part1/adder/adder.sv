module adder
  #(parameter width_p = 5)
  // You must fill in the bit widths of a_i, b_i and sum_o. a_i and
  // b_i must be width_p bits.
  (input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,output [width_p:0] sum_o);


   // Your code here
   assign sum_o = a_i + b_i;
endmodule
