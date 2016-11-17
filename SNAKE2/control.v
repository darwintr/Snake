module control (
		input go,
        input rst, 
        input clk,
		  input [3:0] colour_in,
        output reg plot,
        output reg ld,
        output reg update,
		  output reg [3:0] colour_out,
		  output reg row
    );
    reg [2:0] cnt;
	 reg [2:0] colCnt;
    reg [2:0] currState, nextState;
    localparam L_DEFAULT = 3'b000,
        UPDATE_POS = 3'b001,
        DRAW_COL = 3'b010,
		  INC_COL = 3'b101,
        WAIT = 3'b011,
		  DRAW_BLACK_COL = 3'b100,
		  INC_BLACK_COL = 3'b110;
		  

    always @(*)
    begin: state_table
        case (currState)
            L_DEFAULT: nextState = DRAW_BLACK_COL;
				DRAW_BLACK_COL: nextState = cnt == 10 ? INC_BLACK_COL : DRAW_BLACK_COL;
				INC_BLACK_COL: nextState = colCnt == 10 ? UPDATE_POS: DRAW_BLACK_COL;
            UPDATE_POS: nextState = DRAW_COL;
            DRAW_COL: nextState = cnt == 10 ? INC_COL : DRAW_COL;
				INC_COL: nextState = colCnt == 10 ? WAIT : DRAW_COL;
            WAIT: nextState = go ? DRAW_BLACK_COL : WAIT;
        endcase
    end

    always @(posedge clk, negedge rst)
    begin
        
        if (!rst)
		  begin
            currState <= L_DEFAULT;
				cnt <= 0;
				colCnt <= 0;
		  end
        else
        begin
				
            if (currState == DRAW_COL || currState == DRAW_BLACK_COL)
                cnt <= cnt + 1;
            else
                cnt <= 0;
				if (currState == INC_COL || currState == INC_BLACK_COL)
					colCnt <= colCnt + 1;
				
				if (currState == UPDATE_POS || WAIT)
					colCnt <= 0;
				
            currState <= nextState;
        end
    end

    always @(*) begin
        ld = 0;
        plot = 0;
        update = 0;
		  row = 0;
        
        case (currState)
            L_DEFAULT: ld = 1;
            UPDATE_POS: update = 1;
            DRAW_COL: begin
					colour_out = colour_in;
					plot = 1;
				end
				INC_COL: begin
					row = colCnt;
				end
				INC_BLACK_COL: begin
					row = colCnt;
				end
				DRAW_BLACK_COL:begin
					colour_out = 3'b000;
					plot = 1;
				end
        endcase
    
    end
endmodule


