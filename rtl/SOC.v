module SOC (
    input CLK,
    input RESET,

    output wire [31:0] IO
);


// Main CPU inputs
wire [31:0] MAIN_rdata;
wire        MAIN_rbusy;
wire        MAIN_wbusy;
// MAIN CPU outputs
wire [31:0] MAIN_addr;
wire        MAIN_rstrb;
wire [31:0] MAIN_wdata;
wire [3:0]  MAIN_wmask;

// PIM inputs
wire [31:0] PIM_rdata;
wire        PIM_rbusy;
wire        PIM_wbusy;
// PIM outputs
wire [31:0] PIM_addr;
wire        PIM_rstrb;
wire [31:0] PIM_wdata;
wire [3:0]  PIM_wmask;



// RAM 1 inputs
wire [31:0] RAM1_addr;
wire        RAM1_rstrb;
wire [31:0] RAM1_wdata;
wire [3:0]  RAM1_wmask;
// RAM 1 outputs
wire [31:0] RAM1_rdata;
wire        RAM1_wbusy;
wire        RAM1_rbusy;
wire [31:0] RAM1_IO;

// RAM 2 inputs
wire [31:0] RAM2_addr;
wire        RAM2_rstrb;
wire [31:0] RAM2_wdata;
wire [3:0]  RAM2_wmask;
// RAM 2 outputs
wire [31:0] RAM2_rdata;
wire        RAM2_wbusy;
wire        RAM2_rbusy;
wire [31:0] RAM2_PIMStatus;
    
// Data Flow Controls (Chip Select, PIM Select, PIM Clk Gate)
wire CS;
wire PIM_sel;
wire PIM_CLK_GATE;

assign CS = MAIN_addr[12];
assign PIM_sel = RAM2_PIMStatus[0];
assign PIM_CLK_GATE = CLK & PIM_sel;

// RAM 1 input connections
assign RAM1_addr =  (CS == 0) ? MAIN_addr[11:0] : 32'bz;
assign RAM1_rstrb = (CS == 0) ? MAIN_rstrb : 1'bz;
assign RAM1_wdata = (CS == 0) ? MAIN_wdata : 32'bz;
assign RAM1_wmask = (CS == 0) ? MAIN_wmask : 4'bz;

wire isOfMAIN;
assign isOfMAIN = ~PIM_sel && CS; //PIM_sel == 1'b0 && CS == 1'b1;
// RAM 2 input connections
assign RAM2_addr =  ( isOfMAIN ) ? MAIN_addr[11:0]  : PIM_addr[11:0];
assign RAM2_rstrb = ( isOfMAIN ) ? MAIN_rstrb : PIM_rstrb;
assign RAM2_wdata = ( isOfMAIN ) ? MAIN_wdata : PIM_wdata;
assign RAM2_wmask = ( isOfMAIN ) ? MAIN_wmask : PIM_wmask;

// MAIN CPU input connections (RAM out)
assign MAIN_rdata = ( isOfMAIN ) ? RAM2_rdata : RAM1_rdata;
assign MAIN_rbusy = ( isOfMAIN ) ? RAM2_rbusy : RAM1_rbusy;
assign MAIN_wbusy = ( isOfMAIN ) ? RAM2_wbusy : RAM1_wbusy;

// PIM input connections (RAM out)
assign PIM_rdata = (PIM_sel == 1) ? RAM2_rdata : 32'bz;
assign PIM_rbusy = (PIM_sel == 1) ? RAM2_rbusy : 1'bz;
assign PIM_wbusy = (PIM_sel == 1) ? RAM2_wbusy : 1'bz;

// Instantiations

Memory #(.INIT_FILE("D:/Study/FALL2024/Thesis2/PIMSoC_IM/firmware/main.hex"), .DUMP_FILE("D:/Study/FALL2024/Thesis2/PIMSoC_IM/dump/dump_RAM1.hex")) RAM1 
(
    .clk(CLK),
    .mem_addr(RAM1_addr),
    .mem_rdata(RAM1_rdata),
    .mem_rstrb(RAM1_rstrb),
    .mem_wdata(RAM1_wdata),
    .mem_wmask(RAM1_wmask),
    .mem_rbusy(RAM1_rbusy),
    .mem_wbusy(RAM1_wbusy),
    .IOandPIMStatus(IO)
);

Memory #(.INIT_FILE("D:/Study/FALL2024/Thesis2/PIMSoC_IM/firmware/PIM.hex"), .DUMP_FILE("D:/Study/FALL2024/Thesis2/PIMSoC_IM/dump/dump_RAM2.hex")) RAM2
(
    .clk(CLK),
    .mem_addr(RAM2_addr),
    .mem_rdata(RAM2_rdata),
    .mem_rstrb(RAM2_rstrb),
    .mem_wdata(RAM2_wdata),
    .mem_wmask(RAM2_wmask),
    .mem_rbusy(RAM2_rbusy),
    .mem_wbusy(RAM2_wbusy),
    .IOandPIMStatus(RAM2_PIMStatus)
);

FemtoRV32IM CPU(
    .clk(CLK),
    .reset(RESET),
    .mem_addr(MAIN_addr),
    .mem_rdata(MAIN_rdata),
    .mem_rstrb(MAIN_rstrb),
    .mem_wdata(MAIN_wdata),
    .mem_wmask(MAIN_wmask),
    .mem_rbusy(MAIN_rbusy),
    .mem_wbusy(MAIN_wbusy)
);

FemtoRV32IM PIM(
    .clk(CLK),
    .reset(RESET & PIM_sel),
    .mem_addr(PIM_addr),
    .mem_rdata(PIM_rdata),
    .mem_rstrb(PIM_rstrb),
    .mem_wdata(PIM_wdata),
    .mem_wmask(PIM_wmask),
    .mem_rbusy(PIM_rbusy),
    .mem_wbusy(PIM_wbusy)
);

initial $monitor("CS = %b  PIM_sel = %b  isOfMain = %b  RAM2_addr = %d  RAM2_wdata = %h", CS, PIM_sel, isOfMAIN, RAM2_addr, RAM2_wdata);
//initial $monitor("RAM2_addr = %h", RAM2_addr);
endmodule
