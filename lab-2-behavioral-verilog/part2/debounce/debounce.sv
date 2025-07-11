module debounce
  #(parameter min_delay_p = 4
    )
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] button_i
   ,output [0:0] button_o);

   // Your code here:
   wire [31:0] count;
   counter
   #(.width_p(6'd32))
   counter_inst
   (.clk_i(clk_i)
   ,.reset_i(reset_i || button_i == 1'b0)
   ,.up_i(button_i == 1'b1)
   ,.down_i(1'b0)
   ,.count_o(count)
   );
   logic [0:0] button;
   always_ff@(posedge clk_i)begin
      if(count < min_delay_p)begin
        button <= 1'b0;
      end else if(count >= min_delay_p)begin
        button <= 1'b1;
      end
    end
   assign button_o = button;
   
endmodule
