
module rng (
    input clock,
    input reset,
    output [14:0] rnd 
    );

    //BASED ON 
    //http://simplefpga.blogspot.ca/2013/02/random-number-generator-in-verilog-fpga.html

    wire feedback = random[14] ^ random[13]; 
     
    reg [14:0] random, random_next, random_done;
    reg [3:0] count, count_next; //to keep track of the shifts
     
    always @ (posedge clock or posedge reset)
    begin
        if (reset)
        begin
            random <= 15'hF; //An LFSR cannot have an all 0 state, thus reset to FF
            count <= 0;
        end  
        else
        begin
            random <= random_next;
            count <= count_next;
        end
    end
     
    always @ (*)
    begin
        random_next = random; //default state stays the same
        count_next = count;
           
        random_next = {random[11:0], feedback}; //shift left the xor'd every posedge clock
        count_next = count + 1;
     
        if (count == 15)
        begin
            count = 0;
            random_done = random; //assign the random number to output after 13 shifts
        end 
    end
     
     
    assign rnd = random_done;
 
endmodule