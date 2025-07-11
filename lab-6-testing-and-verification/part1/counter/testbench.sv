`timescale 1ns/1ps

`define START_TESTBENCH error_o = 0; pass_o = 0; #10;
`define FINISH_WITH_FAIL error_o = 1; pass_o = 0; #10; $finish();
`define FINISH_WITH_PASS pass_o = 1; error_o = 0; #10; $finish();
module testbench
  // You don't usually have ports in a testbench, but we need these to
  // signal to cocotb/gradescope that the testbench has passed, or failed.
  (output logic error_o = 1'bx
  ,output logic pass_o = 1'bx);

   // You can use this 
   logic [0:0] error;
   
   wire        clk_i;
   wire        reset_i;

   nonsynth_clock_gen
     #(.cycle_time_p(10))
   cg
     (.clk_o(clk_i));

   nonsynth_reset_gen
     #(.reset_cycles_lo_p(1)
      ,.reset_cycles_hi_p(10))
   rg
     (.clk_i(clk_i)
     ,.async_reset_o(reset_i));

   logic [0:0] up_i;
   logic [0:0] down_i;
   logic [3:0] count_o;
   logic [0:0] reset_test; 
   counter
     #()
   counter_i
     (.clk_i(clk_i)
     ,.reset_i(reset_i || reset_test)
     ,.up_i(up_i)
     ,.down_i(down_i)
     ,.count_o(count_o)
     );
 
   logic [31:0] i; 
   //behavioral model
   logic [3:0] counter_expected;
   always_ff@(posedge clk_i) begin
    if(reset_i || reset_test)begin
      counter_expected <= '0;
    end else if (up_i && ~down_i) begin
      counter_expected <= counter_expected + 1;
    end else if (down_i && ~up_i) begin
      counter_expected <= counter_expected - 1;
    end
   end

   //checker
   always_ff@(posedge clk_i or negedge clk_i) begin
    $display("expected: %b actual: %b", counter_expected, count_o);
    if(counter_expected !== count_o)begin
      error = 1'b1;
    end
   end
   
   initial begin
      // Call this to set pass_o and error_o to 0.
      `START_TESTBENCH

      // Put your testbench code here. Print all of the test cases and
      // their correctness.
      @(negedge reset_i)
      up_i = 1'b0;
      down_i = 1'b0;
      error = 0;
      #10;
      @(negedge clk_i)
      for(i = 0; i <100; i++)begin
        up_i = $random;
        down_i = $random;
        reset_test = $random;
        /* 
        up_i = i[2];
        down_i = i[4];
        reset_test = i[3];
        */
        @(negedge clk_i);
      end
      
      if(error)begin
        `FINISH_WITH_FAIL;
      end
      `FINISH_WITH_PASS;

      // Use FINISH_WITH_FAIL to end the testbench and cause the FAIL message, and signal fail to cocotb
      // Use FINISH_WITH_PASS to end the testbench and cause the PASS message, and signal pass to cocotb
      // Calling neither will cause the UNKNOWN message, and cause issues in Cocotb.
   end

   // This block executes after $finish() has been called.
   final begin
      $display("Simulation time is %t", $time);
      if(error_o === 1) begin
	 $display("\033[0;31m    ______                    \033[0m");
	 $display("\033[0;31m   / ____/_____________  _____\033[0m");
	 $display("\033[0;31m  / __/ / ___/ ___/ __ \\/ ___/\033[0m");
	 $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
	 $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
	 $display("Simulation Failed");
     end else if (pass_o === 1) begin
	 $display("\033[0;32m    ____  ___   __________\033[0m");
	 $display("\033[0;32m   / __ \\/   | / ___/ ___/\033[0m");
	 $display("\033[0;32m  / /_/ / /| | \\__ \\\__ \ \033[0m");
	 $display("\033[0;32m / ____/ ___ |___/ /__/ / \033[0m");
	 $display("\033[0;32m/_/   /_/  |_/____/____/  \033[0m");
	 $display();
	 $display("Simulation Succeeded!");
     end else begin
        $display("   __  ___   ____ __ _   ______ _       ___   __");
        $display("  / / / / | / / //_// | / / __ \\ |     / / | / /");
        $display(" / / / /  |/ / ,<  /  |/ / / / / | /| / /  |/ / ");
        $display("/ /_/ / /|  / /| |/ /|  / /_/ /| |/ |/ / /|  /  ");
        $display("\\____/_/ |_/_/ |_/_/ |_/\\____/ |__/|__/_/ |_/   ");
	$display("Please set error_o or pass_o!");
     end
   end

endmodule
