module vsyncModule(hsync_pulse, vsync, y);
input wire hsync_pulse;
output reg vsync;
output reg [9:0] y;

parameter h = 2;
parameter L = 525;

initial begin
	vsync <= 0;
	y <= 0;
end

always @ (posedge hsync_pulse) begin
	y <= y+10'd1;
	if (y == h-1) begin
		vsync <= 1;
	end
	else if (y == L-1) begin
		vsync <= 0;
		y <= 0;
	end
end

endmodule
