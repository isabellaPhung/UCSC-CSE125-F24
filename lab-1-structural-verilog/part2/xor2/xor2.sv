module xor2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] c_o);

   // Your code here:
  wire [0:0] tempAND;
  wire [0:0] tempOR;
  wire [0:0] tempNAND;
  
  or2
    #()
  or2_inst
     (.a_i(a_i)
    , .b_i(b_i)
    , .c_o(tempOR)
    );
 
  and2
    #()
  and2_inst_1
     (.a_i(a_i)
    , .b_i(b_i)
    , .c_o(tempAND)
    );
  
  inv
    #()
  inv_inst_b
     (.a_i(tempAND)
     ,.b_o(tempNAND)
     );
  
  and2
    #()
  and2_inst2
     (.a_i(tempNAND)
    , .b_i(tempOR)
    , .c_o(c_o)
    );

endmodule
