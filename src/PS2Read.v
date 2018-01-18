`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:47:37 11/06/2015 
// Design Name: 
// Module Name:    PS2Read 
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
module PS2Read(
	input clk, input rst, input ps2Clk, input ps2Dat,
	output reg [7:0] data, output reg ps2Int
);

	reg [9:0] byteBuf;
	reg [3:0] count;
	reg [2:0] ps2ClkRecord;
	reg [19:0] idleCounter;

	always @ (posedge clk)
	begin
		if(rst)
		begin
			count <= 0;
			ps2ClkRecord <= 3'b111;
			ps2Int <= 0;
			idleCounter <= 20'h0;
		end
		else
		begin
			ps2ClkRecord <= {ps2ClkRecord[1:0], ps2Clk};
			if({ps2ClkRecord, ps2Clk} == 4'b1100)//Falling edge
			begin
				if(count == 4'hA)
				begin
					if(~byteBuf[0] && ps2Dat)
					begin
						data <= byteBuf[8:1];
						ps2Int <= 1;
					end
					count <= 0;
				end
				else
				begin
					ps2Int <= 0;
					byteBuf <= {ps2Dat, byteBuf[9:1]};
					count <= count + 4'b1;
				end
			end
			else
			begin
				if(&idleCounter)
				begin
					count <= 4'h0;
					ps2ClkRecord <= 3'b111;
					ps2Int <= 0;
				end
				idleCounter <= idleCounter + 1'b1;
			end
		end
	end

endmodule
