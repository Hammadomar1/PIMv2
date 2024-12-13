module ram_controller (
    input logic         clk,              
    input logic         reset_n,          
	//core
    input logic [31:0]  riscv_addr, 
    input logic [31:0]  riscv_wdata,
    input logic  [3:0]  riscv_wmask,
    input logic         riscv_rstrb,
    //input logic         riscv_wen,  // There is no write enable coming from core. Evaluated with (!riscv_rstrb)
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

    input  logic        oe,      // Output Enable
    input  logic        busy
);


    typedef enum logic [1:0] {
        IDLE, 
        READ, 
        WRITE, 
        WAIT
    } state_t;

    state_t state, next_state;

    logic riscv_rstrb_temp;
    //IO is at 0xFFC = 4092
    logic is_io_access;
    always_comb begin
        is_io_access = (riscv_addr == 32'h00000FFC || riscv_addr == 32'h00001FFC);    // Address modified to our memory map
    end

    //state logic and outputs
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    //outputs based on the state
    always_comb begin
        next_state = state;

        case (state)
            IDLE: begin

                if(is_io_access) begin
                    next_state = IDLE;
                end else if (!is_io_access && riscv_rstrb && !busy) begin
                    next_state = READ;
                end else if(!is_io_access && !riscv_rstrb && (|riscv_wmask) && !busy) begin //If (!rstrb) then write enable
                    next_state = WRITE;
                end else if(busy) begin
                    next_state = WAIT;
                end else begin
                    next_state = IDLE;
                end     
            end

            READ: begin
                
                if(busy)
                    next_state = WAIT;
                else
                    next_state = IDLE;
            end

            WRITE: begin
                if(busy)
                    next_state = WAIT;
                else
                    next_state = IDLE;
            end

             WAIT: begin
                 if (!is_io_access && riscv_rstrb && !busy) begin
                    next_state = READ;
                end else if(!is_io_access && !riscv_rstrb && (|riscv_wmask) && !busy) begin //If (!rstrb) then write enable
                    next_state = WRITE;
                end else if(!busy) begin
                    next_state = IDLE;
                end
             end

        endcase
    end

    // Moore output logic
    always_comb begin
        riscv_rdata = /* (state == WRITE) ? 32'bz : */ ram_rdata;

        if(oe == 1'b0) begin
            riscv_rdata = 32'bz;
            riscv_rbusy = 1'bz;
            riscv_wbusy = 1'bz;
            
            ram_rden = 0;
            ram_wen = 0;

        end else begin

            case (state)
                IDLE: begin
                    riscv_rbusy = 0;
                    riscv_wbusy = 0;
                    ram_rden = 0;
                    ram_wen = 0;
                    //io_write_en = 0;
                end

                READ: begin
                    riscv_rbusy = 1;
                    riscv_wbusy = 0;
                    ram_rden = 1;
                    ram_wen = 0;
                    //io_write_en = 0;                
                    
                end

                WRITE: begin
                    riscv_rbusy = 0;
                    riscv_wbusy = 1;
                    ram_rden = 0;
                    ram_wen = 1;
                    //io_write_en = 0;
                end

                 WAIT: begin
                     riscv_rbusy = 1;
                     riscv_wbusy = 1;
                     ram_rden = 0;
                     ram_wen = 0;
                 end
        endcase
        end

    end
    //ram o/p
    assign ram_addr[9:0]     = riscv_addr[11:2];  // Shifted by 2 bits to account for base addresses, Fayez
    assign ram_wdata    = riscv_wdata;
    // assign ram_byteena  = riscv_wmask;
    // assign riscv_rdata = (state == WRITE) ? 32'bz : ram_rdata;


    // Byte_enable Latch
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
        ram_byteena <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    ram_byteena <= riscv_wmask;
                end
                READ: begin
                    ram_byteena <= 4'b0;
                end
                WRITE: begin
                    ram_byteena <= ram_byteena; // Latch wmask at the beginning of WRITE
                end

                   WAIT: begin
                       ram_byteena <= ram_byteena; // Latch wmask at the beginning of WRITE
                      
                   end
            endcase
        end
    end


    //assign io_data_out  = riscv_wdata;

    //mux: ram or io
    // always_comb begin
    //     if (is_io_access) begin
    //         riscv_rdata = io_rdata;
    //     end else begin
    //         riscv_rdata = ram_rdata; 
    //     end 
    // end
endmodule
