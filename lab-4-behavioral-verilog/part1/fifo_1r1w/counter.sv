//Mealy counter
module counter
  #(parameter width_p = 4,
    parameter [width_p-1:0] reset_val_p = '0)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] mealy_count
   ,output [width_p-1:0] moore_count);

   // Your code here:
   logic [width_p-1:0] count;
   logic [width_p-1:0] out;

    always_comb begin
        if(reset_i)
            out = reset_val_p;
        else if(up_i && !down_i)
            out  = count+ 1;
        else if (down_i && !up_i)
            out = count -1;
        else
            out = count;
    end

   always_ff @(posedge clk_i) begin
        if(reset_i)
            count <= reset_val_p;
        else if(up_i && !down_i)
            count <= count + 1;
        else if (down_i && !up_i)
            count <= count - 1;
   end 
   assign mealy_count = out;
   assign moore_count = count;
       
endmodule
