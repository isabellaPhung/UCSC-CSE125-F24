module max2
#(parameter width_p = 12)
(input [width_p-1:0] a
,input [width_p-1:0] b
,output [width_p-1:0] out
,output [0:0] AOrB) //0 if A, 1 if B
logic [width_p-1:0] output;
logic [0:0] aorb;
always_comb begin
    if(a > b) begin
        out = a;
        aorb = 1'b0;
    end else begin
        out = b;
        aorb = 1'b1;
    end
end
assign out = output;
assign AOrB = aorb;
endmodule