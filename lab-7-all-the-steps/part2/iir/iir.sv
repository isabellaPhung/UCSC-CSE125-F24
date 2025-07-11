module iir
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 10
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [0:0] valid_i
  ,input [width_p - 1:0] data_i
  ,output [0:0] ready_o

  ,output [0:0] valid_o
  ,output [width_p - 1:0] data_o
  ,input [0:0] ready_i
  );

   wire [(2*width_p)-1:-12] data_lo; 
   wire [width_p-1:-6] data_li;
  
   assign data_li = {data_i, {6{1'b0}}};
   
   wire [width_p-1:-6] sub = (data_li - data_lo[width_p-1:-6]);

   wire [width_p-1:-6] b = {{width_p{1'b0}}, 6'b111011};
   wire [(2*width_p)-1:-12] mul = $signed(sub) * $signed(b);

   wire [(2*width_p):-12] acc = data_lo + mul;

   assign data_o = data_lo[width_p-1:0];

   elastic
     #(.width_p(33))
   elastic_inst
     (.clk_i                            (clk_i)
     ,.reset_i                          (reset_i)

     ,.data_i                           (acc)
     ,.valid_i                          (valid_i)
     ,.ready_o                          (ready_o)

     ,.valid_o                          (valid_o)
     ,.data_o                           (data_lo)
     ,.ready_i                          (ready_i));

endmodule
