module fifo_1r1w
  #(parameter [31:0] width_p = 8
   // Note: Not depth_p! depth_p should be 1<<depth_log2_p
   ,parameter [31:0] depth_log2_p = 8
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] ready_i
  );
  
  wire [0:0] full;
  wire [0:0] empty;
  wire [depth_log2_p-1:0] read_addr;
  wire [depth_log2_p-1:0] write_addr;
  wire [width_p-1:0] out_data;
  wire [0:0] writing = 1'b1;
  wire [0:0] reading = 1'b0;
  logic [0:0] lastOp;
  wire [0:0] write = valid_i && ready_o && ~full;
  wire [0:0] read = valid_o && ready_i;

  always_ff @(posedge clk_i) begin
    if(reset_i)
      lastOp <= 1'b0;
    else if(valid_i && ready_o && ~full) //write
      lastOp <= 1'b1;
    else if(valid_o && ready_i && ~empty) //read
      lastOp <= 1'b0;
  end
  assign ready_o = ~full;
  assign valid_o = ~empty; 
  assign full = (read_addr == write_addr) && (lastOp == writing);
  assign empty = (read_addr == write_addr) && (lastOp == reading);

  ram_1r1w_async
  #(.width_p(width_p)
   ,.depth_p(1<<depth_log2_p))
  ram
  (.rd_addr_i(read_addr)
  ,.rd_data_o(out_data)
  ,.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.wr_valid_i(valid_i && ready_o && ~full)
  ,.wr_data_i(data_i)
  ,.wr_addr_i(write_addr)
  );

  counter
  #(.width_p(depth_log2_p))
  readCounter
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.up_i(valid_o && ready_i)
  ,.down_i(1'b0)
  ,.count_o(read_addr));

  counter
  #(.width_p(depth_log2_p))
  writeCounter
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.up_i(valid_i && ready_o)
  ,.down_i(1'b0)
  ,.count_o(write_addr));
  assign data_o = out_data;
/*
  elastic
  #(.width_p(width_p))
  pipeline
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.data_i(out_data)
  ,.valid_i(valid_i)
  ,.ready_o(ready_o)
  ,.valid_o(valid_o)
  ,.data_o(data_o)
  ,.ready_i(ready_i)
  );
*/
endmodule
