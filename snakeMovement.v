
module controlMovement(
	input clk,
	input rst,
	input [2:0] colour_in,
	input [10:0] length, 
	input go,
	//---------------------------
	output reg ld_head,
	output reg ld_q_def,
	output reg inc_address,
	output reg rst_address,
	output reg draw_q,
	output reg [1:0] cnt_status,
	output reg update_head,
	output reg ld_head_into_prev,
	output reg ld_q_into_curr,
	output reg ld_prev_into_q,
	output reg ld_curr_into_prev,
	output reg [2:0] colour_out,
	output reg draw_curr,
	output reg food_en,
	output reg waiting
);	
	
	reg [10:0] counter;
	reg [1:0] drawCounter;
	reg [4:0] curr_state, next_state;
	wire cnt_le_l = counter < length - 1;
	wire draw_le_3 = drawCounter < 3;
	localparam 
		LD_HEAD = 5'd0,
		LD_DEF = 5'd1,
		CLOCK1 = 5'd2,
		INC1 = 5'd3,
		RST1 = 5'd4,
		CLOCK2 = 5'd5,
		DRAW_WHITE = 5'd6,
		INC2 = 5'd7,
		RST2 = 5'd8,
		UPDATE_HEAD = 5'd9,
		LD_HEAD_PREV = 5'd10,
		LD_Q_CURR = 5'd11,
		LD_PREV_Q = 5'd12,
		CLOCK3 = 5'd13,
		LD_CURR_PREV = 5'd14,
		CLOCK4 = 5'd15,
		RST3 = 5'd16,
		DRAW_CURR = 5'd17,
		WAIT = 5'd18,
		DRAW_FOOD = 5'd19,
		RST4 = 5'd20;


	always @(*)
	begin: stateTable
		case (curr_state)
			LD_HEAD : next_state = LD_DEF;
			LD_DEF : next_state = CLOCK1;
			CLOCK1 : next_state = INC1;
			INC1: next_state = cnt_le_l ? LD_DEF : RST1;
			RST1: next_state = CLOCK2;
			CLOCK2: next_state = DRAW_WHITE;
			DRAW_WHITE: next_state = draw_le_3 ? DRAW_WHITE : INC2;
			INC2: next_state = cnt_le_l ? CLOCK2 : RST2;
			RST2: next_state = UPDATE_HEAD;
			UPDATE_HEAD: next_state = LD_HEAD_PREV;
			LD_HEAD_PREV: next_state = LD_Q_CURR;
			LD_Q_CURR: next_state = LD_PREV_Q;
			LD_PREV_Q: next_state = CLOCK3;
			CLOCK3: next_state = LD_CURR_PREV;
			LD_CURR_PREV: next_state = cnt_le_l ? CLOCK4 : RST3;
			CLOCK4: next_state = LD_Q_CURR;
			RST3: next_state = WAIT;
			DRAW_FOOD: next_state = draw_le_3 ? DRAW_FOOD : RST1;
			WAIT: next_state = go ? DRAW_CURR : WAIT;
			DRAW_CURR: next_state = draw_le_3 ? DRAW_CURR : RST4;
			RST4: next_state = DRAW_FOOD;
		default: next_state = LD_HEAD;
		endcase
	end
	
	always @(posedge clk, negedge rst) begin
		if (!rst) begin
			// reset
			curr_state <= LD_HEAD;
			counter <= 0;
			drawCounter <= 0;
		end
		else begin
			if (curr_state == RST1 || curr_state == RST2 || curr_state == RST3 || curr_state == RST4)
			begin
				counter <= 0;
				drawCounter <= 0;
			end
			else if (curr_state == INC1 || curr_state == INC2 || curr_state == LD_CURR_PREV)
			begin
				counter <= counter + 1;
			end
			else if (curr_state == DRAW_CURR || curr_state == DRAW_WHITE || curr_state == DRAW_FOOD) 
				drawCounter <= drawCounter + 1;
			curr_state <= next_state;
		end
	end

	always @(*) 
	begin : state_result
		ld_head = 0;
		ld_q_def = 0;
		inc_address = 0;
		rst_address = 0;
		draw_q = 0;
		cnt_status = 2'b0;
		update_head = 0;
		ld_head_into_prev = 0;
		ld_q_into_curr = 0;
		ld_prev_into_q = 0;
		ld_curr_into_prev = 0;
		colour_out = 3'b0;
		draw_curr = 0;
		food_en = 0;
		waiting = 0;
		if (next_state == WAIT)
			waiting = 1;
		case (curr_state)
			LD_HEAD : ld_head = 1;
			LD_DEF : ld_q_def = 1;
			INC1: inc_address = 1;
			RST1: rst_address = 1;
			DRAW_WHITE: begin 
				draw_q = 1;
				cnt_status = drawCounter;
				if (counter == 0) begin
					colour_out = 3'b100;
				end
				else begin
					colour_out = colour_in;
				end
			end
			INC2: inc_address = 1;
			RST2: rst_address = 1;
			UPDATE_HEAD: update_head = 1;
			LD_HEAD_PREV: ld_head_into_prev = 1;
			LD_Q_CURR: ld_q_into_curr = 1;
			LD_PREV_Q: ld_prev_into_q = 1;
			LD_CURR_PREV: begin
				ld_curr_into_prev = 1;
				inc_address = 1;
			end
			RST3: rst_address = 1;
			DRAW_CURR: begin
				draw_curr = 1;
				cnt_status = drawCounter;
			end
			DRAW_FOOD: begin
				food_en = 1;
				
				cnt_status = drawCounter;
				colour_out = 3'b010;
			end
			

		endcase
	end


endmodule

