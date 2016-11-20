
module controlMovement(
	input clk,
	input rst,
	input [2:0] colour_in,
	input [10:0] length, 
	input go,

	//---------------------------
	output reg update_head,
	output reg drawQ,
	output reg ld_head,
	output reg ld_def,
	output reg drawCurr,
	output reg rowNum,
	output reg colNum,
	output reg ld_head_prev,
	output reg ld_q_curr,
	output reg ld_prev_q,
	output reg ld_curr_prev,
	output reg inc_address,
	output reg rst_address,
	output reg [2:0] colour_out
);	
	
	reg [10:0] counter;
	reg [1:0] drawCounter;
	reg [3:0] curr_state, next_state;
	wire cnt_le_l = counter < length - 1;
	wire draw_le_3 = drawCounter < 3;
	localparam 
		LD_HEAD = 4'd0,
		LD_DEF = 4'd1,
		RESET_CNT = 4'd2,
		DRAW_WHITE_ROW = 4'd3,
		WAIT = 4'd5,
		UPDATE_HEAD = 4'd6,
		LD_HEAD_PREV = 4'd7,
		LD_Q_CURR = 4'd8,
		LD_PREV_Q = 4'd9,
		LD_CURR_PREV = 4'd10,
		DRAW_B_ROW = 4'd11,
		INC_CNT = 4'd13;


	always @(*)
	begin: stateTable
		case (curr_state)
			LD_HEAD: next_state = LD_DEF;
			LD_DEF: next_state = cnt_le_l ? LD_DEF : RESET_CNT;
			RESET_CNT: next_state = DRAW_WHITE_ROW;
			DRAW_WHITE_ROW: next_state = draw_le_3 ? DRAW_WHITE_ROW : INC_CNT;
			INC_CNT: next_state = cnt_le_l ? DRAW_WHITE_ROW : WAIT;
			WAIT: next_state = go ? UPDATE_HEAD : WAIT;
			UPDATE_HEAD : next_state = LD_HEAD_PREV;
			LD_HEAD_PREV : next_state = LD_Q_CURR;
			LD_Q_CURR : next_state = LD_PREV_Q;
			LD_PREV_Q : next_state = LD_CURR_PREV;
			LD_CURR_PREV : next_state = cnt_le_l ? LD_Q_CURR : DRAW_B_ROW;
			DRAW_B_ROW : next_state = draw_le_3 ? DRAW_B_ROW : RESET_CNT;
		default : next_state = LD_HEAD;
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
			if (curr_state == RESET_CNT || curr_state == WAIT)
			begin
				counter <= 0;
				drawCounter <= 0;
			end
			
			else if (curr_state == LD_CURR_PREV || curr_state == LD_DEF)
			begin
				counter <= counter + 1;
			end

			else if (curr_state == INC_CNT)
			begin
				counter <= counter + 1;

			end

			else if (curr_state == DRAW_WHITE_ROW || curr_state == DRAW_B_ROW)
			begin
				drawCounter <= drawCounter + 1;
				
			end

			curr_state <= next_state;
		end
	end
	
	always @(*) 
	begin : state_result
		ld_head = 0;
		ld_def = 0;
		drawCurr = 0;
		drawQ = 0;
		update_head = 0;
		ld_head_prev = 0;
		ld_q_curr = 0;
		ld_prev_q = 0;
		ld_curr_prev = 0;
		inc_address = 0;
		colour_out = 0;
		rowNum = 0;
		colNum = 0;
		rst_address = 0;
		case (curr_state)
			LD_HEAD: ld_head = 1;
			LD_DEF:
			begin
				inc_address = 1;
				ld_def = 1;
			end
			DRAW_WHITE_ROW:
			begin
				drawQ = 1;
				colour_out = counter == 0 ? 3'b100 : colour_in;
				colNum = drawCounter[0];
				rowNum = drawCounter[1];
			end
			RESET_CNT:
			begin
				rst_address = 1;
			end
			INC_CNT:
			begin
				inc_address = 1;
			end
			UPDATE_HEAD: begin
				update_head = 1;
				rst_address = 1;
			end
			LD_HEAD_PREV: ld_head_prev = 1;
			LD_Q_CURR: ld_q_curr = 1;
			LD_PREV_Q: ld_prev_q = 1;
			LD_CURR_PREV: begin
				ld_curr_prev = 1;
				inc_address = 1;
			end
			DRAW_B_ROW:
			begin
				drawCurr = 1;
				colNum = drawCounter[0];
				rowNum = drawCounter[1];
			end

		endcase
	end


endmodule

