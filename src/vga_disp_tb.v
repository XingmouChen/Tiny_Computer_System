`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:00:39 07/18/2016
// Design Name:   vga_display
// Module Name:   D:/Study/ZJU Courses/Computer Organization/Project/console/vga_disp_tb.v
// Project Name:  console
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga_display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vga_disp_tb;

	// Inputs
	reg clk_25mhz;

	// Outputs
	wire hsync;
	wire vsync;
	wire isDispRGB;
	wire dispPulse;
	wire [9:0] x;
	wire [9:0] y;

	// Instantiate the Unit Under Test (UUT)
	vga_display uut (
		.clk_25mhz(clk_25mhz), 
		.hsync(hsync), 
		.vsync(vsync), 
		.isDispRGB(isDispRGB), 
		.dispPulse(dispPulse), 
		.x(x), 
		.y(y)
	);

	initial begin
		// Initialize Inputs
		clk_25mhz = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever #20 clk_25mhz = ~clk_25mhz;
	end
      
endmodule

