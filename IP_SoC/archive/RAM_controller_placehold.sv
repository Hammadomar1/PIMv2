module RAM_controller_placehold (
    input logic         clk,              
    input logic         reset_n,          
	//core
    input  logic [31:0]  riscv_addr,
    input  logic [31:0]  riscv_wdata,
    input  logic [3:0]   riscv_wmask,
    input  logic         riscv_rstrb,
    output logic [31:0]  riscv_rdata,
    output logic         riscv_rbusy,
    output logic         riscv_wbusy,

	 //ram ip
    output logic [9:0]  ram_addr,   
    output logic [31:0] ram_wdata,  
    output logic        ram_wen,
    output logic        ram_rden,   
    output logic [3:0]  ram_byteena,
    input  logic [31:0] ram_q
);

always_comb begin
    if(riscv_rstrb == 1'b1) begin
        ram_rden    = 1'b1;
        riscv_rbusy = 1'b1;
    end else begin
        ram_rden    = 1'b0
        riscv_rbusy = 1'b0;
    end

    if (|riscv_wmask == 1'b1) begin
        ram_wen     = 1;
        riscv_wbusy = 1;
    end else begin
        ram_wen     = 0;
        riscv_wbusy = 0;
    end

    ram_addr = riscv_addr[9:0]
    ram_wdata = riscv_wdata
    ram_byteena = riscv_wmask
    ram_q = riscv_rdata

end
endmodule