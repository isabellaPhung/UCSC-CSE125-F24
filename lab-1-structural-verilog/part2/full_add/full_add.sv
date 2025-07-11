module full_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] carry_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Your code here:
  wire [0:0] carry_1;
  wire [0:0] carry_2;

  wire [0:0] sum_1;
  
  half_add
    #()
    half_add_inst_1
     (.a_i(a_i)
    , .b_i(b_i)
    , .carry_o(carry_1)
    , .sum_o(sum_1)
    );
  
  half_add
    #()
    half_add_inst_2
     (.a_i(sum_1)
    , .b_i(carry_i)
    , .carry_o(carry_2)
    , .sum_o(sum_o)
    );

  or2
    #()
    or2_inst
     (.a_i(carry_1)
    , .b_i(carry_2)
    , .c_o(carry_o)
    );
 
endmodule
