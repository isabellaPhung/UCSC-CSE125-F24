module fifo_1r1w_cdc
 #(parameter [31:0] width_p = 32
  ,parameter [31:0] depth_log2_p = 8
  )
   // To emphasize that the two interfaces are in different clock
   // domains i've annotated the two sides of the fifo with "c" for
   // consumer, and "p" for producer. 
  (input [0:0] cclk_i
  ,input [0:0] creset_i
  ,input [width_p - 1:0] cdata_i
  ,input [0:0] cvalid_i
  ,output [0:0] cready_o 

  ,input [0:0] pclk_i
  ,input [0:0] preset_i
  ,output [0:0] pvalid_o 
  ,output [width_p - 1:0] pdata_o 
  ,input [0:0] pready_i
  );
  
  wire [0:0] full;
  wire [0:0] empty;
  wire [depth_log2_p:0] read_addr;
  wire [depth_log2_p:0] write_addr;
  wire [depth_log2_p:0] read_addr_prime; //read address in consumer clk domain
  wire [depth_log2_p:0] write_addr_prime; //write address in producer clk domain
  wire [0:0] write = cvalid_i && cready_o;
  wire [0:0] read = pvalid_o && pready_i;
  

  //consumer clk domain
  assign full = (read_addr_prime[depth_log2_p-1:0] == write_addr[depth_log2_p-1:0]) && (read_addr_prime[depth_log2_p] != write_addr[depth_log2_p]);
  assign cready_o = ~full;
  //producer clk domain
  assign empty = read_addr == write_addr_prime;
  assign pvalid_o = ~empty;
  
  ram_1r1w_async
  #(.width_p(width_p)
   ,.depth_p(1<<depth_log2_p))
  ram
  (.rd_addr_i(read_addr[depth_log2_p-1:0])
  ,.rd_data_o(pdata_o)
  ,.clk_i(cclk_i)
  ,.reset_i(creset_i)
  ,.wr_valid_i(write)
  ,.wr_data_i(cdata_i)
  ,.wr_addr_i(write_addr[depth_log2_p-1:0])
  );

  //read logic
  //producer clk domain
  counter
  #(.width_p(depth_log2_p+1))
  rd_counter
  (.clk_i(pclk_i)
  ,.reset_i(preset_i)
  ,.up_i(read)
  ,.down_i(1'b0)
  ,.count_o(read_addr)
  );

  wire [depth_log2_p:0] read_addr_gray;
  bin2gray
  #(.width_p(depth_log2_p+1))
  rd_bin2gray
  (.bin_i(read_addr)
  ,.gray_o(read_addr_gray)
  );

  //consumer clk domain
  logic [depth_log2_p:0] rd_synchOut1;
  always_ff @(posedge cclk_i)begin
    rd_synchOut1 <= read_addr_gray;
  end

  logic [depth_log2_p:0] rd_synchOut2;
  always_ff @(posedge cclk_i)begin
    rd_synchOut2 <= rd_synchOut1;
  end

  gray2bin
  #(.width_p(depth_log2_p+1))
  rd_gray2bin
  (.gray_i(rd_synchOut2)
  ,.bin_o(read_addr_prime)
  );

  //write logic 
  //consumer clk domain
  counter
  #(.width_p(depth_log2_p+1))
  wr_counter
  (.clk_i(cclk_i)
  ,.reset_i(creset_i)
  ,.up_i(write)
  ,.down_i(1'b0)
  ,.count_o(write_addr)
  );

  wire[depth_log2_p:0] write_addr_gray;
  bin2gray
  #(.width_p(depth_log2_p+1))
  wr_bin2gray
  (.bin_i(write_addr)
  ,.gray_o(write_addr_gray)
  );

  //producer clk domain 
  logic [depth_log2_p:0] wr_synchOut1;
  always_ff @(posedge pclk_i)begin
    wr_synchOut1 <= write_addr_gray;
  end

  logic [depth_log2_p:0] wr_synchOut2;
  always_ff @(posedge pclk_i)begin
    wr_synchOut2 <= wr_synchOut1;
  end

  gray2bin
  #(.width_p(depth_log2_p+1))
  wr_gray2bin
  (.gray_i(wr_synchOut2)
  ,.bin_o(write_addr_prime)
  ); 
endmodule

