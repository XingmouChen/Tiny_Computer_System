module hsyncModule(clk_25mhz, hsync_pulse, hsync, x); 

input wire clk_25mhz;
output reg hsync_pulse, hsync;
output reg [9:0] x;

parameter a = 96;
parameter E = 800;

initial begin
	hsync_pulse <= 0;
	hsync <= 0;
	x <= 0;
end

always @ (posedge clk_25mhz) begin
	x <= x+10'd1;
	hsync_pulse <= 0;
	
	if (x == a-1) begin
		hsync <= 1;
	end
	else if (x == E-1) begin
		hsync_pulse <= 1;
		hsync <= 0;
		x <= 0;
	end
	
end

endmodule
