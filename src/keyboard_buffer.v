`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:25:48 07/20/2016 
// Design Name: 
// Module Name:    keyboard_buffer 
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
module keyboard_buffer(
	input wire clk,
	input wire buf_slt,
	input wire [5:0] cpu_addr,
	input wire wea,
	input wire [5:0] ps2_addr,
	input wire [7:0] ps2_data,
	
	output wire [7:0] kb_buf_dataout
    );

reg [5:0] addr0;
reg [5:0] addr1;
reg [7:0] data_in0;
reg [7:0] data_in1;
wire [7:0] data_out0;
wire [7:0] data_out1;

always @* begin
	case (buf_slt)
		1'b0: begin
			addr0 <= ps2_addr;
			data_in0 <= ps2_data;
			addr1 <= cpu_addr;
			data_in1 <= 0;
		end
		1'b1: begin
			addr0 <= cpu_addr;
			data_in0 <= 0;
			addr1 <= ps2_addr;
			data_in1 <= ps2_data;
		end
	endcase
end

assign kb_buf_dataout = (buf_slt == 0)? data_out1 : data_out0;

kb_buf
U0(.clka(clk), .wea(~buf_slt & wea), .addra(addr0), .dina(data_in0), .douta(data_out0));

kb_buf
U1(.clka(clk), .wea(buf_slt & wea), .addra(addr1), .dina(data_in1), .douta(data_out1));

endmodule
