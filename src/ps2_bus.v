`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:19 07/20/2016 
// Design Name: 
// Module Name:    ps2_bus 
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
module ps2_bus(
	input wire [31:0] addr_bus,
	input wire [31:0] cpu_data2bus,
	input wire mem_w,
	
	input wire ps2_ready,
	input wire [7:0] ps2_data,
	
	
	output reg [12:0] addr_2_charvram = 0,
	output reg [7:0] data_2_charvram = 0,
	output reg wea_2_charvram = 0
    );
	
always @* begin
	if (addr_bus[31:28] == 4'hd) begin
		if (mem_w) begin
			wea_2_charvram <= 1;
			addr_2_charvram <= cpu_data2bus[20:8];
			data_2_charvram <= cpu_data2bus[7:0];
		end
		else if (ps2_ready) begin
			wea_2_charvram <= 0;
			cpu_data4bus <= {24'h000000, ps2_data};
		end
		else begin
			wea_2_charvram <= 0;
			cpu_data4bus <= 0;
		end
	end
	else begin
		wea_2_charvram <= 0;
		addr_2_charvram <= 0;
		data_2_charvram <= 0;
	end
end

endmodule
