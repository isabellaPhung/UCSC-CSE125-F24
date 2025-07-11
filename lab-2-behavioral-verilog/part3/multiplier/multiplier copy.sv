module multiplier
  #(parameter width_p = 4)
   (input [0:0] clk_i
   ,input [0:0] reset_i
    // Input Interface
   ,input [0:0] valid_i
   ,output [0:0] ready_o
   ,input [width_p - 1 : 0] a_i
   ,input [width_p - 1 : 0] b_i

   // Output Interface
   ,output [0 : 0] valid_o
   ,input [0 : 0] ready_i
   ,output [(2 * width_p) - 1 : 0] result_o);

  typedef enum logic [1:0]{
    INIT = 2'b00, 
    COMPUTE = 2'b01, 
    DONE = 2'b10
  }State;
  State currstate;
  State nextstate;

  logic [width_p - 1:0] a;
  logic [width_p - 1:0] b;
  logic [2*width_p - 1:0] tempResult;
  logic [0:0] valid_o_l;
  logic [0:0] ready_o_l;
  assign valid_o = valid_o_l;
  assign ready_o = ready_o_l;

  always_comb begin
    
    nextstate = INIT;
    case (currstate)
      INIT: begin //init state
        valid_o_l = 1'b0;
        ready_o_l = 1'b1;
        if (valid_i == 1'b1)begin
          nextstate = COMPUTE;
        end else begin
          nextstate = INIT;
        end
        
      end
      COMPUTE: begin //compute state
        valid_o_l = 1'b0;
        ready_o_l = 1'b0;
        if(nextA[0] == 1'b1) begin
          tempResult += {{width_p{1'b0}}, nextB};
        end
        b = b << 1;
        a = a >> 1;
        if(nextA == {width_p{1'b0}})begin
          valid_o_l = 1'b1;
          nextstate = DONE;
        end else begin
          nextstate = COMPUTE;
        end
      end
      DONE:
        if(ready_i == 1'b1)begin
          valid_o_l = 1'b0;
          nextstate = INIT;
        end else begin
          nextstate = DONE;
        end
      default: nextstate = INIT;
    endcase
   end

  always_ff @(posedge clk_i) begin
    if(reset_i)
      currstate <= INIT;
    else
      currstate <= nextstate;
  end 

  assign result_o = tempResult;
endmodule
