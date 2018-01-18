`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:53 09/14/2016 
// Design Name: 
// Module Name:    ps2_buf 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ps2_buf(
	input wire clk,
	input wire ps2_write,
	input wire [7:0] ps2_ascii,
	input wire cpu_read,
	
	output reg [7:0] char,
	output reg [1:0] state,
	output reg [31:0] ps2_counter
    );

parameter ST_INIT = 2'b00;
parameter ST_FEED = 2'b01;
parameter ST_SPIT = 2'b10;

initial begin
	state = ST_INIT;
	ps2_counter <= 0;
end

//states transformation
	always @(posedge clk) begin
		case (state)
			ST_INIT: begin
				state <= ST_FEED;
			end
			ST_FEED: begin
				if (ps2_write) begin
					state <= ST_SPIT;
				end
				else begin
					state <= ST_FEED;
				end
			end
			ST_SPIT: begin
				if (cpu_read) begin
					state <= ST_FEED;
				end
				else begin
					state <= ST_SPIT;
				end
			end
		endcase
	end
	
	always @* begin
		if (state == ST_SPIT)
			char <= ps2_ascii;
		else
			char <= 0;
	end

endmodule
