`include "ram.v"
module datapath(
	input waiting,
	input clk,
	input rst,

	input ld_head,
	input ld_q_def,
	input inc_address,
	input rst_address,
	input draw_q,
	input [1:0] cnt_status,
	input update_head,
	input ld_head_into_prev,
	input ld_q_into_curr,
	input ld_prev_into_q,
	input ld_curr_into_prev,
	input draw_curr,
	input food_en,
	input [2:0] dir,

	
	output reg isDead,
	output reg plotEn,
	output reg [7:0] x,
	output reg [6:0] y,
	output reg [14:0] head,
	output reg [10:0] length
);
	wire [14:0] ram_out;
	reg [14:0] ram_in;
	reg ram_wren;
	reg [10:0] address;
	reg [14:0] curr, prev;
	reg [7:0] food_x;
	reg [6:0] food_y;
	ram r0(
		.address(address),
		.clock(clk),
		.data(ram_in),
		.wren(ram_wren),
		.q(ram_out)
	);

	wire [7:0] def_x = 8'd60;
	wire [6:0] def_y = 7'd60;
	
	wire [14:0] foodTotal = {food_x, food_y};

	always @(posedge clk, negedge rst) begin
		if (!rst) begin
			address <= 0;
			curr <= 0;
			prev <= 0;
			head <= 0;
			food_x <= 8'd32;
			food_y <= 7'd32;
			length <= 11'd6;
		end
		else begin
			if (ram_out == head && address != 0)
			begin
				isDead <= 1;
			end
			else
			begin
				isDead <= 0;
			end
			if (ld_head)
				head <= {def_x, def_y};
			if (update_head)
			begin
				if (dir[2]) begin
					if (dir[1])
					begin
						head[6:0] <= head[6:0] + 7'd2;
						if (head[6:0] > 120)
							head[6:0] <= 0;
					end
					else
					begin
						head[6:0] <= head[6:0] - 7'd2;
						if (head[6:0] > 7'd120)
							head[6:0] <= 7'd118;
						
					end
				end
				else if (!dir[2]) begin
					if (dir[0])
					begin
						head[14:7] <= head[14:7] + 8'd2;
						if (head[14:7] > 8'd160)
							head[14:7] <= 0;
					end
					else
					begin
						head[14:7] <= head[14:7] - 8'd2;
						if (head[14:7] > 8'd160)
							head[14:7] <= 8'd158;
					end
				end
			end
			if (inc_address)
				address <= address + 1;
			if (rst_address)
				address <= 0;
			if (ld_head_into_prev)
				prev <= head;
			if (ld_q_into_curr)
				curr <= ram_out;
			if (ld_curr_into_prev)
				prev <= curr;
			if (waiting)
				if (head == foodTotal)
					length <= length + 11'd1;
			
		end
	end

	always @(*) begin
		ram_in = 0;
		ram_wren = 0;
		
		plotEn = 0;
		x = 0;
		y = 0;
		if (ld_q_def)
		begin
			ram_in = {def_x, def_y + address[6:0]};
			ram_wren = 1;
		end
		if (draw_q)
		begin
			plotEn = 1;
			x = ram_out[14:7] + cnt_status[1];
			y = ram_out[6:0] + cnt_status[0];
		end
		if (draw_curr)
		begin
			plotEn = 1;
			x = curr[14:7] + cnt_status[1];
			y = curr[6:0] + cnt_status[0];
		end
		if (ld_prev_into_q)
		begin
			ram_wren = 1;
			ram_in = prev;
		end
		if (food_en)
		begin
			plotEn = 1;
			x = food_x + cnt_status[1];
			y = food_y + cnt_status[0];
		end
	end
endmodule 