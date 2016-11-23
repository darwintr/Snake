module rng (
    input clk,
    input rst,
    input [14:0] seed,
    output [14:0] rnd 
    );

	//This is a LFSR, takes 15 random bits and stitches them together essentially to produce
	//a random number
	//needs to be run for 15 clock cycles and has a neg edge triggered reset
	
    //BASED ON 
    //http://simplefpga.blogspot.ca/2013/02/random-number-generator-in-verilog-fpga.html

   
     
    reg [14:0] random, random_next, random_done;
    reg [3:0] count, count_next; //to keep track of the shifts
    wire feedback = random[14] ^ random[13]; 
    reg triggered;
    always @ (posedge clk or negedge rst)
    begin
        if (!rst)
        begin
        	triggered <= 0;
            random <= seed; //An LFSR cannot have an all 0 state, thus reset to FF
            count <= 0;
        end  
        else
        begin
    		if (!triggered)
    			random_done <= 15'd12432;
    		else 
    		begin
				if (count == 15)
		        begin
		            
		            random_done <= random; //assign the random number to output after 13 shifts
		        end 
    		end
        	if (count == 15)
        	begin
        		count <= 0;
        		triggered <= 1;
        	end
            random <= random_next;
            count <= count_next;
        end
    end
    
    always @ (*)
    begin
        random_next = random; //default state stays the same
        count_next = count;
           
        random_next = {random[14:0], feedback}; //shift left the xor'd every posedge clock
        count_next = count + 1;
     
        
    end
     
     
    assign rnd = random_done;
 
endmodule