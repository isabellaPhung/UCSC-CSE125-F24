module multiplier
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 16
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] valid_i
  ,input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,output [0:0] ready_o

  ,output [0:0] valid_o 
  ,output [(2 * width_p) - 1:0] c_o
  ,input [0:0] ready_i
  );

  wire [47:0] result;
  //wire [(2*width_p) - 1:0] result;
  //bit extensions
  wire [17:0] a, b;
  assign a = {{2{1'b0}}, a_i};
  assign b = {{2{1'b0}}, b_i};

  DSP48A1 #(
    .A0REG(32'sd0),
    .A1REG(32'sd0),
    .B0REG(32'sd0),
    .B1REG(32'sd0),
    .CARRYINREG(32'sd0),
    .CARRYOUTREG(32'sd0),
    .CARRYINSEL("OPMODE5"), //don't need carry in
    .CREG(32'sd0),
    .DREG(32'sd0),
    .MREG(32'sd0),
    .OPMODEREG(32'sd0),
    .PREG(32'sd1) //going to use p reg for pipelining
  ) DSP ( 
    .CLK(clk_i),
    .A(a),
    .B(b),
    .C(48'h000000000000),
    .D(18'h00000),
    .OPMODE(8'h01),
    .P(result),
    .RSTP(reset_i),
    .CEP(valid_i && ready_o)
  );

  //elastic pipelining
  assign ready_o = ~valid_o || (valid_o & ready_i);

  logic [0:0] validOut;
  always_ff @(posedge clk_i) begin
    if(reset_i) begin
      validOut <= '0;
    end else if (ready_o) begin 
      validOut <= valid_i;
    end
  end
  assign valid_o = validOut;
  assign c_o = result[(2*width_p)-1:0];
 
endmodule
