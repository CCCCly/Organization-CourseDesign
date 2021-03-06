module testbench();

	reg clk, resten;
    	reg [ 4:0] rf_addr;   
    	wire [31:0] rf_data;   
    	reg  [31:0] mem_addr;  
    	wire [31:0] mem_data;  
    	wire [31:0] IF_pc;     
    	wire [31:0] IF_inst;   
   	wire [31:0] ID_pc;     
		wire [31:0] EXE_pc;    
		wire [31:0] MEM_pc;    
    	wire [31:0] WB_pc;     
    	wire [31:0] HI_data;   
    	wire [31:0] LO_data;  

 	pipeline_cpu cpu(clk,resten, rf_addr, mem_addr, rf_data, mem_data, IF_pc, IF_inst, ID_pc, EXE_pc, MEM_pc, WB_pc, HI_data, LO_data);

	initial
	begin
		clk = 0;
		resten = 1;
	end

	always #70 clk = ~clk;

endmodule
