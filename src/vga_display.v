module vga_display(
	input wire clk_25mhz,
	
	output wire hsync,
	output wire vsync,
	output reg isDispRGB,
	output reg dispPulse,
	output reg [9:0] x,
	output reg [9:0] y,
	output reg [7:0] LED
);


parameter x_begin = 10'd144;
parameter x_end = 10'd784;
parameter y_begin = 10'd35;
parameter y_end = 10'd515;

initial begin
	isDispRGB <= 0;
	dispPulse <= 0;
end

wire[9:0] xReal, yReal;
wire hsync_pulse;

hsyncModule H(clk_25mhz, hsync_pulse, hsync, xReal);
vsyncModule V(hsync_pulse, vsync, yReal);

always @ (xReal, yReal) begin
	x <= xReal-x_begin-10'd1;
	y <= yReal-y_begin-10'd1;
	
	if (xReal>x_begin && xReal<=x_end && yReal>y_begin && yReal<=y_end) begin
		dispPulse <= ~dispPulse;
		isDispRGB <= 1;
	end
	else begin
		dispPulse <= dispPulse;
		isDispRGB <= 0;
	end
end

endmodule
