`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:30:03 07/17/2016 
// Design Name: 
// Module Name:    VGA_Physics_Test 
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
module VGA_Physics_Test(
	input wire CLK_100MHz,
	//input wire ps2_clk,
	//input wire ps2_data,
	input wire [12:0] addr_cpu,
	input wire [7:0] data_cpu,
	input wire wea_cpu,

	output wire HSYNC,
	output wire VSYNC,
	output reg [3:0] Red,
	output reg [3:0] Green,
	output reg [3:0] Blue
    );
	
parameter COLOR_BLACK = {4'h0, 4'h0, 4'h0};
parameter COLOR_WHITE = {4'hf, 4'hf, 4'hf};
parameter COLOR_GREEN = {4'h0, 4'hf, 4'h0};
	
wire isDispRGB, isBlack;
wire [9:0] x, xx, xxx;
wire [9:0] y, yy, yyy;
wire [7:0] ascii, ascii_now;
reg [1:0] count;
wire charDispSignal;
wire [7:0] kb_buf_dataout;

reg buf_slt = 0;
reg charvram_wea = 0;
reg [5:0] addr_now = 6'b1;
reg [6:0] charvram_x = 0;
reg [12:0] addr_4_charvram;

assign Buzzer = 1'b1;
assign xx = x % 8;
assign yy = y % 8;
assign xxx = x/8;
assign yyy = y/8;

//count[1] == clk_25mhz
always @(posedge CLK_100MHz) begin
	count <= count + 1'b1; 
end

vga_display
U1(.clk_25mhz(count[1]), .hsync(HSYNC), .vsync(VSYNC), .isDispRGB(isDispRGB), .x(x), .y(y), .dispPulse(dispPulse));

always @* begin
	if (wea_cpu) begin
		addr_4_charvram <= addr_cpu;
	end
	else begin
		addr_4_charvram <= {yyy[5:0], xxx[6:0]};
	end
end

char_vram
char_vram(.clka(CLK_100MHz), .wea(wea_cpu), .addra(addr_4_charvram), .dina(data_cpu), .douta(ascii_now));

char_module
char_module(.clka(CLK_100MHz), .wea(1'b0), .addra({ascii_now, yy[2:0], xx[2:0]}), .dina(8'h00), .douta(charDispSignal));


always @(x) begin
	if (isDispRGB) begin
		if (charDispSignal) begin
			{Red, Green, Blue} <= COLOR_GREEN;		//frontground color
		end
		else begin
			{Red, Green, Blue} <= COLOR_BLACK;		//background color
		end
	end
	else begin
		{Red, Green, Blue} <= COLOR_BLACK;			//per the protocol
	end
end

/*PS2_TopModule
U2(.clk(CLK_100MHz), .rst(1'b0), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .buf_slt(buf_slt), .ascii(ascii), .buf_addr(buf_addr), .buf_wea(buf_wea));
assign LED = ascii;*/

/*keyboard_buffer 
kb_buf(.clk(CLK_100MHz), .buf_slt(buf_slt), .cpu_addr(addr_now), .wea(buf_wea), .ps2_addr(buf_addr), .ps2_data(ascii), .kb_buf_dataout(kb_buf_dataout));

always @(posedge CLK_100MHz) begin
	if (kb_buf_dataout != 8'b0) begin
		charvram_wea <= 1'b1;
		charvram_x <= charvram_x+1;
		addr_now <= addr_now + 1;
	end
	else begin
		buf_slt <= ~buf_slt;
		charvram_wea <= 1'b0;
		charvram_x <= charvram_x;
		addr_now <= 1;
	end
end*/



//test ascii
/*always @* begin
	if (!charDispSignal || !isDispRGB) begin
		Red <= 4'h0;
		Green <= 4'h0;
		Blue <= 4'h0;
	end
	else begin
		Red <= 4'hf;
		Green <= 4'hf;
		Blue <= 4'hf;
	end
end*/

/*
//char cursor
reg [6:0] char_x = 7'd0; 			//80 characters per row
reg [5:0] char_y = 6'd0;			//60 characters per column

reg [2:0] char_module_x = 3'd0;		//8 bits width per character
reg [2:0] char_module_y = 3'd0;		//8 bits height per character
//reg isStart = 1'b0;

always @(posedge dispPulse) begin
	if (!isStart)
		isStart <= 1'b1;
	else
		isStart <= isStart;
end

always @(dispPulse) begin
	if (isStart) begin
		case (char_module_x)
			3'd7:
				char_module_x <= 3'd0;
			default:
				char_module_x <= char_module_x + 1;
		endcase	
	end
	else begin
		char_module_x <= char_module_x;
	end
end

always @(char_module_x) begin
	if (char_module_x == 3'd0 && isStart) begin
		case (char_x)
			7'd79: char_x <= 7'd0;
			default: char_x <= char_x+1;
		endcase
	end
	else begin
		char_x <= char_x;
	end
end

always @(char_module_y) begin
	if (char_x == 7'd0 && isStart) begin
		case (char_module_y)
			3'd7: char_module_y <= 0;
			default: char_module_y <= char_module_y+1;
		endcase
	end
	else begin
		char_module_y <= char_module_y;
	end
end

always @(char_module_y) begin
	if (char_module_y == 3'd0 && isStart) begin
		case (char_y)
			6'd59: char_y <= 0; 
			default: char_y <= char_y+1;
		endcase
	end
	else begin
		char_y <= char_y;
	end
end

char_module_rom
char_module(.a({8'h21, yy[2:0], xx[2:0]}), .spo(charDispSignal));*/


endmodule
