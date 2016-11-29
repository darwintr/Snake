`include "SnakeRam/ram_with_neg1.v"
module datapath(
	input clk,
	input rst,
	input lock,
	input check_inc,
    input [2:0] colour_in,
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
	input reset_ram,
	
	output reg isDead,
	output reg plotEn,
	output reg [7:0] x,
	output reg [6:0] y,
	output reg [2:0] colour_out,
	output reg inc_length
);
	
	wire [15:0] ram_out;

	reg [15:0] ram_in;
	reg ram_wren;
	reg [10:0] address;
	reg [15:0] curr, prev;
	reg [7:0] food_x, temp_food_x, x_counter;
	reg [6:0] food_y, temp_food_y, y_counter;
	reg anicond;
	reg [14:0] head;

	ram_with_neg1 r0(
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
			food_x <= 8'd30;
			food_y <= 7'd26;
			isDead <= 0;
			temp_food_x <= 0;
			temp_food_y <= 0;
			x_counter <= 0;
			y_counter <= 0;
			anicond <= 0;
		end
		else begin
			if (address > 2048)
				address <= 0;

			if (ld_head)
				head <= {def_x, def_y};
			if (update_head)
			begin
				if (dir[2]) begin
					if (dir[1])
					begin
						head[6:0] <= head[6:0] + 7'd4;
						if (head[6:0] > 116)
							isDead <= 1;
					end
					else
					begin
						head[6:0] <= head[6:0] - 7'd4;
						if (head[6:0] > 7'd116)
							isDead <= 1;
						
					end
				end
				else if (!dir[2]) begin
					if (dir[0])
					begin
						head[14:7] <= head[14:7] + 8'd4;
						if (head[14:7] > 8'd156)
							isDead <= 1;
					end
					else
					begin
						head[14:7] <= head[14:7] - 8'd4;
						if (head[14:7] > 8'd156)
							isDead <= 1;
					end
				end
			end
			if (reset_ram)
			begin
				isDead <= 0;
			end

			if (inc_address)
				address <= address + 1;
			if (rst_address)
				address <= 0;
			if (ld_head_into_prev)
				prev <= {1'b0, head};
			if (ld_q_into_curr)
				curr <= ram_out;
			if (ld_curr_into_prev)
				prev <= curr;
			if (address != 0 && ram_out == head && draw_q)
			begin
				isDead <= 1;
			end
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

	
	wire bodyAniSquares = cnt_status == 5 || cnt_status == 6 || cnt_status == 9 || cnt_status == 10;

	reg [2:0] remain;
	reg remainCounter; 
	always @(posedge clk, negedge rst)
	begin
		if (!rst || bodyAniSquares || remain[0])
			remainCounter <= 0;
		else
			remainCounter <= remainCounter + 1;
	end

	always @(*) begin
		remain = 3'b0;
		if (address != 0)
		begin
			if (ram_out[14:7] > curr[14:7])
			begin
				remain[0] = cnt_status == 4 || cnt_status == 8;
				remain[2:1] = 2'b00;
			end
			else if (ram_out[14:7] < curr[14:7])
			begin
				remain[0] = cnt_status == 7 || cnt_status == 11;
				remain[2:1] = 2'b01;
			end
			else if (ram_out[6:0] > curr[6:0])
			begin
				remain[0] = cnt_status == 1 || cnt_status == 2;
				remain[2:1] = 2'b10;
			end
			else if (ram_out[6:0] < curr[6:0])
			begin
				remain[0] = cnt_status == 13 || cnt_status == 14;
				remain[2:1] = 2'b11;
			end

		end
	end
	localparam REMAIN0 = 2'b00, REMAIN1 = 2'b01, REMAIN2 = 2'b10, REMAIN3 = 2'b11;


	always @(*) begin
		ram_in = 0;
		ram_wren = 0;
		plotEn = 0;
		x = 0;
		y = 0;
		inc_length = 0;
		colour_out = 0;

		if (ld_q_def)
		begin
			ram_in = {1'b0, def_x, def_y + address[6:0] + address[6:0] + address[6:0] + address[6:0]};
			ram_wren = 1;
		end
		if (draw_q)
		begin

			if (anicond && address == 0)
			begin
			 	x = ram_out[14:7] + cnt_status%4;
			 	if (cnt_status == 1 || cnt_status == 4 || cnt_status == 5)
					y = ram_out[6:0] + cnt_status/4 - 1;
				else if (cnt_status == 8 || cnt_status == 9 || cnt_status == 13)
					y = ram_out[6:0] + cnt_status/4 + 1;
				else
					y = ram_out[6:0] + cnt_status/4;
				if (!(cnt_status == 0 || cnt_status == 3 || cnt_status == 12 || cnt_status == 15))
					plotEn = 1;
				colour_out = cnt_status == 3'd5 ? 3'b100 : 3'b010;
			end
			else
			begin
				if (bodyAniSquares || remain[0])
				begin
					x = ram_out[14:7] + cnt_status%4;
					y = ram_out[6:0] + cnt_status/4;
					if (!(cnt_status == 0 || cnt_status == 3 || cnt_status == 12 || cnt_status == 15))
						plotEn = 1;
					colour_out = 3'b010;
				end
				else if (address != 0) begin
					case (remain[2:1])
						REMAIN0 : begin
							x = ram_out[14:7] - 8'd1;
							y = remainCounter ? ram_out[6:0] + 7'd1 : ram_out[6:0] + 7'd2;
						end 
						REMAIN1 : begin
							x = ram_out[14:7] + 8'd4;
							y = remainCounter ? ram_out[6:0] + 7'd1 : ram_out[6:0] + 7'd2;
						end
						REMAIN2 : begin
							x = remainCounter ? ram_out[14:7] + 8'd1 : ram_out[14:7] + 8'd2;
							y = ram_out[6:0] - 7'd1;
						end
						REMAIN3 : begin
							x = remainCounter ? ram_out[14:7] + 8'd1 : ram_out[14:7] + 8'd2;
							y = ram_out[6:0] + 7'd4;
						end
					endcase
					plotEn = 1;
				end
			end
			
			
		end
		if (check_inc)
		begin
			inc_length = foodTotal == head;
		end
		if (draw_curr)
		begin
			if (curr[15] != 1)
				plotEn = 1;
			x = curr[14:7] + cnt_status/4;
			y = curr[6:0] + cnt_status%4;
		end
		if (ld_prev_into_q)
		begin
			ram_wren = 1;
			ram_in = {1'b0, prev[14:0]};
		end
		if (food_en)
		begin
			if (cnt_status == 4 || cnt_status == 5 || cnt_status == 8 || cnt_status == 9)
				plotEn = 1;
		
			x = food_x + cnt_status%4;
			y = food_y + cnt_status/4;
			colour_out = 3'b001;
		end
		if (reset_ram)
		begin
			ram_wren = 1;
			ram_in = 16'b1000_0000_0000_0000;
		end
	end
endmodule 
