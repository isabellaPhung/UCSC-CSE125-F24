module counter
  #(parameter width_p = 4)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

  wire [0:0] enable;
  //dff enable
  xor2
    #()
  xor_inst_enable
    (.a_i(up_i)
    ,.b_i(down_i)
    ,.c_o(enable)
    );

  wire [width_p-1:0] inArray;

  genvar i;
  generate
  for (i = 0; i < width_p; i++) begin: gen_counterLoop
  dff
      #()
    dff_inst
      (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.d_i(inArray[i])
      ,.en_i(enable)
      ,.q_o(count_o[i])
      );
  end
  endgenerate

  wire [width_p-1:0] addTo;
  mux
      #(.width_p(width_p))
    up_down_mux
      (.a_i({{width_p-1{1'b0}}, 1'b1})
      ,.b_i({width_p{1'b1}})
      ,.select_i(down_i)
      ,.c_o(addTo)
      );
  
  wire [0:0] carryOut;
  adder
    #(.width_p(width_p))
    adder_inst
    (.a_i(count_o)
    ,.b_i(addTo)
    ,.sum_o({carryOut, inArray}) 
    );


endmodule
