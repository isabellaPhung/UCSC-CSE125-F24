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

    logic [0:0] valid_i;
    logic [0:0] valid_o;
    logic [0:0] valid_expected;
    logic [0:0] ready_i;
    logic [0:0] ready_o;
    logic [0:0] ready_expected;
    logic [31:0] data_i;
    logic [31:0] data_o;
    logic [31:0] data_expected;

   fifo_1r1w
     #(/* Parameters chosen before synthesis/obfuscation  
       parameter [31:0] width_p = 32
       // Note: Not depth_p! depth_p should be 1<<depth_log2_p
      ,parameter [31:0] depth_log2_p = 3*/)
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.data_i(data_i)
     ,.valid_i(valid_i)
     ,.ready_o(ready_o)
     ,.valid_o(valid_o)
     ,.ready_i(ready_i)
     ,.data_o(data_o));

    tester_fifo_1r1w
    #(.width_p(32)
     ,.depth_log2_p(8))
    model
    (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.data_i(data_i)
     ,.valid_i(valid_i)
     ,.ready_o(ready_expected)
     ,.valid_o(valid_expected)
     ,.ready_i(ready_i)
     ,.data_o(data_expected));

   //checker
   always_ff@(posedge clk_i) begin
    //$display("expected: %b actual: %b", data_expected, data_o);
    if(data_expected != data_o || ready_o != ready_expected || valid_o != valid_expected)begin
      error = 1'b1;
    end
   end
   int i;
   initial begin
      // Call this to set pass_o and error_o to 0.
      `START_TESTBENCH

      // Put your testbench code here. Print all of the test cases and
      // their correctness.

      @(negedge reset_i)
      valid_i = 1'b0;
      ready_i = 1'b0;
      error = 0;
      #100;
      
      for(i = 0; i < 10'd256; i++)begin
        @(negedge clk_i) //first element
        valid_i = 1'b1;
        data_i = i;
      end
      
      @(negedge clk_i)
      valid_i = 1'b0;
      data_i = 32'd0;
      
      for(i = 0; i < 10'd256; i++)begin
      @(negedge clk_i) //take out 1st element
      ready_i = 1'b1;
      @(negedge clk_i)
      ready_i = 1'b0;
      end
      /*
      @(negedge clk_i) //first element
      valid_i = 1'b1;
      data_i = i;
      @(negedge clk_i) //2nd element
      data_i = 32'd3;
      @(negedge clk_i) //3rd element
      data_i = 32'd7;
      @(negedge clk_i)
      valid_i = 1'b0;
      data_i = 32'd0;
      @(negedge clk_i) //take out 1st element
      ready_i = 1'b1;
      @(negedge clk_i)
      ready_i = 1'b0;
      @(negedge clk_i) //take out 2nd element
      ready_i = 1'b1;
      @(negedge clk_i)
      ready_i = 1'b0;
      @(negedge clk_i) //take out 3rd element
      ready_i = 1'b1;
      @(negedge clk_i)
      ready_i = 1'b0;
      #10;
      */
      
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
