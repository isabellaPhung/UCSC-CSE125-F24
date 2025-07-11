module mac
 #(parameter int_in_lp = 1
  ,parameter frac_in_lp = 11
  ,parameter int_out_lp = 10
  ,parameter frac_out_lp = 22
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [int_in_lp - 1 : -frac_in_lp] a_i
  ,input [int_in_lp - 1 : -frac_in_lp] b_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,input [0:0] ready_i
  ,output [0:0] valid_o 
  ,output [int_out_lp - 1 : -frac_out_lp] data_o
  );
//fix this to handle any output size, remember dsp output size is 32 bits
  assign ready_o = ~valid_o || (valid_o & ready_i);

  logic signed [int_out_lp - 1 : -frac_out_lp] data_r;
  logic [0:0] validOut;
  always_ff @(posedge clk_i) begin
      if(reset_i) begin
        data_r <= '0;
      end else if (valid_i && ready_o) begin
        data_r <= $signed(a_i) * $signed(b_i) + data_r;
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
