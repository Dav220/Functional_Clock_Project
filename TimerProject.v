module TimerProject(
input clk, pause, reset,
input [9:0] startNum,
output [6:0] hex0, hex1, hex2, hex3, hex4, hex5
);

reg [9:0] num;
reg [9:0] oneVal, tenVal, hunVal;
reg [6:0] thousands, hundreds, tens, ones;

wire oneSecClk;
ClockDivider_Lab4(clk, oneSecClk);
reg pauser;

initial begin
	pauser = 1;
end


always @(negedge pause) begin
	pauser = ~pauser;
end


always @ (posedge oneSecClk & pauser)
begin
	if (reset == 0) begin
    	num <= startNum;
	end
    
	else if (pauser == 0) begin
    	num <= num;
	end
    
	else if (reset == 1) begin
    	if (num == 0) begin
        	num <= 0;
    	end
   	 
    
    	else begin
        	num <= num - 1;
    	end
	end
   	 
    
    

end

//always @ (num or oneSecClk) begin
//	ones = num % 1000;
//end

    
always @ (num or oneSecClk) begin
	//rem <= num; // setting rem as num
	if (num > 999) begin
    	//rem <= num;
    	thousands = num / 1000; //tenHours would equal the quotient num / 1000 with no remainder
    	hunVal <= num % 1000; // rem then equals the result of itself mod 1000
    
    	hundreds = hunVal / 100; //The above process would carry on
    	tenVal <= hunVal % 100;
    
    	tens = tenVal / 10;
    	oneVal <= tenVal % 10;
   	 
    	ones = oneVal;
   	 
	end
   	 
	else if (num > 99 && num < 1000)begin
    	//rem <= num;
    	thousands = 0;
    	hundreds = num / 100; //The above process for tenHours would carry on for the rest of the digits
    	tenVal <= num % 100;
    
    	tens = tenVal / 10;
    	oneVal <= tenVal % 10;
   	 
    	ones = oneVal;
	end
    
	else if (num > 9 && num < 100) begin
    	//rem <= num;
    	thousands = 0;
    	hundreds = 0;
    	tens = num / 10;
   	 
    	oneVal <= num % 10;
    	ones = oneVal;
   	 
	end
    
	else begin
	thousands = 0;
	hundreds = 0;
	tens = 0;
	ones = num;
	end
	 
end

SegmentDisplay(thousands[3], thousands[2], thousands[1], thousands[0], hex3[0], hex3[1], hex3[2], hex3[3], hex3[4], hex3[5], hex3[6]);
SegmentDisplay(hundreds[3], hundreds[2], hundreds[1], hundreds[0], hex2[0], hex2[1], hex2[2], hex2[3], hex2[4], hex2[5], hex2[6]);
SegmentDisplay(tens[3], tens[2], tens[1], tens[0], hex1[0], hex1[1], hex1[2], hex1[3], hex1[4], hex1[5], hex1[6]);
SegmentDisplay(ones[3], ones[2], ones[1], ones[0], hex0[0], hex0[1], hex0[2], hex0[3], hex0[4], hex0[5], hex0[6]);

endmodule
