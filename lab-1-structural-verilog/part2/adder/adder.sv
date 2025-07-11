module adder
  #(parameter width_p = 5)
  // You must fill in the bit widths of a_i, b_i and sum_o. a_i and
  // b_i must be width_p bits.
  (input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,output [width_p:0] sum_o); //is there no carry in?

  wire [width_p:0] carry_in;
  assign carry_in[0] = 0;

   // Your code here
   genvar i;
   generate
   for (i = 0; i < width_p; i++) begin: gen_adderLoop
      full_add
        #()
      full_add_inst
        (.a_i(a_i[i])
        ,.b_i(b_i[i])
        ,.carry_i(carry_in[i])
        ,.carry_o(carry_in[i+1])
        ,.sum_o(sum_o[i])
        );
   end
   endgenerate
   assign sum_o[width_p]=carry_in[width_p];

endmodule
