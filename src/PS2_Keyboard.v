`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:13:00 07/17/2016 
// Design Name: 
// Module Name:    PS2_Keyboard 
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
module PS2_Keyboard(
	input clk,
	input rst,
	input ps2_clk,
	input ps2_data,
	
	output [9:0] data_out,
	output ready
    );

reg ps2_clk_sign0, ps2_clk_sign1, ps2_clk_sign2, ps2_clk_sign3;
wire negedge_ps2_clk;

//The 0011 pattern appears which indicates there is a negedge
//Use a quick clock to resample a slower clock. The pattern 0011 appears for a very short time.
assign negedge_ps2_clk = !ps2_clk_sign0 & !ps2_clk_sign1 & ps2_clk_sign2 & ps2_clk_sign3;
assign data_out = data;
assign ready = key_done;

always @ (posedge clk or posedge rst) begin		//asynchronous reset
	if (rst) begin
		ps2_clk_sign0 <= 1'b0;
		ps2_clk_sign1 <= 1'b0;
		ps2_clk_sign2 <= 1'b0;
		ps2_clk_sign3 <= 1'b0;
	end
	else begin
		ps2_clk_sign0 <= ps2_clk;				//# 1 cycle of clk
		ps2_clk_sign1 <= ps2_clk_sign0;			//# 2 cycle of clk
		ps2_clk_sign2 <= ps2_clk_sign1;			//# 3 cycle of clk
		ps2_clk_sign3 <= ps2_clk_sign2;			//# 4 cycle of clk
	end
end


												//count how many negedges appeared
reg [3:0] cnt;
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		cnt <= 4'd0;
	end
	else if (cnt == 4'd11) begin
		cnt <= 4'd0;
	end
	else if (negedge_ps2_clk) begin
		cnt <= cnt + 1'b1;						//index of low-voltage-level, start from 1
	end
end

reg negedge_ps2_clk_shift;

always @ (posedge clk) begin					//delay for a resolution cycle
	negedge_ps2_clk_shift <= negedge_ps2_clk;
end

reg [7:0] data_in;
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		data_in <= 8'd0;
	end
	else if (negedge_ps2_clk_shift) begin		//why use _shift? to ensure that the low-voltage-level index has been updated
		case (cnt)								//non-data bits are discarded
			4'd2: data_in[0] <= ps2_data;
			4'd3: data_in[1] <= ps2_data;
			4'd4: data_in[2] <= ps2_data;
			4'd5: data_in[3] <= ps2_data;
			4'd6: data_in[4] <= ps2_data;
			4'd7: data_in[5] <= ps2_data;
			4'd8: data_in[6] <= ps2_data;
			4'd9: data_in[7] <= ps2_data;
			default: data_in <= data_in; 
		endcase
	end
	else begin
		data_in <= data_in;
	end
end

reg key_break, key_done, key_expand;
reg [9:0] data;
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		key_break <= 1'b0;
		data <= 1'b0;
		key_done <= 1'b0;
		key_expand <= 1'b0;
	end
	else if (cnt == 4'd11) begin
		if (data_in == 8'hE0) begin						//this byte indicates the key is a expand one
			key_expand <= 1'b1;
			key_done <= 1'b0;
		end
		else if (data_in == 8'hF0) begin				//this byte indicates the break key
			key_break <= 1'b1;
			key_done <= 1'b0;
		end
		else begin
			data <= {key_expand, key_break, data_in};	//data byte
			key_done <= 1'b1;
			key_expand <= 1'b0;
			key_break <= 1'b0;
		end
	end else begin //cnt != 11
		data <= data;
		key_done <= 1'b0;
		key_expand <= key_expand;
		key_break <= key_break;
	end
end

endmodule
