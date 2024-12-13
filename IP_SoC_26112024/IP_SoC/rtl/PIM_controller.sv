module PIM_controller(
    input  logic clk,
    input  logic rstN,
    output logic pim_rstN,
    //core
    input  logic [31:0] riscv_addr, 
    input  logic [31:0] riscv_wdata,
    input  logic [3: 0] riscv_wmask,
    input  logic        riscv_rstrb,
    output logic [31:0] riscv_rdata,
    output logic        riscv_rbusy,
    output logic        riscv_wbusy,
    //PIM
    input  logic [31:0]  pim_addr,
    input  logic [31:0]  pim_wdata,
    input  logic [3: 0]  pim_wmask,
    input  logic         pim_rstrb,
    output logic [31:0]  pim_rdata,
    output logic         pim_rbusy,
    output logic         pim_wbusy,
    output logic         pim_sel,
        //ram ip
    output logic [9:0]  ram_addr,   
    output logic [31:0] ram_wdata,  
    output logic        ram_wen,
    output logic        ram_rden,   
    output logic  [3:0] ram_byteena,
    input  logic [31:0] ram_rdata,
    input logic busy

);

//core
logic [31:0] sel_addr; 
logic [31:0] sel_wdata;
logic [3: 0] sel_wmask;
logic         sel_rstrb;
logic [31:0] sel_rdata;
logic        sel_rbusy;
logic        sel_wbusy;

logic        CS;

// logic        pim_sel;

assign CS = riscv_addr[12];

always_ff @(posedge clk or negedge rstN) begin
    if(rstN == 1'b0) begin
        pim_sel <= 1'b0;
    end else begin
        case(pim_sel)
            1'b0: begin
                if(riscv_addr == 32'h00001FFC) begin
                    // pim_sel <= 0;
                    pim_sel <= riscv_wdata[0];
                end
            end
            1'b1: begin
                if(pim_addr == 32'h00000FFC) begin
                    // pim_sel <= 1;
                    pim_sel <= pim_wdata[0];
                end
            end
        endcase
    end
    
end
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
            riscv_rdata = 'z;
            riscv_rbusy = 1'bz;
            riscv_wbusy = 1'bz;
        end
        
        1'b0: begin
            sel_addr  = riscv_addr;
            sel_wdata = riscv_wdata;
            sel_wmask = riscv_wmask;
            sel_rstrb = riscv_rstrb;
            if(CS == 1'b1) begin
                riscv_rdata = sel_rdata;
                riscv_rbusy = sel_rbusy;
                riscv_wbusy = sel_wbusy;
            end else begin
                riscv_rdata = 'z;
                riscv_rbusy = 'z;
                riscv_wbusy = 'z;
            end
            
            pim_rdata = 'z;
            pim_rbusy = 1'bz;
            pim_wbusy = 1'bz;
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

assign pim_rstN = pim_sel & rstN;
//Instantiate the ram controller
ram_controller ram_controller_inst (
    .clk(clk),
    .reset_n(rstN),
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
    .ram_rdata(ram_rdata),
    // .oe(1'b1) 
    .oe(pim_sel || CS),
    .busy(busy)
);


endmodule