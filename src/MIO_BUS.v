`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:14 06/30/2012 
// Design Name: 
// Module Name:    MIO_BUS 
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
module MIO_BUS(		input clk,
					input rst,
					input[3:0]BTN, 					//from buttons
					input[15:0]SW, 					//from switched
					input mem_w, 					//memory write signal
					input[31:0]Cpu_data2bus,		//data from CPU
					input[31:0]addr_bus, 			//addr from cpu
					input[31:0]ram_data_out, 		//from ram data
					input[15:0]led_out,				//from SPIO, led state?
					input[31:0]counter_out,			//from counterX, current counter value 
					input counter0_out,				//from counterX, is counting finished?
					input counter1_out,				//from counterX, is counting finished?
					input counter2_out,				//from counterX, is counting finished?
					
					input wire [7:0] ps2_data,
					
					output reg[31:0]Cpu_data4bus,	//data for CPU
					output reg[31:0]ram_data_in,	//data write into ram
					output reg[9:0]ram_addr,		//ram address to access
					output reg data_ram_we,			//ram write enable
					output reg GPIOf0000000_we,		//led write enable
					output reg GPIOe0000000_we,		//seg7 write enable
					output reg counter_we,			//counter write enable
					output reg[31:0]Peripheral_in,	//data write into peripheral devices, seg7 this case
					
					output reg ps2_done = 0,
					output reg [12:0] addr_2_charvram = 0,
					output reg [7:0] data_2_charvram = 0,
					output reg wea_2_charvram = 0
					);

reg data_ram_rd, GPIOf0000000_rd, GPIOe0000000_rd, counter_rd, rd_charvram;
wire counter_over;

//assign ps2_done = 1;

always @* begin
	//default value
	data_ram_we <= 1'b0;
	data_ram_rd <= 1'b0;
	counter_we <= 1'b0;
	counter_rd <= 1'b0;
	GPIOf0000000_we <= 1'b0;
	GPIOf0000000_rd <= 1'b0;
	GPIOe0000000_we <= 1'b0;
	GPIOe0000000_rd <= 1'b0;

	ram_addr <= 10'd0;
	ram_data_in <= 32'd0;
	Peripheral_in <= 32'd0;
	
	wea_2_charvram <= 0;
	rd_charvram <= 0;
	data_2_charvram <= 0;
	addr_2_charvram <= 0;
	ps2_done <= 0;

	//addr decoder
	case(addr_bus[31:28])
		4'h0: begin	//00000000-00000ffc, actually lower 4KB RAM, 32bit*1024width = 4Bytes * 1K = 4KBytes
			data_ram_we <= mem_w;	
			data_ram_rd <= ~mem_w;
			ram_addr <= addr_bus[11:2]; //word-addressing
			ram_data_in <= Cpu_data2bus;
		end
		4'hc: begin
			ps2_done <= 1;
		end
		4'hd: begin
			wea_2_charvram <= mem_w;
			rd_charvram <= ~mem_w;
			addr_2_charvram <= Cpu_data2bus[20:8];
			data_2_charvram <= Cpu_data2bus[7:0];
		end
		4'he: begin	//seg7 e0000000-efffffff
			GPIOe0000000_we <= mem_w;
			GPIOe0000000_rd <= ~mem_w;
			Peripheral_in <= Cpu_data2bus;
		end
		4'hf: begin //PIO f0000000-ffffffff. f0000000 for led, f0000004 for counter
			if (addr_bus[2] == 1'b1) begin //counter
				counter_we <= mem_w;
				counter_rd <= ~mem_w;
				Peripheral_in <= Cpu_data2bus; //write value into counter
			end
			else begin //led
				GPIOf0000000_we <= mem_w;
				GPIOf0000000_rd <= ~mem_w;
				Peripheral_in <= Cpu_data2bus; //light led
			end
		end
	endcase
end

//reg [31:0] Cpu_data4bus1, Cpu_data4bus2;

//read decoder
always @* begin
	//default value
	Cpu_data4bus <= 32'd0;

	casex({data_ram_rd, GPIOe0000000_rd, counter_rd, GPIOf0000000_rd, rd_charvram})
		5'b1xxxx: begin
			Cpu_data4bus <= ram_data_out;	//read from ram
		end
		5'bx1xxx: begin
			Cpu_data4bus <= counter_out;	//read from counter
		end
		5'bxx1xx: begin
			Cpu_data4bus <= counter_out;	//read from counter
		end
		5'bxxx1x: begin
			Cpu_data4bus <= {counter0_out, counter1_out, counter2_out, led_out[12:0], SW};	//read from mess...
		end
		5'bxxxx1: begin
			Cpu_data4bus <= {24'h000000, ps2_data};
			/*if (ps2_state == 2'b10) begin
				Cpu_data4bus <= {24'h000000, ps2_data};
				ps2_done <= 1'b1;
			end else begin
				Cpu_data4bus <= 32'd0;
				ps2_done <= 0;
			end*/
		end
	endcase
end

/*always @(posedge clk) begin
	if (ps2_state == 2'b10) begin
		Cpu_data4bus2 <= {24'h000000, ps2_data};
		ps2_done <= rd_charvram;
	end
	else begin
		Cpu_data4bus2 <= 0;
		ps2_done <= 0;
	end
end

always @* begin
	if (rd_charvram == 1'b1)
		Cpu_data4bus <= Cpu_data4bus2;
	else
		Cpu_data4bus <= Cpu_data4bus1;
end*/

endmodule
