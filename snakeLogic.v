`include "ram.v"
`include "snakeMovement.v"



module snakeLogic(clk, rst, dirIn, go, length, colour_in, x, y, plotEn, colour_out);
	input clk;
	input rst;
	input [2:0] colour_in;
	input go;
	input [3:0] dirIn;
	input [10:0] length;

	output [7:0] x;
	output [6:0] y;
	output plotEn;
	output [2:0] colour_out;

	wire [2:0] dirContOut;
	wire isDead;

	dirControl dirModule(
			.clk(clk),
			.dir(dirIn),
			.reset_n(rst),
			.dirOut(dirContOut)
		);



	controlMovement control(
			.clk(clk),
			.rst(rst),
			.colour_in(colour_in),
			.length(length), 
			.go(go),
			.update_head(update_head),
			.drawQ(drawQ),
			.ld_head(ld_head),
			.ld_def(ld_def),
			.drawCurr(drawCurr),
			.rowNum(rowNum),
			.colNum(colNum),
			.ld_head_prev(ld_head_prev),
			.ld_q_curr(ld_q_curr),
			.ld_prev_q(ld_prev_q),
			.ld_curr_prev(ld_curr_prev),
			.inc_address(inc_address),
			.rst_address(rst_address),
			.colour_out(colour_out)
		);

	datapath dp(
			.clk(clk),
			.rst(rst),
			.update_head(update_head), 
			.drawQ(drawQ),
			.ld_head(ld_head),
			.ld_def(ld_def),
			.drawCurr(drawCurr),
			.rowNum(rowNum),
			.colNum(colNum),
			.ld_head_prev(ld_head_prev),
			.ld_q_curr(ld_q_curr),
			.ld_prev_q(ld_prev_q),
			.ld_curr_prev(ld_curr_prev),
			.inc_address(inc_address),
			.rst_address(rst_address),
			.dirIn(dirContOut),
			.isDead(isDead),
			.plotEn(plotEn),
			.x(x),
			.y(y)
		);


endmodule 
//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input clk,
		input [3:0] dir,
		input reset_n,
		output reg [2:0] dirOut
	);
	
	wire input1 = dir[3];
	wire input2 = dir[2];
	wire input3 = dir[1];
	wire input4 = dir[0];
	
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			dirOut <= 0;
		if (input1 == 0)
		begin
			dirOut[1] <= 0;
			dirOut[2] <= 1;
		end
		else if (input2 == 0)
		begin
			dirOut[1] <= 1;
			dirOut[2] <= 1;
		end
		else if (input3 == 0)
		begin
			dirOut[0] <= 0;
			dirOut[2] <= 0;
		end
		else if (input4 == 0)
		begin
			dirOut[0] <= 1;
			dirOut[2] <= 0;
		end
	end
endmodule


module datapath(
	input clk,
	input rst,

	input update_head, // 
	input drawQ, //
	input ld_head, //
	input ld_def, //
	input drawCurr,
	input rowNum, //
	input colNum, //
	input ld_head_prev, //
	input ld_q_curr, //
	input ld_prev_q, //
	input ld_curr_prev, //
	input inc_address, //
	input rst_address, //
	input [2:0] dirIn,
	
	output reg isDead,
	output reg plotEn,
	output reg [7:0] x,
	output reg [6:0] y
	
);
	wire [14:0] ram_out;
	reg [14:0] ram_in;
	reg ram_wren;
	reg [10:0] address;
	reg [14:0] curr, prev, head;

	ram r0(
		.address(address),
		.clock(clk),
		.data(ram_in),
		.wren(ram_wren),
		.q(ram_out)
		);

	localparam def_x = 8'd60, def_y =7'd60;

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			address <= 0;
			curr <= 0;
			prev <= 0;
			head <= 0;
		end
		else
		begin
			if (ld_head)
			begin
				head <= {def_x, def_y};
			end
			if (inc_address)
			begin
				address <= address + 1'b1;
			end
			if (rst_address)
			begin
				address <= 0;
			end
			if (update_head)
			begin
				if (dirIn[1])
					y <= y + 1;
				else if (~dirIn[1])
					y <= y - 1;
				if (dirIn[2])
				begin
					if (dirIn[0])
						x <= x - 1;
					else 
						x <= x + 1;
				end
			end
			if (ld_head_prev)
			begin
				prev <= head;
			end
			if (ld_curr_prev)
			begin
				prev <= curr;
			end
			if (ld_q_curr)
			begin
				curr <= ram_out;
			end
		end
	end

	always @(*)
	begin
		x = 0;
		y = 0;
		isDead = 0;
		plotEn = drawCurr || drawQ;
		ram_wren = 0;
		ram_in = 0;
		if (drawCurr)
		begin
			x = curr[14:7] + colNum;
			y = curr[6:0] + rowNum;
		end
		if (drawQ)
		begin
			x = ram_out[14:7] + colNum;
			y = ram_out[6:0] + rowNum;
		end
		if (ld_def)
		begin
			ram_in = {head[14:7] + address, head[6:0]};
			ram_wren = 1;
		end
		if (ld_prev_q)
		begin
			ram_in = prev;
			ram_wren = 1;
		end

	end
endmodule