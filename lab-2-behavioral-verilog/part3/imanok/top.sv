// Top-level design file for the icebreaker FPGA board
module top
  (input [0:0] clk_12mhz_i
  ,input [0:0] reset_n_async_unsafe_i
   // n: Negative Polarity (0 when pressed, 1 otherwise)
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
  ,input [3:1] button_async_unsafe_i
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
   // SPI Interface (Renamed via: https://www.oshwa.org/a-resolution-to-redefine-spi-signal-names/)
  ,output [0:0] spi_cs_o
  ,output [0:0] spi_sd_o
  ,input [0:0] spi_sd_i
  ,output [0:0] spi_sck_o
  ,output [5:1] led_o);

   // For this demonstration, instantiate your Konami Code State
   // Machine to recognize input from the PMOD JSTK.
   //
   //    https://en.wikipedia.org/wiki/Konami_Code
   //
   // The sequence is: UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT B A START
   //
   // Use Button 3 (button_r[3]) for Button B
   // Use Button 2 (button_r[2]) for Button Start
   // Use Button 1 (button_r[1]) for Button A

   wire [39:0] data_o;
   wire [39:0] data_i;
   wire [9:0]  position_x;
   wire [9:0]  position_y;

   wire [23:0] color_rgb;
   
   // These two D Flip Flops form what is known as a Synchronizer. We
   // will learn about these in Week 5, but you can see more here:
   // https://inst.eecs.berkeley.edu/~cs150/sp12/agenda/lec/lec16-synch.pdf
   wire [0:0] reset_n_sync_r;
   wire [0:0] reset_sync_r;
   wire [0:0] reset_r; // Use this as your reset_signal

   wire [3:1] button_sync_r;
   wire [3:1] button_r;

   dff
     #()
   sync_a
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.en_i(1'b1)
     ,.d_i(reset_n_async_unsafe_i)
     ,.q_o(reset_n_sync_r));

   inv
     #()
   inv
     (.a_i(reset_n_sync_r)
     ,.b_o(reset_sync_r));

   dff
     #()
   sync_b
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.en_i(1'b1)
     ,.d_i(reset_sync_r)
     ,.q_o(reset_r));
       
   generate
     for(genvar idx = 1; idx <= 3; idx++) begin
         dff
           #()
         sync_a
           (.clk_i(clk_12mhz_i)
           ,.reset_i(1'b0)
           ,.en_i(1'b1)
           ,.d_i(button_async_unsafe_i[idx])
           ,.q_o(button_sync_r[idx]));

         dff
           #()
         sync_b
           (.clk_i(clk_12mhz_i)
           ,.reset_i(1'b0)
           ,.en_i(1'b1)
           ,.d_i(button_sync_r[idx])
           ,.q_o(button_r[idx]));
     end
   endgenerate

   PmodJSTK
     #()
   jstk_i
     (.clk_12mhz_i(clk_12mhz_i)
     ,.reset_i(reset_r)
     ,.data_i(data_i)
     ,.spi_sd_i(spi_sd_i)
     ,.spi_cs_o(spi_cs_o)
     ,.spi_sck_o(spi_sck_o)
     ,.spi_sd_o(spi_sd_o)
     ,.data_o(data_o));

   // data_o is Data Recieved from the PmodJSTK
   // Byte 1: Low byte X Coordinate
   // Byte 2: High byte X Coordinate
   // Byte 3: Low byte Y Coordinate
   // Byte 4: High byte Y Coordinate
   // Byte 5: High six bytes are ignored, then trigger, joystick
   assign position_y = {data_o[25:24], data_o[39:32]};
   assign position_x = {data_o[9:8], data_o[23:16]};

  /*
   assign led_o[4] = position_x < 384 | button_r[1];
   assign led_o[5] = position_x > 640 | button_r[2];
   assign led_o[3] = position_y < 384 | button_r[3];
   assign led_o[2] = position_y > 640;
   */

   wire [0:0] A;
   wire [0:0] unA;
   wire [0:0] B;
   wire [0:0] unB;
   wire [0:0] start;
   wire [0:0] unstart;
   
   detect_edge
   #()
   detect_edge_A
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(button_r[1])
   ,.button_o(A)
   ,.unbutton_o(unA)
   );

   detect_edge
   #()
   detect_edge_B
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(button_r[3])
   ,.button_o(B)
   ,.unbutton_o(unB)
   );
  
   detect_edge
   #()
   detect_edge_start
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(button_r[2])
   ,.button_o(start)
   ,.unbutton_o(unstart)
   );
  
   wire [0:0] right;
   wire [0:0] unright;
   wire [0:0] left;
   wire [0:0] unleft;
   wire [0:0] up;
   wire [0:0] unup;
   wire [0:0] down;
   wire [0:0] undown;

   detect_edge
   #()
   detect_edge_right
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(position_y > 640)
   ,.button_o(right)
   ,.unbutton_o(unright)
   );

  detect_edge
   #()
   detect_edge_left
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(position_y < 384)
   ,.button_o(left)
   ,.unbutton_o(unleft)
   );
   
   detect_edge
   #()
   detect_edge_up
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(position_x > 640)
   ,.button_o(up)
   ,.unbutton_o(unup)
   );
   
   detect_edge
   #()
   detect_edge_down
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.button_i(position_x < 384)
   ,.button_o(down)
   ,.unbutton_o(undown)
   );

  /*
   assign led_o[4] = position_x < 384 | button_r[1];
   assign led_o[5] = position_x > 640 | button_r[2];
   assign led_o[3] = position_y < 384 | button_r[3];
   assign led_o[2] = position_y > 640; 
  */
   wire [0:0] done;
   imanok
   #()
   imanok_inst
   (.clk_i(clk_12mhz_i)
   ,.reset_i(reset_r)
   ,.up_i(up)
   ,.unup_i(unup)
   ,.down_i(down)
   ,.undown_i(undown)
   ,.left_i(left)
   ,.unleft_i(unleft)
   ,.right_i(right)
   ,.unright_i(unright)
   ,.b_i(B)
   ,.unb_i(unB)
   ,.a_i(A)
   ,.una_i(unA)
   ,.start_i(start)
   ,.unstart_i(unstart)
   ,.currentstate(led_o)
   ,.cheat_code_unlocked_o(done)
   );

   // data_i to be sent to PmodJSTK.
   // Byte 1: Control Command for RGB on PmodJSTK
   // Byte 2: Red
   // Byte 3: Green
   // Byte 4: Blue
   // Byte 5: Ignored
   assign data_i = {8'b10000100, color_rgb, 8'b00000000};

   // Red
   assign color_rgb[23:16] = {8{done}};
   //assign color_rgb[23:16] = {8{start}};
   // Green
   assign color_rgb[15:8] = 8'h00;
   // Blue
   assign color_rgb[7:0] = 8'h00;

endmodule
