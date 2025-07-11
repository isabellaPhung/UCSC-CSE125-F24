module triadder
  #(parameter width_p = 5)
  // You must fill in the bit widths of a_i, b_i and sum_o. a_i and
  // b_i must be width_p bits.
  (input [width_p-1:0] a_i
  ,input [width_p-1:0] b_i
  ,input [width_p-1:0] c_i
  ,output [width_p+1:0] sum_o);

   // Your code here
   logic [width_p-1:0] cout;
   logic [width_p-1:0] sum;

  genvar i;
  for(i = 0; i < width_p; i++) begin
    full_add
      #()
      full_add_inst
      (.a_i(a_i[i])
      ,.b_i(b_i[i])
      ,.carry_i(c_i[i])
      ,.sum_o(sum[i])
      ,.carry_o(cout[i]));
      
  end
  assign sum_o = {1'b0, sum} + {cout,1'b0};
  endmodule
