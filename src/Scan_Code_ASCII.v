`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name:    Scan_Code_ASCII 
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
module Scan_Code_ASCII(
	input clk,
    input [9:0] data,
    output [7:0] data_out,
	output reg ps2_ready
    );

    reg [7:0] data_ascii;

    parameter Scan_Space = 8'h29;
    parameter Scan_Enter = 8'h5A;
    parameter Scan_Back = 8'h66;
    parameter Scan_Esc = 8'h76;
    parameter Scan_0 = 8'h45;
    parameter Scan_1 = 8'h16;
    parameter Scan_2 = 8'h1E;
    parameter Scan_3 = 8'h26;
    parameter Scan_4 = 8'h25;
    parameter Scan_5 = 8'h2E;
    parameter Scan_6 = 8'h36;
    parameter Scan_7 = 8'h3D;
    parameter Scan_8 = 8'h3E;
    parameter Scan_9 = 8'h46;
    parameter Scan_A = 8'h1C;
    parameter Scan_B = 8'h32;
    parameter Scan_C = 8'h21;
    parameter Scan_D = 8'h23;
    parameter Scan_E = 8'h24;
    parameter Scan_F = 8'h2B;
    parameter Scan_G = 8'h34;
    parameter Scan_H = 8'h33;
    parameter Scan_I = 8'h43;
    parameter Scan_J = 8'h3B;
    parameter Scan_K = 8'h42;
    parameter Scan_L = 8'h4B;
    parameter Scan_M = 8'h3A;
    parameter Scan_N = 8'h31;
    parameter Scan_O = 8'h44;
    parameter Scan_P = 8'h4D;
    parameter Scan_Q = 8'h15;
    parameter Scan_R = 8'h2D;
    parameter Scan_S = 8'h1B;
    parameter Scan_T = 8'h2C;
    parameter Scan_U = 8'h3C;
    parameter Scan_V = 8'h2A;
    parameter Scan_W = 8'h1D;
    parameter Scan_X = 8'h22;
    parameter Scan_Y = 8'h35;
    parameter Scan_Z = 8'h1A;
    parameter Scan_Right = 8'h74;
    parameter Scan_Left = 8'h6B;
    parameter Scan_Up = 8'h75;
    parameter Scan_Down = 8'h72;

    always @(posedge clk) begin
		ps2_ready <= 0;
        if(!data[9] & !data[8]) begin
            case (data[7:0])
                Scan_Space : begin ps2_ready <= 1; data_ascii <= 8'h20; end 
                Scan_Enter : begin ps2_ready <= 1; data_ascii <= 8'h0D; end
                Scan_Back : begin ps2_ready <= 1; data_ascii <= 8'h08; end
                Scan_Esc : begin ps2_ready <= 1; data_ascii <= 8'h1B; end
                Scan_0 : begin ps2_ready <= 1; data_ascii <= 8'h30; end  
                Scan_1 : begin ps2_ready <= 1; data_ascii <= 8'h31; end 
                Scan_2 : begin ps2_ready <= 1; data_ascii <= 8'h32; end 
                Scan_3 : begin ps2_ready <= 1; data_ascii <= 8'h33; end 
                Scan_4 : begin ps2_ready <= 1; data_ascii <= 8'h34; end 
                Scan_5 : begin ps2_ready <= 1; data_ascii <= 8'h35; end 
                Scan_6 : begin ps2_ready <= 1; data_ascii <= 8'h36; end 
                Scan_7 : begin ps2_ready <= 1; data_ascii <= 8'h37; end 
                Scan_8 : begin ps2_ready <= 1; data_ascii <= 8'h38; end 
                Scan_9 : begin ps2_ready <= 1; data_ascii <= 8'h39; end 
                Scan_A : begin ps2_ready <= 1; data_ascii <= 8'h41; end 
                Scan_B : begin ps2_ready <= 1; data_ascii <= 8'h42; end 
                Scan_C : begin ps2_ready <= 1; data_ascii <= 8'h43; end 
                Scan_D : begin ps2_ready <= 1; data_ascii <= 8'h44; end 
                Scan_E : begin ps2_ready <= 1; data_ascii <= 8'h45; end 
                Scan_F : begin ps2_ready <= 1; data_ascii <= 8'h46; end 
                Scan_G : begin ps2_ready <= 1; data_ascii <= 8'h47; end 
                Scan_H : begin ps2_ready <= 1; data_ascii <= 8'h48; end 
                Scan_I : begin ps2_ready <= 1; data_ascii <= 8'h49; end 
                Scan_J : begin ps2_ready <= 1; data_ascii <= 8'h4A; end 
                Scan_K : begin ps2_ready <= 1; data_ascii <= 8'h4B; end 
                Scan_L : begin ps2_ready <= 1; data_ascii <= 8'h4C; end 
                Scan_M : begin ps2_ready <= 1; data_ascii <= 8'h4D; end 
                Scan_N : begin ps2_ready <= 1; data_ascii <= 8'h4E; end 
                Scan_O : begin ps2_ready <= 1; data_ascii <= 8'h4F; end 
                Scan_P : begin ps2_ready <= 1; data_ascii <= 8'h50; end 
                Scan_Q : begin ps2_ready <= 1; data_ascii <= 8'h51; end 
                Scan_R : begin ps2_ready <= 1; data_ascii <= 8'h52; end 
                Scan_S : begin ps2_ready <= 1; data_ascii <= 8'h53; end 
                Scan_T : begin ps2_ready <= 1; data_ascii <= 8'h54; end 
                Scan_U : begin ps2_ready <= 1; data_ascii <= 8'h55; end 
                Scan_V : begin ps2_ready <= 1; data_ascii <= 8'h56; end 
                Scan_W : begin ps2_ready <= 1; data_ascii <= 8'h57; end 
                Scan_X : begin ps2_ready <= 1; data_ascii <= 8'h58; end 
                Scan_Y : begin ps2_ready <= 1; data_ascii <= 8'h59; end 
                Scan_Z : begin ps2_ready <= 1; data_ascii <= 8'h5A; end 
                default : begin ps2_ready <= 0;  data_ascii <= 8'h00; end
            endcase
        end 
		else if(data[9] & !data[8]) begin
            case (data[7:0])
                Scan_Right : begin ps2_ready <= 1; data_ascii <= 8'h1C; end
                Scan_Left : begin ps2_ready <= 1; data_ascii <= 8'h1D; end
                Scan_Up : begin ps2_ready <= 1; data_ascii <= 8'h1E; end
                Scan_Down : begin ps2_ready <= 1; data_ascii <= 8'h1F; end
                default : begin ps2_ready <= 0; data_ascii <= 8'h00; end
            endcase
        end 
		else begin
			data_ascii <= data_ascii;
			ps2_ready <= 0;
		end
    end

    assign data_out = data_ascii;

endmodule
