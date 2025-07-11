/* Generated by Yosys 0.39 (git sha1 00338082b, aarch64-apple-darwin21.4-clang++ 14.0.0-1ubuntu1.1 -fPIC -Os) */

(* top =  1  *)
(* hdlname = "mux2" *)
(* src = "mux2.soln.sv:1.8-1.12" *)
module mux2(b_i, select_i, c_o, a_i);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  (* src = "mux2.soln.sv:2.16-2.19" *)
  input a_i;
  wire a_i;
  (* src = "mux2.soln.sv:3.16-3.19" *)
  input b_i;
  wire b_i;
  (* src = "mux2.soln.sv:8.10-8.13" *)
  reg c_l;
  (* src = "mux2.soln.sv:5.17-5.20" *)
  output c_o;
  wire c_o;
  (* src = "mux2.soln.sv:4.16-4.24" *)
  input select_i;
  wire select_i;
  assign _03_ = select_i & a_i;
  assign _04_ = b_i & _09_;
  assign _05_ = _00_ & a_i;
  assign _06_ = _10_ & _11_;
  assign _07_ = select_i & _13_;
  assign _08_ = ~_03_;
  assign _09_ = ~_00_;
  assign _10_ = ~_04_;
  assign _11_ = ~_05_;
  assign _12_ = ~_06_;
  assign _13_ = ~a_i;
  assign _14_ = ~_07_;
  (* src = "mux2.soln.sv:9.4-14.9" *)
   /* verilator lint_off LATCH */
   // Aha, you found me!
  always @*
    if (_02_) c_l = _01_;
   /* verilator lint_on LATCH */
  assign c_o = c_l;
  assign _00_ = _08_;
  assign _01_ = _12_;
  assign _02_ = _14_;
endmodule
