module kpyd2hex
  (input [7:0] kpyd_i
  ,output [3:0] hex_o);

   // Your code here
  wire [0:0] ignore1;
  wire [0:0] ignore2;
  wire [0:0] ignore3;
  wire [3:0] ignore4;
  wire [3:0] ignore5;
  logic [3:0] col;
  logic [3:0] row;
  logic [3:0] index;
  logic [31:0] temp;
  always_comb begin
    col = kpyd_i[3:0];
    row = kpyd_i[7:4];
    //i wish i had adder to be able to add these in only 4 bits but I don't have time
    temp = ($clog2(col) + (($clog2(row))*(4'd4))); //credits to: https://stackoverflow.com/questions/21212340/convert-one-hot-encoding-to-plain-binary
    index = temp[3:0];
  end
  
  ram_1r1w_async
  #(.width_p(4)
   ,.depth_p(16)
   ,.filename_p("kpyd2hex.hex"))
  ram
  (.rd_addr_i(index)
  ,.rd_data_o(hex_o)
  ,.clk_i(ignore1)
  ,.reset_i(ignore2)
  ,.wr_valid_i(ignore3)
  ,.wr_data_i(ignore5)
  ,.wr_addr_i(ignore4));


endmodule
