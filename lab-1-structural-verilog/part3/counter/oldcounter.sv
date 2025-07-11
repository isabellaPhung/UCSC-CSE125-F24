module counter
  #(parameter width_p = 4)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   // Your code here:
  wire [0:0] enable;
  wire [0:0] new_up;
  wire [0:0] xor_out;
  wire [0:0] inv_count;
  wire [0:0] incdec_select;

  xor2
    #()
  xor_inst_enable
    (.a_i(up_i)
    ,.b_i(down_i)
    ,.c_o(enable)
    );

  //initial count_o <= 0; 
  assign count_o = 0;
  for (genvar i = 0; i < width_p-1; i++) begin: gen_counterLoop
    inv
      #()
    inv_inst
      (.a_i(count_o[i])
      ,.b_o(inv_count)
      );
    
    mux2
      #()
    mux2_inst
      (.a_i(count_o[i])
      ,.b_i(inv_count)
      ,.select_i(down_i)
      ,.c_o(incdec_select)
      );
    
    xor2
      #()
    xor_inst
      (.a_i(new_up)
      ,.b_i(incdec_select)
      ,.c_o(xor_out)
      );
   
    dff
      #()
    dff_inst
      (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.d_i(xor_out)
      ,.en_i(enable)
      ,.q_o(count_o[i])
      );
  
    and2
      #()
    and_inst
      (.a_i(up_i)
      ,.b_i(count_o[i])
      ,.c_o(new_up)
      );
  end
  inv
    #()
  inv_inst_final
    (.a_i(count_o[width_p-1])
    ,.b_o(inv_count)
    );
  
  mux2
    #()
  mux2_inst_final
    (.a_i(count_o[width_p-1])
    ,.b_i(inv_count)
    ,.select_i(down_i)
    ,.c_o(incdec_select)
    );

  xor2
    #()
  xor_inst_last
    (.a_i(new_up)
    ,.b_i(incdec_select)
    ,.c_o(xor_out)
    );

  dff
    #()
  dff_inst_last
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.d_i(xor_out)
    ,.en_i(enable)
    ,.q_o(count_o[width_p-1])
    );

endmodule
