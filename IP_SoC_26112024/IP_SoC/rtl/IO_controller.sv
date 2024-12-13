module IO_controller (
    input  logic         clk,              
    input  logic         reset_n,          
	//core 
    input  logic [31:0]  riscv_addr, 
    input  logic [31:0]  riscv_wdata,
    input  logic  [3:0]  riscv_wmask,
    input  logic         riscv_rstrb,

    output logic [31:0]  GPIO
);
    //IO is at 0xFFC = 4092
    logic is_io_access;
    always_comb begin
        is_io_access = (riscv_addr == 32'h00000FFC);    // Address modified to our riscvory map
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if(reset_n == 1'b0) begin
            GPIO <= '0;
        end else if(is_io_access == 1'b1) begin
            if(riscv_wmask[0]) GPIO [ 7:0 ] <= riscv_wdata[ 7:0 ];
            if(riscv_wmask[1]) GPIO [15:8 ] <= riscv_wdata[15:8 ];
            if(riscv_wmask[2]) GPIO [23:16] <= riscv_wdata[23:16];
            if(riscv_wmask[3]) GPIO [31:24] <= riscv_wdata[31:24];

        end
    end
endmodule
