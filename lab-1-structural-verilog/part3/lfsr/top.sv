module top
  (input [0:0] clk_12mhz_i
  ,input [0:0] reset_n_async_unsafe_i
   // n: Negative Polarity (0 when pressed, 1 otherwise)
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
  ,input [3:1] button_async_unsafe_i
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
  ,output [7:0] ssd_o
  ,output [5:1] led_o);

   // For this demonstration, instantiate your Counter modules to
   // drive the output wires of ssd_o. You may only use structural
   // verilog, the modules in provided_modules, and your lfsr module,
   // and your counter.
   // 
   // Hint: A 12 MHz clock is _very fast_ for human consumption. You
   // should use your counter to slow down your LFSR by generating a
   // new clock. In our solution, about 22 bits is sufficent.

   // These two D Flip Flops form what is known as a Synchronizer. We
   // will learn about these in Week 5, but you can see more here:
   // https://inst.eecs.berkeley.edu/~cs150/sp12/agenda/lec/lec16-synch.pdf
   wire [0:0] reset_n_sync_r;
   wire [0:0] reset_sync_r;
   wire [0:0] reset_r; // Use this as your reset_signal
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
       
  // Your code goes here
  wire [21:0] counter;
  counter
    #(.width_p(5'd22))
    counter_inst
    (.clk_i(clk_12mhz_i)
    ,.reset_i(reset_r)
    ,.up_i(1'b1)
    ,.down_i(1'b0)
    ,.count_o(counter)
    );
  
  wire [8:0] random;
  lfsr
    #()
    lfsr_inst
    (.clk_i(clk_12mhz_i)
    ,.reset_i(reset_r)
    ,.en_i(&counter)
    ,.data_o(random));

  wire [6:0] digit_1;
  wire [6:0] digit_2;
  hex2ssd
    #()
    hex2ssd_inst_1
    (.hex_i(random[3:0])
    ,.ssd_o(digit_1)
    );
  
  hex2ssd
    #()
    hex2ssd_inst_2
    (.hex_i(random[7:4])
    ,.ssd_o(digit_2)
    );

  mux
    #(.width_p(4'd7))
    mux_inst
    (.a_i(digit_1)
    ,.b_i(digit_2)
    ,.select_i(counter[6])
    ,.c_o(ssd_o[6:0])
    );
  
  assign ssd_o[7] = counter[6];

endmodule
