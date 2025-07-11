module bin2gray
  #(parameter width_p = 5)
  (input [width_p - 1 : 0] bin_i
  ,output [width_p - 1 : 0] gray_o);

   // Your code here
  logic [width_p - 1:0] temp;
  always_comb begin
    temp[width_p-1] = bin_i[width_p-1];
    for(int i = 0; i < width_p-1; i++) begin
      if(bin_i[i+1] == 1'b1) begin
        temp[i] = 1'b1-bin_i[i]; 
      end else begin
        temp[i] = bin_i[i]; 
      end
    end
  end
  assign gray_o = temp;

endmodule
