/* Generated by Yosys 0.29 (git sha1 9c5a60eb201, clang 14.0.3 -fPIC -Os) */

(* hdlname = "\\hex2ssd" *)
(* top =  1  *)
(* src = "hex2ssd.sv:1.1-31.10" *)
module hex2ssd(hex_i, ssd_o);
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
  wire _15_;
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire _21_;
  wire _22_;
  (* src = "hex2ssd.sv:6.16-6.22" *)
  wire [6:0] case_l;
  (* src = "hex2ssd.sv:2.16-2.21" *)
  input [3:0] hex_i;
  wire [3:0] hex_i;
  (* src = "hex2ssd.sv:3.17-3.22" *)
  output [6:0] ssd_o;
  wire [6:0] ssd_o;
  assign _00_ = ~hex_i[2];
  assign _01_ = hex_i[0] & ~(hex_i[1]);
  assign _02_ = ~(hex_i[1] | hex_i[0]);
  assign _03_ = hex_i[2] ? _02_ : _01_;
  assign _04_ = hex_i[1] & hex_i[0];
  assign _05_ = hex_i[2] ? _01_ : _04_;
  assign ssd_o[0] = hex_i[3] ? _05_ : _03_;
  assign _06_ = hex_i[1] ^ hex_i[0];
  assign _07_ = _06_ & ~(_00_);
  assign _08_ = hex_i[0] ? hex_i[1] : hex_i[2];
  assign ssd_o[1] = hex_i[3] ? _08_ : _07_;
  assign _09_ = hex_i[2] & ~(_01_);
  assign _10_ = hex_i[0] | ~(hex_i[1]);
  assign _11_ = _00_ & ~(_10_);
  assign ssd_o[2] = hex_i[3] ? _09_ : _11_;
  assign _12_ = ~(hex_i[1] ^ hex_i[0]);
  assign _13_ = hex_i[2] ? _12_ : _01_;
  assign _14_ = hex_i[2] ? _04_ : _06_;
  assign ssd_o[3] = hex_i[3] ? _14_ : _13_;
  assign _15_ = hex_i[1] | ~(hex_i[0]);
  assign _16_ = _00_ & ~(_15_);
  assign _17_ = hex_i[2] ? _10_ : hex_i[0];
  assign ssd_o[4] = hex_i[3] ? _16_ : _17_;
  assign _18_ = hex_i[2] & ~(_15_);
  assign _19_ = hex_i[1] | hex_i[0];
  assign _20_ = hex_i[2] ? _04_ : _19_;
  assign ssd_o[5] = hex_i[3] ? _18_ : _20_;
  assign _21_ = _02_ & ~(_00_);
  assign _22_ = ~(hex_i[1] | hex_i[2]);
  assign ssd_o[6] = hex_i[3] ? _21_ : _22_;
  assign case_l = ssd_o;
endmodule
