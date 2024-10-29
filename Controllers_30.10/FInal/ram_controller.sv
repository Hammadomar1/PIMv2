module ram_controller (
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
    output logic  [3:0] ram_byteena,
    input  logic [31:0] ram_rdata  
);


    typedef enum logic [1:0] {
        IDLE,       
        READ,       
        WRITE,
        WAIT      
    } state_t;

    state_t state, next_state;

    //0xFFFFFFFF
    logic is_io_access;
    always_comb begin
        is_io_access = (riscv_addr == 32'hFFFFFFFF);    // Modify address to 10 bits
    end
    logic [1:0] prev_state;

// Update previous state
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            prev_state <= IDLE;
        end else begin
            prev_state <= state;
        end
    end
    //state logic and outputs
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    ////outputs based on the state
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin

                if(is_io_access) begin
                    next_state = IDLE;
                end else if (!is_io_access && riscv_rstrb) begin
                    next_state = READ;
                end else if(!is_io_access && !riscv_rstrb && (|riscv_wmask)) begin //If (!rstrb) then write enable
                    next_state = WRITE;
                end else begin
                    next_state = IDLE;
                end     // Possible Latch? RESOLVED
            end

            READ: begin
                next_state = WAIT;
                // if(is_io_access) begin
                //     next_state = IDLE;
                // end
            end

            WRITE: begin
                next_state = WAIT;
                // if(is_io_access) begin
                //     next_state = IDLE;
                // end

            end

            WAIT: begin
                next_state = IDLE;
                if(is_io_access) begin
                    next_state = IDLE;
                end else if (!is_io_access && riscv_rstrb) begin
                    next_state = READ;
                end else if(!is_io_access && !riscv_rstrb && (|riscv_wmask)) begin //If (!rstrb) then write enable
                    next_state = WRITE;
                end else begin
                    next_state = IDLE;
                end
            end

        endcase
    end

    // Moore output logic
    always_comb begin
    // Default assignments
    riscv_rbusy = 1'b0;
    riscv_wbusy = 1'b0;
    ram_rden    = 1'b0;
    ram_wen     = 1'b0;
    ram_addr    = '0;
    ram_wdata   = '0;
    ram_byteena = '0;
    riscv_rdata = '0;

    case (state)
        IDLE: begin
            // No additional assignments needed
        end

        READ: begin
            riscv_rbusy = 1'b1;
            ram_rden    = 1'b1;
            ram_addr    = riscv_addr[9:0];
            riscv_rdata = ram_rdata;
        end

        WRITE: begin
            riscv_wbusy = 1'b1;
            ram_wen     = 1'b1;
            ram_addr    = riscv_addr[9:0];
            ram_wdata   = riscv_wdata;
            ram_byteena = riscv_wmask;
        end
        WAIT: begin
            case (prev_state)
        READ: begin
            riscv_rbusy = 1'b1;
            ram_rden    = 1'b1;
            ram_addr    = riscv_addr[9:0];
            riscv_rdata = ram_rdata;
        end
        WRITE: begin
            riscv_wbusy = 1'b1;
            ram_wen     = 1'b1;
            ram_addr    = riscv_addr[9:0];
            ram_wdata   = riscv_wdata;
            ram_byteena = riscv_wmask;
        end
            endcase
        end
    endcase
end
    //ram o/p
    //assign ram_addr     = riscv_addr[9:0];  
    //assign ram_wdata    = riscv_wdata;
    //assign ram_byteena  = riscv_wmask;
    //assign riscv_rdata = ram_rdata;


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
