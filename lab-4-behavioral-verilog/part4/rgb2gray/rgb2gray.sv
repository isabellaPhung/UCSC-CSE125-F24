module rgb2gray
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 8
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] valid_i
  ,input [width_p - 1:0] red_i
  ,input [width_p - 1:0] blue_i
  ,input [width_p - 1:0] green_i
  ,output [0:0] ready_o

  ,output [0:0] valid_o
  ,output [width_p - 1:0] gray_o
  ,input [0:0] ready_i
  );

   // The testbench uses this function to test your code. How many
   // fractional bits are needed to enode these values?

  wire [0:0] ready_internal;
  wire [0:0] valid_internal;

   // gray = 0.2989 * r + 0.5870 * g + 0.1140 * b
   wire [(2*width_p)+1:-40] grayout;
   wire [width_p-1:-20] r_const = 28'b0000_0000_0100_1100_1000_1011_0100; //0.2990
   //wire [width_p-1:-20] r_const = 28'b0000_0000_0100_1100_1000_0100_1011; //0.2989
   wire [width_p-1:-20] g_const = 28'b0000_0000_1001_0110_0100_0101_1010; //0.5870
   wire [width_p-1:-20] b_const = 28'b0000_0000_0001_1101_0010_1111_0010; //0.1140
   //bit extensions:
   wire [width_p-1:-20] red = {red_i, {20{1'b0}}};
   wire [width_p-1:-20] blue = {blue_i, {20{1'b0}}};
   wire [width_p-1:-20] green = {green_i, {20{1'b0}}};
   wire [(2*width_p)-1:-40] redVal = red*r_const;
   wire [(2*width_p)-1:-40] greenVal = green*g_const;
   wire [(2*width_p)-1:-40] blueVal = blue*b_const;
   wire [(2*width_p):-40] test = redVal + greenVal;
   wire [(2*width_p)+1:-40] grayin = test + blueVal;
   
  elastic
  #(.width_p((2*width_p)+40)
   ,.datapath_gate_p(1'b1)
   ,.datapath_reset_p(1'b1))
  pipeline1
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.data_i(grayin)
  ,.valid_i(valid_i)
  ,.ready_o(ready_o)
  ,.valid_o(valid_internal)
  ,.data_o(grayout)
  ,.ready_i(ready_internal));

  elastic
  #(.width_p(width_p)
   ,.datapath_gate_p(1'b1)
   ,.datapath_reset_p(1'b1))
  pipeline2
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.data_i(grayout[width_p:0])
  ,.valid_i(valid_internal)
  ,.ready_o(ready_internal)
  ,.valid_o(valid_o)
  ,.data_o(gray_o)
  ,.ready_i(ready_i));
   
endmodule

