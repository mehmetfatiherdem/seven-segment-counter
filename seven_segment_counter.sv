module seven_segment_counter( grounds, display, clk, inc, ss);
output logic [3:0] grounds;
output logic [6:0] display;
input clk; 
logic [3:0] data [3:0] ; //number to be printed on display
logic [1:0] count;       //which data byte to display.
logic [25:0] clk1;
logic [5:0] ssv;
input logic inc;
input logic ss;


always_ff @(negedge ss)
begin
	if(ssv == 'hf)
		ssv = 'h13;
	else if(ssv == 'h13)
		ssv = 'h19;
	else
		ssv = 'hf;
end

always_ff @(negedge inc)
begin
	data[0] <= data[0]+1;
	if(data[0] == 'hf && data[1] == 'hf && data[2] == 'hf && data[3] == 'hf)
	begin
		data[0] <= 4'h0;
		data[1] <= 4'h0;
		data[2] <= 4'h0;
		data[3] <= 4'h0;
	end
	
	if(data[0] == 'hf)
		data[1] <= data[1]+1;
	if(data[0] == 'hf && data[1] == 'hf)
		data[2] <= data[2]+1;
	if(data[0] == 'hf && data[1] == 'hf && data[2] == 'hf)
		data[3] <= data[3]+1;
		
end

always_ff @(posedge clk1[ssv])    //25 slow //19 wavy //15 perfect
begin
    grounds<={grounds[2:0],grounds[3]};
    count<=count+1;              //which hex digit to display
end
always_ff @(posedge clk)
    clk1<=clk1+1;
always_comb
    case(data[count])
        0:display=7'b1111110; //starts with a, ends with g
        1:display=7'b0110000;
        2:display=7'b1101101;
        3:display=7'b1111001;
        4:display=7'b0110011;
        5:display=7'b1011011;
        6:display=7'b1011111;
        7:display=7'b1110000;
        8:display=7'b1111111;
        9:display=7'b1111011;
        'ha:display=7'b1110111;
        'hb:display=7'b0011111;
        'hc:display=7'b1001110;
        'hd:display=7'b0111101;
        'he:display=7'b1001111;
        'hf:display=7'b1000111;
        default display=7'b1111111;
    endcase
initial begin
    data[0]=4'he;
    data[1]=4'hf;
    data[2]=4'hf;
    data[3]=4'hf;
    count = 2'b0;
    grounds=4'b1110;
    clk1=0;
	 ssv=5'hf; 
end
endmodule