module pim_controller (
input logic clk,
input logic rst,
//core
    input  logic [31:0] riscv_addr, 
    input  logic [31:0] riscv_wdata,
    input  logic [3: 0] riscv_wmask,
    input  logic        riscv_rstrb,
    output logic [31:0] riscv_rdata,
    output logic        riscv_rbusy,
    output logic        riscv_wbusy,
//PIM
    input logic [31:0]  pim_addr,
    input logic [31:0]  pim_wdata,
    input logic [3: 0]  pim_wmask,
    input  logic        pim_rstrb,
    output logic [31:0] pim_rdata,
    output logic        pim_rbusy,
    output logic        pim_wbusy,

	 //ram ip
    output logic [9:0]  ram_addr,   
    output logic [31:0] ram_wdata,  
    output logic        ram_wen,
    output logic        ram_rden,   
    output logic  [3:0] ram_byteena,
    input  logic [31:0] ram_rdata,

    //PIM select
    input logic pim_sel
);

//core
logic [31:0] sel_addr; 
logic [31:0] sel_wdata;
logic [3: 0] sel_wmask;
logic         sel_rstrb;
logic [31:0] sel_rdata;
logic        sel_rbusy;
logic        sel_wbusy;


// Multiplexer to select between RISC-V CPU and PIM Controller
// pim_sel: 1 -> PIM -- 0 -> RISC-V CPU
always_comb begin
    case (pim_sel)
        1'b1: begin
            sel_addr  = pim_addr;
            sel_wdata = pim_wdata;
            sel_wmask = pim_wmask;
            sel_rstrb = pim_rstrb;
            pim_rdata = sel_rdata;
            pim_rbusy = sel_rbusy;
            pim_wbusy = sel_wbusy;
            riscv_rdata = '0;
            riscv_rbusy = 1'b0;
            riscv_wbusy = 1'b0;
        end
        
        1'b0: begin
            sel_addr  = riscv_addr;
            sel_wdata = riscv_wdata;
            sel_wmask = riscv_wmask;
            sel_rstrb = riscv_rstrb;
            riscv_rdata = sel_rdata;
            riscv_rbusy = sel_rbusy;
            riscv_wbusy = sel_wbusy;
            pim_rdata = '0;
            pim_rbusy = 1'b0;
            pim_wbusy = 1'b0;
        end
        
        default: begin // Optional but good practice
            sel_addr  = '0;
            sel_wdata = '0;
            sel_wmask = '0;
            sel_rstrb = '0;
            riscv_rdata = '0;
            pim_rdata = '0;
            riscv_rbusy = 1'b0;
            riscv_wbusy = 1'b0;
            pim_rbusy = 1'b0;
            pim_wbusy = 1'b0;
        end
    endcase
end
//Instantiate the ram controller
ram_controller ram_controller_inst (
    .clk(clk),
    .reset_n(rst),
    .riscv_addr(sel_addr),
    .riscv_wdata(sel_wdata),
    .riscv_wmask(sel_wmask),
    .riscv_rstrb(sel_rstrb),
    .riscv_rdata(sel_rdata),
    .riscv_rbusy(sel_rbusy),
    .riscv_wbusy(sel_wbusy),
    .ram_addr(ram_addr),
    .ram_wdata(ram_wdata),
    .ram_wen(ram_wen),
    .ram_rden(ram_rden),
    .ram_byteena(ram_byteena),
    .ram_rdata(ram_rdata)
);
endmodule