module gray2bin
  #(parameter width_p = 5)
   (input [width_p - 1 : 0] gray_i
    ,output [width_p - 1 : 0] bin_o);

  logic [width_p-1:0] temp;
  logic [0:0] a;
  always_comb begin
    temp[width_p-1] = gray_i[width_p-1];
    a = gray_i[width_p-1]; 
    for(int i = width_p-2; i >= 0; i--) begin
      a ^= gray_i[i];
      temp[i] = a;
    end
  end
  assign bin_o = temp;

endmodule
