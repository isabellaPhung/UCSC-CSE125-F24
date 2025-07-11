module delaybuffer
  #(parameter [31:0] width_p = 8
   ,parameter [31:0] delay_p = 8
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

assign ready_o = ~valid_o || (valid_o & ready_i);
logic [0:0] validOut;
wire [$clog2(delay_p):0] addr;
//why use width_p, but delay_p + 1?
//data technically delayed by delay_p + 1 cycles
ram_1r1w_sync
#(.width_p(width_p)
  ,.depth_p(delay_p+1))
mem
(.rd_valid_i(valid_i && ready_o)
,.rd_addr_i(addr)
,.rd_data_o(data_o)
,.clk_i(clk_i)
,.reset_i(reset_i)
,.wr_valid_i(valid_i && ready_o)
,.wr_data_i(data_i)
,.wr_addr_i(addr)
);

//using max val counter
//why use width_p $clog(delay_p)+1?
//in case we have delay_p 16, this way our counter
//width accomodates for that
//why use delay_p-1 for max_val_p?
//ram indexes from 0 to delay_p-1 so our counter
//needs to be identical
counter
#(.width_p($clog2(delay_p)+1)
 ,.max_val_p(delay_p-1))
count_addr
(.clk_i(clk_i)
,.reset_i(reset_i)
,.up_i((valid_i && ready_o))
,.down_i(1'b0)
,.count_o(addr));

always_ff @(posedge clk_i) begin
    if(reset_i) begin
      validOut <= '0;
    end else if (ready_o) begin 
      validOut <= valid_i;
    end
end
assign valid_o = validOut;

endmodule

