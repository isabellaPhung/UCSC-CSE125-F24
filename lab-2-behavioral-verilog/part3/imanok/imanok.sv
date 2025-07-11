module imanok
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] unup_i
   ,input [0:0] down_i
   ,input [0:0] undown_i
   ,input [0:0] left_i
   ,input [0:0] unleft_i
   ,input [0:0] right_i
   ,input [0:0] unright_i
   ,input [0:0] b_i
   ,input [0:0] unb_i
   ,input [0:0] a_i
   ,input [0:0] una_i
   ,input [0:0] start_i
   ,input [0:0] unstart_i
   ,output [4:0] currentstate
   ,output [0:0] cheat_code_unlocked_o);

typedef enum logic [4:0]{
    INIT = 5'd1, 
    Sp = 5'd2, 
    Sr = 5'd3,
    Ap = 5'd4, 
    Ar = 5'd5,
    Bp = 5'd6, 
    Br = 5'd7,
    R1p = 5'd8, 
    R1r = 5'd9,
    L1p = 5'd10, 
    L1r = 5'd11,
    R2p = 5'd12, 
    R2r = 5'd13,
    L2p = 5'd14, 
    L2r = 5'd15,
    D1p = 5'd16, 
    D1r = 5'd17,
    D2p = 5'd18, 
    D2r = 5'd19,
    U1p = 5'd20, 
    U1r = 5'd21,
    U2p = 5'd22, 
    U2r = 5'd23
  }State;
  State currstate;
  State nextstate;
  
logic [0:0] out;
//wire [13:0] inputcomb = {up_i, unup_i, down_i, undown_i, right_i, unright_i, left_i, unleft_i, a_i, una_i, b_i, unb_i, start_i, unstart_i};
logic [0:0] inputcomb;

always_comb begin
    inputcomb = |{up_i, unup_i, down_i, undown_i, right_i, unright_i, left_i, unleft_i, a_i, una_i, b_i, unb_i, start_i, unstart_i};


    nextstate = INIT; //default state
    out = 1'b0;
    case (currstate)
    INIT: begin
      if(start_i == 1'b1)
         nextstate = Sp;
    end
    Sp: begin
      if(start_i == 1'b1 || !(inputcomb))
         nextstate = Sp;
      else if(unstart_i == 1'b1)
         nextstate = Sr;
    end
    Sr: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(a_i == 1'b1)
         nextstate = Ap;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    Ap: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(una_i == 1'b1)
         nextstate = Ar;
      else if(!(inputcomb))
         nextstate = currstate;
   end
    Ar: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(b_i == 1'b1)
         nextstate = Bp;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    Bp: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unb_i == 1'b1)
         nextstate = Br;
      else if(!(inputcomb))
         nextstate = currstate;
  end
    Br: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(right_i == 1'b1)
         nextstate = R1p;
      else if(!(inputcomb))
         nextstate = currstate;
   end
    R1p: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unright_i == 1'b1)
         nextstate = R1r;
      else if(!(inputcomb))
         nextstate = currstate;
  end
    R1r: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(left_i == 1'b1)
         nextstate = L1p;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    L1p: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unleft_i == 1'b1)
         nextstate = L1r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    L1r: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(right_i == 1'b1)
         nextstate = R2p;
      else if(!(inputcomb))
         nextstate = currstate;
   end
    R2p: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unright_i == 1'b1)
         nextstate = R2r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    R2r: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(left_i == 1'b1)
         nextstate = L2p;
      else if(!(inputcomb))
         nextstate = currstate;
   end
    L2p: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unleft_i == 1'b1)
         nextstate = L2r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    L2r: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(down_i == 1'b1)
         nextstate = D1p;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    D1p: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(undown_i == 1'b1)
         nextstate = D1r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    D1r: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(down_i == 1'b1)
         nextstate = D2p;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    D2p: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(undown_i == 1'b1)
         nextstate = D2r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    D2r: begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(up_i == 1'b1)
         nextstate = U1p;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    U1p:  begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unup_i == 1'b1)
         nextstate = U1r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    U1r:  begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(up_i == 1'b1)
         nextstate = U2p;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    U2p:  begin
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(unup_i == 1'b1)
         nextstate = U2r;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    U2r:  begin
      out = 1'b1;
      if(start_i == 1'b1)
         nextstate = Sp;
      else if(!(inputcomb))
         nextstate = currstate;
    end
    default:
      nextstate = INIT;
    endcase
end

always_ff @(posedge clk_i) begin
   if(reset_i)
   currstate <= INIT;
   else
   currstate <= nextstate;
end
assign currentstate = currstate;
assign cheat_code_unlocked_o = out;
endmodule

