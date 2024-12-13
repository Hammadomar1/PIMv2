`timescale 1ns / 1ns
// Import SystemVerilog utilities for randomization
import "DPI-C" context task randomize();

module SoC_tb;

  // Testbench signals
  logic clk;
  logic rstN;
  logic busy;
  logic [31:0] GPIO;
  int seed;

  logic [63:0] busy_count = 64'd0;
  logic [63:0] cycles_count = 64'd0;
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
  end

  // uut instance
  SoC uut (
    .clk(clk),
    .rstN(rstN),
    .busy(busy),
    .GPIO(GPIO)
  );

  // Busy generation variables
  integer busy_probability = 30; // Set busy probability: 10%, 20%, or 30%
  integer rand_number;
  integer rand_probability;

  // Randomization task
  task generate_busy;
    output logic busy_out;
    output integer rand_num_out;
    begin
      // Generate a random probability number between 0-99
      rand_probability = $urandom_range(0, 99);

      // Determine if `busy` is high based on probability
      if (rand_probability < busy_probability) begin
        busy_out = 1'b1;
        busy_count = busy_count + 64'd1;

        // Generate a constrained random number between 10 and 100 (example range)
        rand_num_out = $urandom_range(5, 10);
        //$display("Busy HIGH: Random number generated = %d at time %t", rand_num_out, $time);
      end else begin
        busy_out = 1'b0;
        rand_num_out = $urandom_range(5, 10);
        //$display("Busy LOW at time %t", $time);
      end
    end
  endtask

always @(posedge clk) cycles_count <= cycles_count + 64'd1;


  // Testbench initialization
  initial begin

  
    // Set a unique random seed
 // Seed handling
    if ($value$plusargs("seed=%d", seed)) begin
      $urandom(seed); // Use the provided seed
      $display("Using provided seed: %0d", seed);
    end else begin
      seed = $urandom(); // Generate a random seed
      $urandom(seed);    // Use the generated seed
      $display("Using generated seed: %0d", seed);
    end

    // Reset
    rstN = 0;
    busy = 0;
    #20 
    rstN = 1;
    // repeat(50) begin
    //   @(posedge clk);
    //   busy = 1'b0;
    // end
    // Run simulation for 1000 cycles
    #200;
    repeat(2000) begin
        @(posedge clk);
        // Call the task to generate the `busy` signal and random number
        generate_busy(busy, rand_number);

        // If busy is high, hold it for rand_number clock cycles
        
        repeat(rand_number) @(posedge clk); // Wait for rand_number clock cycles
          //busy = 1'b0; // Deassert busy after the delay
        // $display("Busy LOW after holding for %d cycles at time %t", rand_number, $time);
    end
        $stop;

  end

endmodule
