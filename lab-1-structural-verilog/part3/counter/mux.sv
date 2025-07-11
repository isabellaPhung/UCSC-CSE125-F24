module mux
  #(parameter width_p = 4)
  (input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,input [0:0] select_i
  ,output [width_p - 1:0] c_o);

genvar i;
generate
for (i = 0; i < width_p; i++) begin: gen_muxLoop
    mux2
    #()
    mux2_inst
    (.a_i(a_i[i])
    ,.b_i(b_i[i])
    ,.select_i(select_i)
    ,.c_o(c_o[i]) 
    );
end
endgenerate
endmodule
