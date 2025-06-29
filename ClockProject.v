module ClockProject(input clk, pause, reset,
input [9:0] startNum,
output [6:0] hex0, hex1, hex2, hex3, hex4, hex5
);

reg [9:0] num;
reg [3:0] startHour;
reg [5:0] startMin;
reg [8:0] hour, min, sec;
reg [8:0] minVal, hourVal;
reg [6:0] tenHours, hours, tenMins, mins, tenSecs, secs;

wire oneSecClk;
ClockDivider_Lab4(clk, oneSecClk);
reg pauser;

initial begin
	pauser = 1;
	minVal = 0;
	hourVal = 0;
end

always @(*) begin
	startMin <= startNum[5:0];
	startHour <= startNum[9:6];
end

always @(negedge pause) begin
	pauser = ~pauser;
end

always @ (posedge oneSecClk & pauser) begin
    
	if (reset == 0) begin
    	num <= 0;
    	hourVal <= startHour;
    	minVal <= startMin;
//    	secVal <= 0
	end
    
	else if (pauser == 0) begin
    	num <= num;
    	minVal <= minVal;
    	hourVal <= hourVal;
	end
    
	else if (reset == 1) begin
    	if (num < 59) begin
        	num <= num + 1;
    	end
   	 
    	if (hourVal == 0) begin //Since there can't be zero hours on a clock, it the goes to zero, then the clock quicly goes to one.
        	hourVal <=1;
    	end
   	 
    	if (num == 59 && minVal < 59) begin
        	minVal <= minVal + 1;
        	num <= 0;
    	end
   	 
    	if (minVal == 59 && hourVal < 12) begin
        	hourVal <= hourVal + 1;
        	minVal <= 0;
    	end
   	 
    	if (minVal > 59) begin
        	minVal <= 0;
    	end
   	 
//    	if (hourVal == 12) begin
//        	hourVal <= 0;
//    	end
   	 
    	if (hourVal > 12) begin //If the user input a number greater than 12, then the time that's shown would be the result of their number minus 12.
        	hourVal <= hourVal - 12;
    	end
   	 
	end
    
end

always @ (num or oneSecClk) begin

	tenSecs = num / 10;
    
	secs = num % 10;
    
	tenMins = minVal / 10;
    
	mins = minVal % 10;
    
	tenHours = hourVal / 10;
    
	hours = hourVal % 10;
    
end

SegmentDisplay(tenHours[3], tenHours[2], tenHours[1], tenHours[0], hex5[0], hex5[1], hex5[2], hex5[3], hex5[4], hex5[5], hex5[6]);
SegmentDisplay(hours[3], hours[2], hours[1], hours[0], hex4[0], hex4[1], hex4[2], hex4[3], hex4[4], hex4[5], hex4[6]);
SegmentDisplay(tenMins[3], tenMins[2], tenMins[1], tenMins[0], hex3[0], hex3[1], hex3[2], hex3[3], hex3[4], hex3[5], hex3[6]);
SegmentDisplay(mins[3], mins[2], mins[1], mins[0], hex2[0], hex2[1], hex2[2], hex2[3], hex2[4], hex2[5], hex2[6]);
SegmentDisplay(tenSecs[3], tenSecs[2], tenSecs[1], tenSecs[0], hex1[0], hex1[1], hex1[2], hex1[3], hex1[4], hex1[5], hex1[6]);
SegmentDisplay(secs[3], secs[2], secs[1], secs[0], hex0[0], hex0[1], hex0[2], hex0[3], hex0[4], hex0[5], hex0[6]);



endmodule
