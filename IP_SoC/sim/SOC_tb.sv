`timescale 1ns / 1ns

module SOC_tb;
    // Clock and reset
    bit clk;
    bit reset;
    
    bit [63:0] CPU_cycles;
    // bit [63:0] PIM_cycles;
    
    // bit MAIN_done_ecall = 0;
    // bit PIM_done_ecall = 0;

    // Initialize clock and reset
    initial begin

      // clock and reset
      clk <= 0;
      reset <= 0;
      #100 reset <= 1;

      // Memory Monitoring
      // $monitor("RAM1_addr = %h, RAM1_rdata = %h, RAM2_addr = %h, RAM1_rdata = %h", dut.RAM1.mem_addr, dut.RAM1.mem_rdata, dut.RAM2.mem_addr, dut.RAM2.mem_rdata);
      
    end
    
    // Clock generation
    initial forever #10 clk = ~clk;

    always @(posedge clk) begin
          // Dump logic 
      if(dut.CPU.mem_rdata === 32'h00000073 && dut.CPU.registerFile[17] === 1'b1) begin
        $writememh("../dumps/dump_MAINregF.hex", dut.CPU.registerFile);

        $display("MAIN REG FILE DUMPED");
        // $display("MAIN DUMPED RAM 1");

        CPU_cycles = dut.CPU.cycles;
        $display("CYCLES = %d", CPU_cycles);

        #50;
        $stop();
      end
      
    end

    // FemtoRV32 processor instance
    SoC dut (
		.clk(clk),
		.rstN(reset)

    );

endmodule
