module shift
  #(parameter width_p = 5
    /* verilator lint_off WIDTHTRUNC */
   ,parameter [width_p-1:0] reset_val_p = '0)
   /* verilator lint_on WIDTHTRUNC */   
   (input [0:0] clk_i
   ,input [0:0] reset_i //resets value to reset_val_p
   ,input [0:0] en_i //places d_i in index 0 when en_i = 1
   ,input [0:0] d_i
   ,input [0:0] load_i //priority over en_i
   ,input [width_p-1:0] data_i // if load ==1, data_o = data_i
   ,output [width_p-1:0] data_o);

wire [0:0] ignore1;
wire [0:0] ignore2;

ICESTORM_LC
    #(.LUT_INIT(16'b0000_0000_1100_1010)
      ,.SET_NORESET(reset_val_p[0])
      ,.DFF_ENABLE(1'b1))//enable_dff
    IceLattice_inst
    (.I3(1'b0)
    ,.I2(load_i)
    ,.I1(data_i[0])
    ,.I0(d_i)
    ,.CIN(1'b0)
    ,.CLK(clk_i)
    ,.CEN(en_i || reset_i || load_i)
    ,.SR(reset_i)
    ,.LO(ignore1)
    ,.O(data_o[0])
    ,.COUT(ignore2)
    );  

for(genvar i = 1; i < width_p; i++) begin
  ICESTORM_LC
    #(.LUT_INIT(16'b0000_0000_1100_1010)
      ,.SET_NORESET(reset_val_p[i])
      ,.DFF_ENABLE(1'b1))//enable_dff
    IceLattice_inst
    (.I3(1'b0)
    ,.I2(load_i)
    ,.I1(data_i[i])
    ,.I0(data_o[i-1])
    ,.CIN(1'b0)
    ,.CLK(clk_i)
    ,.CEN(en_i || reset_i || load_i)
    ,.SR(reset_i)
    ,.LO(ignore1)
    ,.O(data_o[i])
    ,.COUT(ignore2)
    );  

end
  
endmodule
