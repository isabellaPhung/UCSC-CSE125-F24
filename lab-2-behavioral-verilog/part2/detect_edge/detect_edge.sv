module detect_edge
   (input [0:0] clk_i
    // reset_i will go low at least one cycle before a button is pushed.
   ,input [0:0] reset_i
   ,input [0:0] button_i
    // Should go high for 1 cycle, after a positive edge
   ,output [0:0] button_o
    // Should go high for 1 cycle, after a negative edge
   ,output [0:0] unbutton_o
   );

   // Your code here:
   wire [1:0] data_o;
   shift
   #(.width_p(2))
   shift_inst
   (.clk_i(clk_i)
   ,.reset_i(reset_i)
   ,.en_i(1'b1)
   ,.d_i(button_i)
   ,.data_o(data_o)
   ,.load_i(1'b0)
   ,.data_i(2'b0)
   );
   assign button_o = data_o[0] && ~data_o[1];
   assign unbutton_o = data_o[1] && ~data_o[0];
endmodule
