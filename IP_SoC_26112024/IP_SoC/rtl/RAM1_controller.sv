module RAM1_controller (
    input logic         clk,              
    input logic         reset_n,          
	//core
    input logic [31:0]  riscv_addr, 
    input logic [31:0]  riscv_wdata,
    input logic  [3:0]  riscv_wmask,
    input logic         riscv_rstrb,
    output logic [31:0] riscv_rdata,
    output logic        riscv_rbusy,
    output logic        riscv_wbusy,

	 //ram ip
    output logic [9:0]  ram_addr,   
    output logic [31:0] ram_wdata,  
    output logic        ram_wen,
    output logic        ram_rden,   
    output logic [3:0]  ram_byteena,
    input  logic [31:0] ram_rdata,

    input logic         pim_sel,
    input logic busy
);


logic CS;
assign CS = riscv_addr[12];


ram_controller RAM1_CTRL(
 
    .clk,              
    .reset_n,          
	//core
    .riscv_addr, 
    .riscv_wdata,
    .riscv_wmask,
    .riscv_rstrb,
    
    .riscv_rdata,
    .riscv_rbusy,
    .riscv_wbusy,

	//ram ip
    .ram_addr,   
    .ram_wdata,  
    .ram_wen,
    .ram_rden,   
    .ram_byteena,
    .ram_rdata,

    .oe(~CS || pim_sel),    // Output Enable
    .busy(busy)
    // .oe(1'b1)      // Output Enable

);

endmodule