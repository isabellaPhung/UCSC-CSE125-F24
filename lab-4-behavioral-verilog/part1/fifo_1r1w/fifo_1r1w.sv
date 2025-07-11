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
  wire [depth_log2_p:0] read_addr_mealy;
  wire [depth_log2_p:0] read_addr_moore;
  wire [depth_log2_p:0] ignore;
  wire [depth_log2_p:0] write_addr_moore;
  wire [width_p-1:0] out_data;
  wire [0:0] writing = 1'b1;
  wire [0:0] reading = 1'b0;
  logic [0:0] lastOp;
  wire [0:0] write = valid_i && ready_o && ~full;
  //wire [0:0] read = valid_o && ready_i && ~empty; //valid_o might be a cycle late so try it without it
  wire [0:0] read = valid_o && ready_i && ~empty; //normally includes ready_i as well, but when included, it fails tests. I guess ready_i is just too slow.
  //can also replace read with 1'b1 and it works.

  //lastOp
  always_ff @(posedge clk_i) begin
    if(reset_i)
      lastOp <= 1'b0;
    else if(write) //write
      lastOp <= writing;
    else if(read) //read
      lastOp <= reading;
  end

  assign ready_o = ~full;
  assign valid_o = ~empty; 
  
  assign full = (read_addr_moore[depth_log2_p-1:0] == write_addr_moore[depth_log2_p-1:0]) && (read_addr_moore[depth_log2_p] != write_addr_moore[depth_log2_p]);
  assign empty = read_addr_moore == write_addr_moore;

  ram_1r1w_sync
  #(.width_p(width_p)
   ,.depth_p(1<<(depth_log2_p)))
  mem
  (.rd_valid_i(valid_o && ~empty)
  ,.rd_addr_i(read_addr_mealy[depth_log2_p-1:0])
  ,.rd_data_o(out_data)
  ,.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.wr_valid_i(write)
  ,.wr_data_i(data_i)
  ,.wr_addr_i(write_addr_moore[depth_log2_p-1:0])
  );

  counter
  #(.width_p(depth_log2_p+1))
  readCounter
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.up_i(valid_o && ready_i)
  ,.down_i(1'b0)
  ,.mealy_count(read_addr_mealy) //unregistered
  ,.moore_count(read_addr_moore)); //registered

  counter
  #(.width_p(depth_log2_p+1))
  writeCounter
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.up_i(valid_i && ready_o)
  ,.down_i(1'b0)
  ,.mealy_count(ignore) //unregistered
  ,.moore_count(write_addr_moore)); //registered

  logic [width_p-1:0] out;
  logic [0:0] ignore1;
  logic [0:0] ignore2;
  elastic
  #(.width_p(width_p)
   ,.datapath_gate_p(1'b1)
   ,.datapath_reset_p(1'b1))
  elastic_reg
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.data_i(data_i)
  ,.valid_i(valid_i)
  ,.ready_o(ignore1)
  ,.valid_o(ignore2)
  ,.data_o(out)
  ,.ready_i(ready_i)
  );

  //hazard bypass
  
  /*
  logic [width_p - 1:0] finalOut;
  wire [0:0] hazard;
  wire [depth_log2_p:0] last_write_addr;
  assign last_write_addr = write_addr_moore - 1'b1;
  assign hazard = (read_addr_moore == last_write_addr) && lastOp == writing;
  always_ff @(posedge clk_i)begin
    if(reset_i)
      finalOut <= '0;
    else if (hazard)
      finalOut <= out;
    else
      finalOut <= out_data;
  end
  */
logic [width_p - 1:0] finalOut;
logic [0:0] hazard;
logic [depth_log2_p:0] last_write_addr;
always_comb begin
  last_write_addr = write_addr_moore - 1'b1;
  hazard = (read_addr_moore == last_write_addr) && lastOp == writing;
  if(hazard)begin //hazard!
    finalOut = out; //output from elastic pipeline
  end else begin //no hazard
    finalOut = out_data; //output from ram
  end
end
assign data_o = finalOut;

endmodule