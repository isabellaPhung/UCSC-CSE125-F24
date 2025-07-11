module elastic
  #(parameter [31:0] width_p = 8
  /* verilator lint_off WIDTHTRUNC*/
   ,parameter [0:0] datapath_gate_p = 1
   ,parameter [0:0] datapath_reset_p = 1
  /* verilator lint_off WIDTHTRUNC*/
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

logic [width_p-1:0] data_r;
logic [0:0] validOut;
always_ff @(posedge clk_i) begin
    if(datapath_reset_p && reset_i) begin
      data_r <= '0;
    end else if (datapath_gate_p && (valid_i && ready_o) || (~datapath_gate_p && (ready_o))) begin
      data_r <= data_i;
    end 
    
    if(reset_i) begin
      validOut <= '0;
    end else if (ready_o) begin 
      validOut <= valid_i;
    end

end
assign data_o = data_r;
assign valid_o = validOut;

endmodule
