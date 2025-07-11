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
logic [width_p-1:0] buffer [delay_p:-1];
always_comb begin
    buffer[-1] = data_i;
end

for(genvar i = 0; i<=delay_p; i++) begin: ff_loop
    always_ff @(posedge clk_i) begin
        if(reset_i) begin
            buffer[i] <= '0;
        end else if (valid_i && ready_o) begin
            buffer[i] <= buffer[i-1];
        end 
    end
end

always_ff @(posedge clk_i) begin
    if(reset_i) begin
      validOut <= '0;
    end else if (ready_o) begin 
      validOut <= valid_i;
    end
end
assign data_o = buffer[delay_p]; //may need to delay it one more cycle
assign valid_o = validOut;

endmodule
