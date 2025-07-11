// This is defined for you
`ifndef HEXPATH
 `define HEXPATH ""
`endif
module ram_1r1w_async
  #(parameter [31:0] width_p = 8
  ,parameter [31:0] depth_p = 8
  ,parameter string filename_p = "memory_init_file.bin")
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] wr_valid_i

  // Fill in the ranges of the busses below
  ,input [width_p-1 : 0] wr_data_i
  ,input [$clog2(depth_p)-1 : 0] wr_addr_i //the address is going to be clog2 of the depth

  ,input [$clog2(depth_p)-1 : 0] rd_addr_i
  ,output [width_p-1 : 0] rd_data_o);
  
  logic [width_p-1:0] mem [depth_p-1:0];
  assign rd_data_o = mem[rd_addr_i]; //read data = memory[index]

   initial begin //is this just for debugging?
      // Display depth and width (You will need to match these in your init file)
      $display("%m: depth_p is %d, width_p is %d", depth_p, width_p);
      // wire [bar:0] foo [baz:0];
      $readmemh({`HEXPATH, filename_p}, mem , 0, depth_p-1);
      // In order to get the memory contents in iverilog you need to run this for loop during initialization:
      // synopsys translate_off
      //for (int i = 0; i < depth_p; i++)
      //  $dumpvars(0, mem); //why does this have to be commented out?
      // synopsys translate_on
   end

   
   always_ff @(posedge clk_i) begin
    if(wr_valid_i && !reset_i) begin //if reset is high, don't write
      mem[wr_addr_i] <= wr_data_i;
    end
   end


endmodule
