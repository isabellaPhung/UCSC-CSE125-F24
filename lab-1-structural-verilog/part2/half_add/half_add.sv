module half_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Your code here:
  and2
    #()
    and2_inst
     (.a_i(a_i)
    , .b_i(b_i)
    , .c_o(carry_o)
    );
  
  xor2
    #()
    xor2_inst
     (.a_i(a_i)
    , .b_i(b_i)
    , .c_o(sum_o)
    );

endmodule
