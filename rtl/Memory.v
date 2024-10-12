module Memory #(
   parameter INIT_FILE = "mem.hex",
   parameter DUMP_FILE = "dump.hex"
) 
(
   input  wire         clk,
   input  wire   [31:0] mem_addr,  
   output reg [31:0] mem_rdata, 
	output reg mem_wbusy = 0,
	output reg mem_rbusy = 0,
   input  wire 	     mem_rstrb, 
   input  wire    [31:0] mem_wdata, 
   input  wire   [3:0]  mem_wmask,

   output reg [31:0] IOandPIMStatus = 32'h00000000
);
   // 1k locations each 4 bytes = 4kb of memory
   reg [31:0] MEM [0:1023]; 
   
//   assign IOandPIMStatus = MEM[1023];
   
   initial begin
     $readmemh(INIT_FILE, MEM);
//     MEM[1023] = 32'h00000000;
     $display("Memory Initialzed");
   end
	
   integer cycles = 0;
	
   // initial begin
      always @(posedge clk) begin
         if(mem_rdata == 32'h00000073) begin
            $writememh(DUMP_FILE, MEM);
            $display("MEMORY DUMPED");
            $display("cycles = %d", cycles);
            $finish;
         end
         cycles = cycles + 1;
      end

      
   // end
// 	 always @(posedge clk) begin
        
//         if (cycles == 5000) begin
// 				$writememh(DUMP_FILE, MEM);
// 				$display("MEMORY DUMPED");
//             $display("MEM[0] = %h", MEM [0]);
// //            $finish; // Terminate the simulation
        
//         end
        
//         if(cycles == 5001) begin
//         $finish;
//         end
// 		  cycles = cycles + 1;
        
//     end
	

   wire [29:0] word_addr = mem_addr[31:2];
   always @(posedge clk) begin
      if(mem_rstrb) begin
         mem_rdata <= MEM[word_addr];
			$display("MEMORY READING... ADDR = 0x%h", word_addr);
			mem_rbusy <= 1;
			end
			else begin
			mem_rbusy <= 0;
      end
		
		if (|mem_wmask) begin
         mem_wbusy <= 1;
         $display("MEMORY WRITING at 0x%h", word_addr);
      end else begin
         mem_wbusy <= 0;
      end
		
//      if(mem_wmask[0]) MEM[word_addr][ 7:0 ] <= mem_wdata[ 7:0 ];
//      if(mem_wmask[1]) MEM[word_addr][15:8 ] <= mem_wdata[15:8 ];
//      if(mem_wmask[2]) MEM[word_addr][23:16] <= mem_wdata[23:16];
//      if(mem_wmask[3]) MEM[word_addr][31:24] <= mem_wdata[31:24];
      
//      if(&word_addr[9:0]) IOandPIMStatus <= MEM[word_addr];
      // if(&word_addr[11:0]) IOandPIMStatus <= mem_rdata;
//      $monitor("word_addr = 0b%b", word_addr[9:0]);

      // IO ADDRESS DECODING
      if(&word_addr[9:0])
        begin
            if(mem_wmask[0]) IOandPIMStatus [ 7:0 ] <= mem_wdata[ 7:0 ];
            if(mem_wmask[1]) IOandPIMStatus [15:8 ] <= mem_wdata[15:8 ];
            if(mem_wmask[2]) IOandPIMStatus [23:16] <= mem_wdata[23:16];
            if(mem_wmask[3]) IOandPIMStatus [31:24] <= mem_wdata[31:24];
        end
        else
        begin
		
            if(mem_wmask[0]) MEM[word_addr][ 7:0 ] <= mem_wdata[ 7:0 ];
            if(mem_wmask[1]) MEM[word_addr][15:8 ] <= mem_wdata[15:8 ];
            if(mem_wmask[2]) MEM[word_addr][23:16] <= mem_wdata[23:16];
            if(mem_wmask[3]) MEM[word_addr][31:24] <= mem_wdata[31:24];
      
      end	 
	end

	
   endmodule