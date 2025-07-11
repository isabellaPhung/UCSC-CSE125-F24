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

  logic [0:0] reset_test;
  logic [0:0] rd_valid_i;
  logic [8:0] rd_addr_i;
  logic [7:0] data_o;
  logic [7:0] data_expected;
  logic [7:0] data_i;
  logic [0:0] wr_valid_i;
  logic [8:0] wr_addr_i;

   ram_1w1r_sync
     #(/* 
        These were the declared parameters before synthesis/obfuscation:
        parameter [31:0] width_p = 8
        parameter [31:0] depth_p = 512 */
       )
   dut
     (.rd_valid_i(rd_valid_i)
    ,.rd_addr_i(rd_addr_i)
    ,.rd_data_o(data_o)
    ,.clk_i(clk_i)
    ,.reset_i(reset_i || reset_test)
    ,.wr_valid_i(wr_valid_i)
    ,.wr_data_i(data_i)
    ,.wr_addr_i(wr_addr_i)
     );
  
  tester_ram_1w1r_sync
  #(.width_p(8)
   ,.depth_p(512))
  mem
  (.rd_valid_i(rd_valid_i)
  ,.rd_addr_i(rd_addr_i)
  ,.rd_data_o(data_expected)
  ,.clk_i(clk_i)
  ,.reset_i(reset_i || reset_test)
  ,.wr_valid_i(wr_valid_i)
  ,.wr_data_i(data_i)
  ,.wr_addr_i(wr_addr_i)
  );
 
   //checker
   always_ff@(posedge clk_i) begin
    //$display("expected: %b actual: %b", data_expected, data_o);
    if(data_expected != data_o)begin
      error = 1'b1;
    end
   end
  
   initial begin
      // Call this to set pass_o and error_o to 0.
      `START_TESTBENCH

      // Put your testbench code here. Print all of the test cases and
      // their correctness.
      @(negedge reset_i)
      reset_test = 1'b0;
      rd_valid_i = 1'b0;
      wr_valid_i = 1'b0;
      rd_addr_i = 1'b0;
      wr_addr_i = 1'b0;
      error = 0;
      #100;
      @(negedge clk_i) //check wr_valid_i
      wr_valid_i = 1'b0;
      wr_addr_i = 5'd1;
      data_i = 32'd2;
      @(negedge clk_i) //insert 1st element
      wr_valid_i = 1'b1;
      wr_addr_i = 5'd1;
      data_i = 32'd2;
      @(negedge clk_i) //2nd element
      wr_addr_i = 5'd2;
      data_i = 32'd3;
      @(negedge clk_i) //3rd element
      wr_addr_i = 5'd3;
      data_i = 32'd7;
      @(negedge clk_i) //replace 1st element
      wr_addr_i = 5'd1;
      data_i = 32'd10;
      @(negedge clk_i) //stop writing
      wr_valid_i = 1'b0;
      wr_addr_i = 5'd0;
      data_i = 32'd0;
      @(negedge clk_i) //check rd_valid_i
      rd_valid_i = 1'b0;
      rd_addr_i = 5'd1;
      @(negedge clk_i) //read 1st element
      rd_valid_i = 1'b1;
      rd_addr_i = 5'd1;
      @(negedge clk_i) //read 2nd element
      rd_addr_i = 5'd2;
      @(negedge clk_i) //read 3rd element
      rd_addr_i = 5'd3;
      @(negedge clk_i) //set back to 0
      rd_valid_i = 1'b0;
      rd_addr_i = 5'd0;

      //testing write priority
      @(negedge clk_i) //write and read 2nd element at same time
      wr_valid_i = 1'b1;
      wr_addr_i = 5'd2;
      data_i = 8'hFF;
      rd_valid_i = 1'b1;
      rd_addr_i = 5'd2;
      @(negedge clk_i) //write and read 1st element at same time
      wr_valid_i = 1'b1;
      wr_addr_i = 5'd1;
      data_i = 8'd1;
      rd_valid_i = 1'b1;
      rd_addr_i = 5'd1;
      @(negedge clk_i) //set everything back to 0
      wr_valid_i = 1'b0;
      wr_addr_i = 5'd0;
      data_i = 8'h0;
      rd_valid_i = 1'b0;
      rd_addr_i = 5'd0;

      @(negedge clk_i) //reset test
      reset_test = 1'b1;
      @(negedge clk_i) 
      reset_test = 1'b0;

      @(negedge clk_i) //read 1st element
      rd_valid_i = 1'b1;
      rd_addr_i = 5'd1;
      @(negedge clk_i) //read 2nd element
      rd_addr_i = 5'd2;
      @(negedge clk_i) //read 3rd element
      rd_addr_i = 5'd3;
      @(negedge clk_i) //set back to 0
      rd_valid_i = 1'b0;
      rd_addr_i = 5'd0;
      #10;
    
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
