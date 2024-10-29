module ram_controller_tb;

    // Declare inputs and outputs for the testbench
    logic clk;
    logic reset_n;
    
    // RISC-V Core Interface
    logic [31:0] riscv_addr;
    logic [31:0] riscv_wdata;
    logic [3:0] riscv_wmask;
    logic riscv_rstrb;
    //logic riscv_wen;
    bit [31:0] riscv_rdata;
    logic riscv_rbusy;
    logic riscv_wbusy;

    // RAM IP Interface
    bit [9:0] ram_addr;
    bit [31:0] ram_wdata;
    logic ram_wen;
    logic ram_rden;
    bit [3:0] ram_byteena;
    logic [31:0] ram_rdata;

    // I/O Interface (Testbench drives io_rdata)
    // logic [31:0] io_data_out;
    // logic io_write_en;
    // logic [31:0] io_rdata;  // Will be forced by the testbench
    // logic io_busy;

    // Instantiate the Device Under Test (DUT)
    ram_controller dut (
        .clk(clk),
        .reset_n(reset_n),
        .riscv_addr(riscv_addr),
        .riscv_wdata(riscv_wdata),
        .riscv_wmask(riscv_wmask),
        .riscv_rstrb(riscv_rstrb),
       // .riscv_wen(riscv_wen),
        .riscv_rdata(riscv_rdata),
        .riscv_rbusy(riscv_rbusy),
        .riscv_wbusy(riscv_wbusy),
        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata),
        .ram_wen(ram_wen),
        .ram_rden(ram_rden),
        .ram_byteena(ram_byteena),
        .ram_rdata(ram_rdata)
        // .io_data_out(io_data_out),
        // .io_write_en(io_write_en),
        // .io_rdata(io_rdata),  // Testbench will force this signal
        // .io_busy(io_busy)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Stimulus for testing all states
    initial begin
        // Initialize signals
        clk = 1;
        reset_n = 0;
        riscv_addr = 32'h00000000;
        riscv_wdata = 32'h00000000;
        riscv_wmask = 4'b0000;
        riscv_rstrb = 0;
        ram_rdata = 32'h87654321;  // Example data from RAM

        
        // Reset the controller
        @(posedge clk) reset_n = 1;

        // Test RAM Write
        //@(posedge clk) 
                       riscv_addr = 32'h00000004;   // RAM address
                       riscv_wdata = 32'habcd1234;  // Write data
                       riscv_wmask = 4'b1111;       // Byte mask
                       riscv_rstrb = 0;

            //riscv_wen = 1;               // Write enable



        // Test RAM Read
        @(posedge clk) riscv_rstrb = 1;  // Read strobe asserted
                       riscv_wmask = 4'b0000;
         
        @(posedge clk) riscv_rstrb = 1;  // Read strobe asserted
                       riscv_wmask = 4'b1000; 
    
        @(posedge clk) riscv_rstrb = 0;
        @(posedge clk) riscv_addr = 32'hffffffff;
        
        #50 $stop;
    end

    // Monitor changes for debugging
    initial begin
        $monitor("Time: %0d, State: %0d, Addr: 0x%h, RData: 0x%h, WData: 0x%h, rstrb: %b, rbusy: %b, wbusy: %b",
            $time, dut.state, riscv_addr, riscv_rdata, riscv_wdata, riscv_rstrb, riscv_rbusy, riscv_wbusy);
    end

endmodule


























//module ram_controller_tb;
//
//    logic clk;
//    logic reset_n;
//    logic [31:0] riscv_addr;
//    logic [31:0] riscv_wdata;
//    logic [3:0] riscv_wmask;
//    logic riscv_rstrb;
//    logic riscv_wen;
//    logic [31:0] riscv_rdata;
//    logic riscv_rbusy;
//    logic riscv_wbusy;
//
//    logic [9:0] ram_addr;
//    logic [31:0] ram_wdata;
//    logic ram_wen;
//    logic ram_rden;
//    logic [3:0] ram_byteena;
//    logic [31:0] ram_rdata;
//
//    logic [31:0] io_data_out;
//    logic io_write_en;
//    logic [31:0] io_rdata;  // Input signal to DUT, driven by the testbench
//    logic io_busy;
//
//    //instantiate the DUT (Device Under Test)
//    ram_controller dut (
//        .clk(clk),
//        .reset_n(reset_n),
//        .riscv_addr(riscv_addr),
//        .riscv_wdata(riscv_wdata),
//        .riscv_wmask(riscv_wmask),
//        .riscv_rstrb(riscv_rstrb),
//        .riscv_wen(riscv_wen),
//        .riscv_rdata(riscv_rdata),
//        .riscv_rbusy(riscv_rbusy),
//        .riscv_wbusy(riscv_wbusy),
//        .ram_addr(ram_addr),
//        .ram_wdata(ram_wdata),
//        .ram_wen(ram_wen),
//        .ram_rden(ram_rden),
//        .ram_byteena(ram_byteena),
//        .ram_rdata(ram_rdata),
//        .io_data_out(io_data_out),
//        .io_write_en(io_write_en),
//        .io_rdata(io_rdata),  // io_rdata only driven by the testbench
//        .io_busy(io_busy)
//    );
//
//    // Clock generation
//    always #5 clk = ~clk;
//
//    // Simulate RAM and I/O data responses
//    initial begin
//        clk = 0;
//        reset_n = 0;
//        riscv_addr = 32'h00000000;
//        riscv_wdata = 32'h0;
//        riscv_wmask = 4'b1111;
//        riscv_rstrb = 0;
//        riscv_wen = 0;
//        io_busy = 0;  // I/O is not busy
//        ram_rdata = 32'h87654321; // Simulate RAM data
//
//        
//        // Reset pulse
//        #10 reset_n = 1;
//
//        // Test RAM write
//        #10 riscv_addr = 32'h00000004; riscv_wdata = 32'hABCD1234; riscv_wen = 1;
//        #10 riscv_wen = 0;
//
//        // Test RAM read
//        #10 riscv_rstrb = 1;
//        #10 riscv_rstrb = 0;
//
//        // Simulate I/O Data for 0xFFFFFFFF address using force
//        #10 riscv_addr = 32'hFFFFFFFF; 
//		  io_busy = 1;
//		  riscv_wen = 1;
//        #10 force io_rdata = 32'h12345678; // Force I/O read data from testbench
//        #10 riscv_wen = 0; 
//		  io_busy = 0;
//		  release io_rdata;
//
//        // Test I/O read with force/release
//        #10 riscv_rstrb = 1;
//		  io_busy = 1;
//        #10 force io_rdata = 32'hDEADBEEF;  // Force I/O response data from testbench
//		  io_busy = 0;
//        #10 riscv_rstrb = 0;
//		  release io_rdata;
//
//        #50 $finish;
//    end
//
//endmodule

