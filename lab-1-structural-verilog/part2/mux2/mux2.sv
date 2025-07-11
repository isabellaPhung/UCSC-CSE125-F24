module mux2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] select_i
  ,output [0:0] c_o);

   // Your code here:
   wire [0:0] neg_select;
   wire [0:0] temp1;
   wire [0:0] temp2;
  
   inv
    #()
    inv_inst_select
     (.a_i(select_i)
     ,.b_o(neg_select)
     );

   and2
    #()
    and2_inst_1
     (.a_i(a_i)
    , .b_i(neg_select)
    , .c_o(temp1)
    );
  
   and2
    #()
    and2_inst_0
     (.a_i(b_i)
    , .b_i(select_i)
    , .c_o(temp2)
    );

   or2
    #()
    or2_inst
     (.a_i(temp1)
    , .b_i(temp2)
    , .c_o(c_o)
    );

endmodule
