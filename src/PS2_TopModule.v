`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:53:02 07/17/2016 
// Design Name: 
// Module Name:    PS2_TopModule 
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
module PS2_TopModule(
	input clk,
	input rst,	
	input ps2_clk,	
	input ps2_data,

	output wire ps2_ready,
	output wire [7:0] ascii
    );

wire [9:0] data;
wire [7:0] data_ascii;
wire ready, ps2_ready1;
reg [31:0] count;

PS2_Keyboard
PS2_1(.clk(clk), .rst(rst), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .data_out(data), .ready(ready)); //key_done, data_byte

Scan_Code_ASCII
PS2_2(.clk(clk), .data(data), .data_out(data_ascii), .ps2_ready(ps2_ready1));

assign ascii = data_ascii;
assign ps2_ready = ready & !data[8];

endmodule
