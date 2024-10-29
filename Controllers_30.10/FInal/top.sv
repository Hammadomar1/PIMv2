module top (
input logic clk,
input logic rstN
);

logic  [31:0]  mem_addr;
logic  [31:0]  mem_wdata; // data to be written
logic  [3:0 ]  mem_wmask; // write mask for the 4 bytes of each word
logic         mem_rstrb;// active to initiate memory read (used by IO)
logic         mem_rbusy; // asserted if memory is busy reading value
logic         mem_wbusy; // asserted if memory is busy writing value
logic  [9:0 ] cont_addr_out;
logic  [3:0 ] ram_byteena;
logic  [31:0] ram_wdata;
logic         ram_rden;
logic         ram_wen;
logic  [31:0] ram_rdata;
logic  [31:0] mem_rdata;
FemtoRV32IM softcore (
   .clk(clk),
   .mem_addr(mem_addr),  // address bus
   .mem_wdata(mem_wdata), // data to be written
   .mem_wmask(mem_wmask), // write mask for the 4 bytes of each word
   .mem_rdata(mem_rdata), // input lines for both data and instr
   .mem_rstrb(mem_rstrb), // active to initiate memory read (used by IO)
   .mem_rbusy(mem_rbusy), // asserted if memory is busy reading value
   .mem_wbusy(mem_wbusy), // asserted if memory is busy writing value
   .reset(rstN)      // set to 0 to reset the processor
);

ram_controller mem_cont (
    .clk(clk),              
    .reset_n(rstN),          
    .riscv_addr(mem_addr), 
    .riscv_wdata(mem_wdata),
    .riscv_wmask(mem_wmask),
    .riscv_rstrb(mem_rstrb),
    .riscv_rdata(mem_rdata),
    .riscv_rbusy(mem_rbusy),
    .riscv_wbusy(mem_wbusy),
    .ram_addr(cont_addr_out),   
    .ram_wdata(ram_wdata),  
    .ram_wen(ram_wen),
    .ram_rden(ram_rden),   
    .ram_byteena(ram_byteena),
    .ram_rdata(ram_rdata) 
);

RAM1_IP ram (
	.address(cont_addr_out),
	.byteena(ram_byteena),
	.clock(clk),
	.data(ram_wdata),
	.rden(ram_rden),
	.wren(ram_wen),
	.q(ram_rdata)
  );


endmodule