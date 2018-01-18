`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:33:16 07/19/2016 
// Design Name: 
// Module Name:    Cursor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Cursor(
	input wire clk,
	input wire rst,
	input wire ps2_read_ready,
	input wire [7:0] data_in,
	
	output wire ps2_read_done,
	output reg char_vram_wea,
	output reg [12:0] addr,
	output reg [7:0] ascii_2_charVram
    );

reg [6:0] x;
reg [5:0] y;

always @(posedge clk) begin
	if (rst) begin
		x <= 0;
		y <= 0;
		addr <= 0;
		char_vram_wea <= 0;
	end
	else begin
		if (ps2_read_ready) begin
			char_vram_wea <= 1;
			addr <= {y, x};
			ascii_2_charVram <= data_in
			ps2_read_done <= 1;
		end
		else begin
			char_vram_wea <= 0;
		end
	end
end

endmodule
