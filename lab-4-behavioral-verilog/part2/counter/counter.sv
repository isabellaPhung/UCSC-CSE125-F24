module counter
  #(parameter [31:0] max_val_p = 15
   ,parameter width_p = $clog2(max_val_p) 
    /* verilator lint_off WIDTHTRUNC */
   ,parameter [width_p-1:0] reset_val_p = '0
    )
    /* verilator lint_on WIDTHTRUNC */
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   localparam [width_p-1:0] max_val_lp = max_val_p[width_p-1:0];

   // Your code here:
   logic [width_p-1:0] count;
   always_ff @(posedge clk_i) begin
    if(reset_i) begin
      count <= reset_val_p;
    end else if(up_i && !down_i)begin
      if(count == max_val_lp)
        count <= '0;
      else
        count<=count+1;
    end else if (down_i && !up_i) begin
      if(count == '0)
        count <= max_val_lp;
      else
        count<=count-1;
    end
   end 
   assign count_o = count;
       
endmodule
