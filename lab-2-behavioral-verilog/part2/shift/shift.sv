module shift
  #(parameter width_p = 5
    /* verilator lint_off WIDTHTRUNC */
   ,parameter [width_p-1:0] reset_val_p = '0)
   /* verilator lint_on WIDTHTRUNC */   
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] en_i
   ,input [0:0] d_i
   ,input [0:0] load_i
   ,input [width_p-1:0] data_i
   ,output [width_p-1:0] data_o);

    logic [width_p-1:0] out;
   always_ff @(posedge clk_i) begin
    if(reset_i) begin
      out <= reset_val_p;
    end else if(load_i) begin
      out <= data_i;
    end else if(en_i) begin
      out <= {out[width_p-2:0], d_i}; //referenced this site: https://www.chipverify.com/verilog/verilog-n-bit-shift-register
    end 
   end 
   assign data_o = out;
  

endmodule
