module xnor2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] c_o);

   // Your code here:
  wire [0:0] tempAND2;
  wire [0:0] tempAND1;
  wire [0:0] neg_a;
  wire [0:0] neg_b;
  
  and2
    #()
  and2_inst
     (.a_i(a_i)
    , .b_i(b_i)
    , .c_o(tempAND1)
    );
  
  inv
    #()
  inv_inst_a
     (.a_i(a_i)
     ,.b_o(neg_a)
     );
  
  inv
    #()
  inv_inst_b
     (.a_i(b_i)
     ,.b_o(neg_b)
     );
  
  and2
    #()
  and2_inv
     (.a_i(neg_a)
    , .b_i(neg_b)
    , .c_o(tempAND2)
    );
  
  or2
    #()
  or2_inst
     (.a_i(tempAND1)
    , .b_i(tempAND2)
    , .c_o(c_o)
    );

endmodule
