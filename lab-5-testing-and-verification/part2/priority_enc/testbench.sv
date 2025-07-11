`timescale 1ns/1ps

`define START_TESTBENCH error_o = 0; pass_o = 0; #10;
`define FINISH_WITH_FAIL error_o = 1; pass_o = 0; #10; $finish();
`define FINISH_WITH_PASS pass_o = 1; error_o = 0; #10; $finish();
module testbench
  // Python will set this for you
  #(parameter width_p = 8)
  // You don't usually have ports in a testbench, but we need these to
  // signal to cocotb/gradescope that the testbench has passed, or failed.
  (output logic error_o = 1'bx
  ,output logic pass_o = 1'bx);
  
  logic [width_p-1:0] vec_i;
  logic [$clog2(width_p)-1:0] enc_o;

   // You can use this 
   logic [0:0] error;

   // Write your assertions inside of the DUT modules themselves.
   priority_enc
     #(/* Don't use width_p here*/)
   dut
     (.enc_o(enc_o)
     ,.vec_i(vec_i)
     );
   logic [width_p:0] i;

  
   logic [$clog2(width_p)-1:0] enc_expected;
   always_comb begin
    enc_expected = ($clog2(vec_i)); //credits to: https://stackoverflow.com/questions/21212340/convert-one-hot-encoding-to-plain-binary
   end
   

   initial begin
      // Call this to set pass_o and error_o to 0.
      `START_TESTBENCH

      // Put your testbench code here. Print all of the test cases and
      // their correctness.
      error = 1'b0;
      for(i = 1; i < (1<<(width_p)); i=i<<1)begin
        vec_i = i[width_p-1:0];
        #10;
        $display("vec_i: %0b", vec_i);
        $display("given: %0b expected: %0b", enc_o, enc_expected);
        if(enc_o !== enc_expected) begin
          error = 1'b1;
        end
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
