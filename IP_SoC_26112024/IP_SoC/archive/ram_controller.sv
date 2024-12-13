module ram_controller (
    input logic         clk,              
    input logic         reset_n,          
	//core
    input logic [31:0]  riscv_addr,
    input logic [31:0]  riscv_wdata,
    input logic  [3:0]  riscv_wmask,
    input logic         riscv_rstrb,
    input logic         riscv_wen,  // There is no write enable coming from core. Evaluated with (|riscv_wmask)
    output logic [31:0] riscv_rdata,
    output logic        riscv_rbusy,
    output logic        riscv_wbusy,

	 //ram ip
    output logic [9:0]  ram_addr,   
    output logic [31:0] ram_wdata,  
    output logic        ram_wen,
    output logic        ram_rden,   
    output logic  [3:0] ram_byteena,
    input  logic [31:0] ram_rdata,  

    //I/O
    output logic [31:0] io_data_out,      
    output logic        io_write_en,     
    output logic [31:0] io_rdata,         
    input  logic        io_busy          // From where?
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
        riscv_rbusy = 1'b0; // Should not be enforced.
        riscv_wbusy = 1'b0; // same.
        ram_rden = 1'b0;    // forcing of logic coming from core, why?
        ram_wen = 1'b0;     // same here
        io_write_en = 1'b0;

        case (state)
            IDLE: begin
				
                if (riscv_rstrb) begin
                    next_state = READ;
                end else if (riscv_wen) begin
                    next_state = WRITE;
                end     // Possible Latch?
            end

            READ: begin

                if (is_io_access) begin
                    riscv_rbusy = 1'b1;  
                    if (!io_busy) begin
                        next_state = IDLE;
                    end
                end else begin
                    ram_rden = 1'b1;        
                    riscv_rbusy = 1'b1;
                    next_state = WAIT;
                end
            end

            WRITE: begin
                
                if (is_io_access) begin
                    io_write_en = 1'b1;    
                    riscv_wbusy = 1'b1; 
                    if (!io_busy) begin
                        next_state = IDLE;
                    end
                end else begin
                    ram_wen = 1'b1;         
                    riscv_wbusy = 1'b1;
                    next_state = WAIT;
                end
            end

				
				WAIT: begin
						
						 next_state = WAIT;  

						 //for read
						 if (!is_io_access && riscv_rstrb) begin
							  ram_rden = 1'b1;  
							  riscv_rbusy = 1'b1;  
						 end

						 //for write
						 if (!is_io_access && riscv_wen) begin
							  ram_wen = 1'b1;  
							  riscv_wbusy = 1'b1;  
						 end

						 //for io
						 if (is_io_access) begin
							  if (riscv_rstrb) begin
									riscv_rbusy = 1'b1;  
							  end else if (riscv_wen) begin
									riscv_wbusy = 1'b1;  
							  end
							  if (!io_busy) begin
									next_state = IDLE;  
									riscv_rbusy = 1'b0; 
									riscv_wbusy = 1'b0;
							  end
						 end

						 
						 if (!riscv_rstrb && !riscv_wen) begin
							  next_state = IDLE;  
							  riscv_rbusy = 1'b0; 
							  riscv_wbusy = 1'b0;
						 end
					end

//            WAIT: begin
//					 if (!is_io_access) begin
//						  ram_rden = 1'b1;  
//						  riscv_rbusy = 1'b1;
//					 end
//					 if (!riscv_rstrb && !riscv_wen) begin
//						  next_state = IDLE; 
//						  riscv_rbusy = 1'b0;
//					 end
//				end
        endcase
    end

    //ram o/p
    assign ram_addr     = riscv_addr[9:0];  
    assign ram_wdata    = riscv_wdata;
    assign ram_byteena  = riscv_wmask;


    assign io_data_out  = riscv_wdata;

    //mux: ram or io
    always_comb begin
        if (is_io_access) begin
            riscv_rdata = io_rdata;  
        end else begin
            riscv_rdata = ram_rdata;
        end
    end

endmodule
