module tuner
#(parameter int_in_lp = 2
,parameter frac_in_lp = 10
) 
(input [0:0] clk_i
,input [0:0] reset_i

,input [int_in_lp - 1 : -frac_in_lp] audio_i
,input [0:0] valid_i
,output [0:0] ready_o 

,output [7 : 0] ssd_o
);
   localparam real frequencies[6:0] = {784.0, 700.5, 659.3, 589.4, 524.3, 495.9, 440.0};
   wire [11:0] sin_data [6:0];
   wire [16:-15] mac_data [6:0];
   logic [16:-15] finalData [6:0];
   wire [16:0] sample_count;
   for(genvar i = 0; i < 7; i++)begin
      sinusoid
      #(.width_p(12)
       ,.note_freq_p(frequencies[i])) 
      sin_A
      (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.data_o(sin_data[i])
      ,.ready_i(valid_i));
 
      mac
      #(.int_in_lp(2)
         ,.frac_in_lp(10)
         ,.int_out_lp(17)
         ,.frac_out_lp(15))
      multiplyAcc
      (.clk_i(clk_i)
      ,.reset_i(reset_i || sample_count == 17'd65536)
      ,.a_i(audio_i)  //line_in data
      ,.b_i(sin_data[i]) //sin data
      ,.valid_i(valid_i)
      //,.ready_o(ready_o)
      //,.valid_o(valid_o)
      ,.data_o(mac_data[i])
      ,.ready_i(1'b1)
      );
         
      always_ff @(posedge clk_i)begin //dffs to store the value at 65535 samples
         if(reset_i) begin
            finalData[i] <= '0;
         end else if(sample_count == 17'd65535) begin
            if(mac_data[i][16] == 1'b1) //ensures abs val
               finalData[i] <= -1*mac_data[i];
            else
               finalData[i] <= mac_data[i];
         end
   end
  end
  //comparison tree that makes me want to explode 
   logic [16:-15] max1;
   logic [3:0] out1;
   logic [16:-15] max2;
   logic [3:0] out2;
   logic [16:-15] max3;
   logic [3:0] out3;
   logic [16:-15] max4;
   logic [3:0] out4;
   logic [16:-15] max5;
   logic [3:0] out5;
   logic [16:-15] max6;
   logic [3:0] out6;
   always_comb begin
      if(finalData[0] > finalData[1])begin
         max1 = finalData[0];
         out1 = 4'hA;
      end else begin
         max1 = finalData[1];
         out1 = 4'hB;
      end
      if(finalData[2] > finalData[3])begin
         max2 = finalData[2];
         out2 = 4'hC;
      end else begin
         max2 = finalData[3];
         out2 = 4'hD;
      end
      if(finalData[4] > finalData[5])begin
         max3 = finalData[4];
         out3 = 4'hE;
      end else begin
         max3 = finalData[5];
         out3 = 4'hF;
      end
   end
   
   always_comb begin
      if(max1 > max2)begin
         max4 = max1;
         out4 = out1;
      end else begin
         max4 = max2;
         out4 = out2;
      end
      if(max3 > finalData[6])begin
         max5 = max3;
         out5 = out3;
      end else begin
         max5 = finalData[6];
         out5 = 4'h6;
      end
   end
  
   always_comb begin
      if(max4 > max5)begin
         max6 = max4;
         out6 = out4;
      end else begin
         max6 = max5;
         out6 = out5;
      end
   end

  //save and restart logic
  counter
  #(.width_p(17)) 
  sample_counter
  (.clk_i(clk_i)
  ,.reset_i(reset_i || sample_count == 17'd65537)
  ,.up_i(valid_i) 
  ,.down_i(1'b0)
  ,.count_o(sample_count)
  );




  //display logic
  wire [6:0] digit_1;
 
  hex2ssd
  #()
  hex2ssd_inst_2
  (.hex_i(out6)
  ,.ssd_o(digit_1)
  );
  assign ssd_o[6:0] = digit_1;
  assign ssd_o[7] = 1'b1; 

   assign ready_o = 1'b1;
endmodule
