`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:12:42 07/18/2016
// Design Name:   VGA_Physics_Test
// Module Name:   D:/Study/ZJU Courses/Computer Organization/Project/console/tb.v
// Project Name:  console
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: VGA_Physics_Test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg CLK_100MHz;
	reg ps2_clk;
	reg ps2_data;

	// Outputs
	wire HSYNC;
	wire VSYNC;
	wire [3:0] Red;
	wire [3:0] Green;
	wire [3:0] Blue;
	wire Buzzer;

	// Instantiate the Unit Under Test (UUT)
	VGA_Physics_Test uut (
		.CLK_100MHz(CLK_100MHz), 
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.HSYNC(HSYNC), 
		.VSYNC(VSYNC), 
		.Red(Red), 
		.Green(Green), 
		.Blue(Blue), 
		.Buzzer(Buzzer)
	);

	initial begin
		// Initialize Inputs
		CLK_100MHz = 0;
		ps2_clk = 0;
		ps2_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever #20 CLK_100MHz = ~CLK_100MHz;
	end
      
endmodule

