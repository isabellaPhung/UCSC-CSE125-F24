module hex2ssd
  (input [3:0] hex_i
  ,output [6:0] ssd_o
  );
  wire [6:0] temp;
  wire [0:0] ignore1;
  wire [0:0] ignore2;
  wire [0:0] ignore3;
  wire [3:0] ignore4;
  wire [6:0] ignore5;
  ram_1r1w_async
  #(.width_p(7)
   ,.depth_p(16)
   ,.filename_p("hex2ssd.hex"))
  ram
  (.rd_addr_i(hex_i)
  ,.rd_data_o(temp)
  ,.clk_i(ignore1)
  ,.reset_i(ignore2)
  ,.wr_valid_i(ignore3)
  ,.wr_data_i(ignore5)
  ,.wr_addr_i(ignore4)
  );
  assign ssd_o = ~temp;



endmodule
