module control (
		input go,
        input rst, 
        input clk,
        output reg plot,
        output reg ld,
        output reg update
    );
    reg [2:0] cnt;    
    reg [2:0] currState, nextState;
    localparam L_DEFAULT = 2'b00,
        UPDATE_POS = 2'b01,
        DRAW = 2'b10,
        WAIT = 2'b11;

    always @(*)
    begin: state_table
        case (currState)
            L_DEFAULT: nextState = UPDATE_POS;
            UPDATE_POS: nextState = DRAW;
            DRAW: nextState = cnt == 3'b11 ? WAIT : DRAW;
            WAIT: nextState = go ? UPDATE_POS : WAIT;
        endcase
    end

    always @(posedge clk or negedge rst)
    begin
        
        if (!rst)
            currState <= L_DEFAULT;
        else
        begin
            if (currState == DRAW)
                cnt <= cnt + 1;
            else
                cnt <= 0;
            currState <= nextState;
            

        end
    end

    always @(*) begin
        ld = 0;
        plot = 0;
        update = 0;
        
        case (currState)
            L_DEFAULT: ld = 1;
            UPDATE_POS: update = 1;
            DRAW: plot = 1;      
        endcase
    
    end
endmodule


