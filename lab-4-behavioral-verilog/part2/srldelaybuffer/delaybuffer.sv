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

for(genvar i = 0; i<width_p; i++)begin: shiftReg_loop
  SRL16E
  #()
  shiftReg
  (.Q(data_o[i])
  ,.A0(delay_p[0])
  ,.A1(delay_p[1])
  ,.A2(delay_p[2])
  ,.A3(delay_p[3])
  ,.CE(valid_i && ready_o)
  ,.CLK(clk_i)
  ,.D(data_i[i]));
end

always_ff @(posedge clk_i) begin
    if(reset_i) begin
      validOut <= '0;
    end else if (ready_o) begin 
      validOut <= valid_i;
    end
end

assign valid_o = validOut;

endmodule

