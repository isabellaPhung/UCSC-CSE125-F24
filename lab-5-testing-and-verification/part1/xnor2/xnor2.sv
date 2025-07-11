/* Generated by Yosys 0.39 (git sha1 00338082b, aarch64-apple-darwin21.4-clang++ 14.0.0-1ubuntu1.1 -fPIC -Os) */

(* hdlname = "xnor2" *)
(* src = "xnor2.soln.sv:1.8-1.13" *)
module xnor2(b_i, c_o, a_i);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  (* src = "xnor2.soln.sv:2.16-2.19" *)
  input a_i;
  wire a_i;
  (* src = "xnor2.soln.sv:3.16-3.19" *)
  input b_i;
  wire b_i;
  (* src = "xnor2.soln.sv:4.17-4.20" *)
  output c_o;
  wire c_o;
  assign _00_ = b_i & a_i;
  assign _01_ = _03_ & _04_;
  assign _02_ = _05_ & _06_;
  assign _03_ = ~b_i;
  assign _04_ = ~a_i;
  assign _05_ = ~_00_;
  assign _06_ = ~_01_;
  assign c_o = _02_;
endmodule
