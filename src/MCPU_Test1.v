// Verilog test fixture created from schematic E:\programming\Xilinx\Computer Organization\Experiment_11\OwnMCPU\MCPU.sch - Wed May 25 19:40:42 2016

`timescale 1ns / 1ps

module MEMORY (
				input clk,
				input wire [31:0] addr, //memory addr
				input wire [31:0] dataIn, //input date to memory
				input wire write, //write enable
				output reg [31:0] dataOut); //output data from memory
				 
	reg [31:0] mem [0:199]; //the memory cells

	initial begin //word address
		mem[0] = 32'h00008024;
		mem[1] = 32'h00008824;
		mem[2] = 32'h2017031C;
		mem[3] = 32'h8EE80000;
		mem[4] = 32'h1100FFFE;
		mem[5] = 32'h00000000;
		mem[6] = 32'h00112020;
		mem[7] = 32'h20050006;
		mem[8] = 32'h0C000013;
		mem[9] = 32'h00000000;
		mem[10] = 32'h0050C825;
		mem[11] = 32'h00192020;
		mem[12] = 32'h20050008;
		mem[13] = 32'h0C000013;
		mem[14] = 32'h00000000;
		mem[15] = 32'h0048C825;
		mem[16] = 32'hAEF90000;
		mem[17] = 32'h0C00001A;
		mem[18] = 32'h00000000;
		mem[19] = 32'h00842020;
		mem[20] = 32'h20A5FFFF;
		mem[21] = 32'h14A0FFFD;
		mem[22] = 32'h00000000;
		mem[23] = 32'h00041020;
		mem[24] = 32'h03E00008;
		mem[25] = 32'h00000000;
		mem[26] = 32'h2009004F;
		mem[27] = 32'h12090004;
		mem[28] = 32'h00000000;
		mem[29] = 32'h22100001;
		mem[30] = 32'h08000003;
		mem[31] = 32'h00000000;
		mem[32] = 32'h2009003B;
		mem[33] = 32'h12290005;
		mem[34] = 32'h00000000;
		mem[35] = 32'h22310001;
		mem[36] = 32'h00008020;
		mem[37] = 32'h08000003;
		mem[38] = 32'h00000000;
		mem[39] = 32'h00008020;
		mem[40] = 32'h00008820;
		mem[41] = 32'h08000003;
		mem[42] = 32'h00000000;
		
		//read from keyboard
		mem[199] = 32'hffffffff;
	end

	reg [31:0] d[0:3]; //bus linear addr for peripheral devices

	//write
	always @(posedge clk) begin
		if (write) begin
			case(addr)
				32'hF000_0000: d[0] = dataIn; //seg7
				32'hF000_0004: d[1] = dataIn;
				32'hE000_0000: d[2] = dataIn; //led
				32'hE000_0004: d[3] = dataIn;
			endcase
		end
	end

	//read
	always @* begin
		case(addr)
			32'hF000_0000: dataOut = d[0];
			32'hF000_0004: dataOut = d[1];
			32'hE000_0000: dataOut = d[2];
			32'hE000_0004: dataOut = d[3];
			default: dataOut = mem[addr[15:2]];
		endcase
	end	

endmodule

//-----------------------------------------------------------------------------

module MCPU_MCPU_sch_tb();

// Inputs
   reg reset;
   reg clk;
   reg MIO_ready;
   reg INT;
   wire [31:0] Data_in;

// Output
   wire [4:0] state;
   wire [31:0] Inst_out;
   wire [31:0] Data_out;
   wire [31:0] Addr_out;  
   wire [31:0] PC_out;
   wire mem_w;
   wire CPU_MIO;

// Instantiate the UUT
   Multi_CPU UUT (
		.state(state), 
		.inst_out(Inst_out), 
		.Data_out(Data_out), 
		.Addr_out(Addr_out), 
		.reset(reset), 
		.clk(clk), 
		.MIO_ready(MIO_ready), 
		.mem_w(mem_w), 
		.PC_out(PC_out), 
		.CPU_MIO(CPU_MIO), 
		.INT(INT), 
		.Data_in(Data_in)
   );
	
	MEMORY mmr(
		.clk(~clk),
		.addr(Addr_out),
		.dataIn(Data_out),
		.write(mem_w),
		.dataOut(Data_in)
	);
	
// Initialize Inputs

	initial begin	
		reset = 1'b1;
		clk = 1'b1;
		MIO_ready = 1'b1;
		INT = 1'b0;
		
		//Wait for global reset settle down
		#100;
		
		reset = 1'b0;
	end
	
	//generate clk signal
	always @* #50 clk <= ~clk;
endmodule
