module SoC (
input  logic        clk,
input  logic        rstN,
input  logic        busy,
output logic [31:0] GPIO
);

//CPU
logic  [31:0]  mem_addr;
logic  [31:0]  mem_wdata; // data to be written
logic  [3:0 ]  mem_wmask; // write mask for the 4 bytes of each word
logic          mem_rstrb;// active to initiate memory read (used by IO)
logic          mem_rbusy; // asserted if memory is busy reading value
logic          mem_wbusy; // asserted if memory is busy writing value
logic  [31:0]  mem_rdata;
// RAM 1 Control
logic  [9:0 ]  cont_addr_out;
logic  [3:0 ]  ram_byteena;
logic  [31:0]  ram_wdata;
logic          ram_rden;
logic          ram_wen;
logic  [31:0]  ram_rdata;
logic          pim_sel;
// PIM
logic          pim_rstN;
logic  [31:0]  pim_mem_addr;
logic  [31:0]  pim_mem_wdata; // data to be written
logic  [3:0 ]  pim_mem_wmask; // write mask for the 4 bytes of each word
logic          pim_mem_rstrb;// active to initiate memory read (used by IO)
logic          pim_mem_rbusy; // asserted if memory is busy reading value
logic          pim_mem_wbusy; // asserted if memory is busy writing value
logic  [31:0]  pim_mem_rdata;
// RAM 2 Control
logic  [9:0 ]   cont2_addr_out;
logic  [3:0 ]   ram2_byteena;
logic  [31:0]   ram2_wdata;
logic           ram2_rden;
logic           ram2_wen;
logic  [31:0]   ram2_rdata;

FemtoRV32IM CPU (
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

RAM1_controller RAM1_Control (
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
    .ram_rdata(ram_rdata),
    .pim_sel(pim_sel),
    .busy(busy)

);

RAM1_IP RAM1 (
  .address(cont_addr_out),
  .byteena(ram_byteena),
  .clock(clk),
  .data(ram_wdata),
  .rden(ram_rden),
  .wren(ram_wen),
  .q(ram_rdata)
);

FemtoRV32IM PIM (
   .clk(clk),
   .mem_addr(pim_mem_addr),  // address bus
   .mem_wdata(pim_mem_wdata), // data to be written
   .mem_wmask(pim_mem_wmask), // write mask for the 4 bytes of each word
   .mem_rdata(pim_mem_rdata), // input lines for both data and instr
   .mem_rstrb(pim_mem_rstrb), // active to initiate memory read (used by IO)
   .mem_rbusy(pim_mem_rbusy), // asserted if memory is busy reading value
   .mem_wbusy(pim_mem_wbusy), // asserted if memory is busy writing value
   .reset(pim_rstN)      // set to 0 to reset the processor
);

RAM2_IP RAM2 (
  .address(cont2_addr_out),
  .byteena(ram2_byteena),
  .clock(clk),
  .data(ram2_wdata),
  .rden(ram2_rden),
  .wren(ram2_wen),
  .q(ram2_rdata)
);

PIM_controller PIM_Control (
  .clk(clk),
  .rstN(rstN),
  .pim_rstN(pim_rstN),

  .riscv_addr(mem_addr), 
  .riscv_wdata(mem_wdata),
  .riscv_wmask(mem_wmask),
  .riscv_rstrb(mem_rstrb),
  .riscv_rdata(mem_rdata),
  .riscv_rbusy(mem_rbusy),
  .riscv_wbusy(mem_wbusy),

  .pim_addr(pim_mem_addr),
  .pim_wdata(pim_mem_wdata),
  .pim_wmask(pim_mem_wmask),
  .pim_rstrb(pim_mem_rstrb),
  .pim_rdata(pim_mem_rdata),
  .pim_rbusy(pim_mem_rbusy),
  .pim_wbusy(pim_mem_wbusy),
  .pim_sel(pim_sel),

  .ram_addr(cont2_addr_out),   
  .ram_wdata(ram2_wdata),  
  .ram_wen(ram2_wen),
  .ram_rden(ram2_rden),   
  .ram_byteena(ram2_byteena),
  .ram_rdata(ram2_rdata),
  .busy(busy)
);

IO_controller IO_Control(
  .clk(clk),              
  .reset_n(rstN),          
  .riscv_addr(mem_addr), 
  .riscv_wdata(mem_wdata),
  .riscv_wmask(mem_wmask),
  .riscv_rstrb(mem_rstrb),

  .GPIO(GPIO)
);

endmodule