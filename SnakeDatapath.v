`include "ram.v"
module datapath(
	input clk,
	input rst,
	input lock,
	input check_inc,

	input ld_head,
	input ld_q_def,
	input inc_address,
	input rst_address,
	input draw_q,
	input [3:0] cnt_status,
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
	
	output reg inc_length
);
	localparam defPrev = 16'b1000_0000_0000_0000;



	reg [15:0] prevDrawValue;
	wire [14:0] ram_out;
	reg [14:0] ram_in;
	reg ram_wren;
	reg [10:0] address;
	reg [14:0] curr, prev;
	reg [7:0] food_x, temp_food_x, x_counter;
	reg [6:0] food_y, temp_food_y, y_counter;
	reg anicond;
	reg [14:0] head;

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
			food_x <= 8'd60;
			food_y <= 7'd56;
			isDead <= 0;
			temp_food_x <= 0;
			temp_food_y <= 0;
			x_counter <= 0;
			y_counter <= 0;
			anicond <= 0;
			prevDrawValue <= defPrev;
		end
		else begin
			if (ld_head)
				head <= {def_x, def_y};
			if (update_head)
			begin
				if (dir[2]) begin
					if (dir[1])
					begin
						head[6:0] <= head[6:0] + 7'd4;
						if (head[6:0] > 116)
							head[6:0] <= 0;
					end
					else
					begin
						head[6:0] <= head[6:0] - 7'd4;
						if (head[6:0] > 7'd116)
							head[6:0] <= 7'd116;
						
					end
				end
				else if (!dir[2]) begin
					if (dir[0])
					begin
						head[14:7] <= head[14:7] + 8'd4;
						if (head[14:7] > 8'd156)
							head[14:7] <= 0;
					end
					else
					begin
						head[14:7] <= head[14:7] - 8'd4;
						if (head[14:7] > 8'd156)
							head[14:7] <= 8'd156;
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
			if (address != 0 && ram_out == head && draw_q)
				isDead <= 1;
			x_counter <= x_counter + 1;
			y_counter <= y_counter + 1;
			if (x_counter > 8'd156)
				x_counter <= 0;

			if (y_counter > 7'd120)
				y_counter <= 0;

			if (lock)
			begin
				temp_food_x <= x_counter - x_counter%4;
				temp_food_y <= y_counter - y_counter%4;
			end
			if (inc_length)
			begin
				food_x <= temp_food_x;
				food_y <= temp_food_y;
			end
			if (head == foodTotal)
				anicond <= 1;
			if (food_en)
				anicond <= 0;
		end
	end
	
	always @(*) begin
		ram_in = 0;
		ram_wren = 0;
		plotEn = 0;
		x = 0;
		y = 0;
		inc_length = 0;


		if (ld_q_def)
		begin
			ram_in = {def_x, def_y + address[6:0] + address[6:0] + address[6:0] + address[6:0]};
			ram_wren = 1;
		end
		if (draw_q)
		begin
			if (anicond && address == 0)
			begin
				x= ram_out[14:7] 
			end
			else
			begin
				x = ram_out[14:7] + cnt_status/4;
				y = ram_out[6:0] + cnt_status%4;
			end
			plotEn = 1;
			
		end
		if (check_inc)
		begin
			inc_length = foodTotal == head;
		end
		if (draw_curr)
		begin

			plotEn = 1;
			x = curr[14:7] + cnt_status/4;
			y = curr[6:0] + cnt_status%4;
		end
		if (ld_prev_into_q)
		begin
			ram_wren = 1;
			ram_in = prev;
		end
		if (food_en)
		begin
			plotEn = 1;
			if (
				cnt_status != 3'd0 ||
				cnt_status != 3'd3 ||
				cnt_status != 3'd12 ||
				cnt_status != 3'd15 
			)
			begin
				x = food_x + cnt_status/4;
				y = food_y + cnt_status%4;
			end
		end
		
	end
endmodule 