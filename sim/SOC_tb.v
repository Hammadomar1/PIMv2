`timescale 1ns / 1ps

module SOC_tb;
    // Clock and reset
    reg clk = 1;
    reg reset = 1;
    wire [31:0] IO;
    // FemtoRV32 interface signals
    
    // Initialize clock and reset
    initial begin
        clk <= 0;
        reset <= 0;
        #100 reset <= 1;
    end
    
    // Clock generation
    initial forever #100 clk = ~clk;
    
    // FemtoRV32 processor instance
    SOC dut (
		.CLK(clk),
		.RESET(reset)
    );

endmodule
