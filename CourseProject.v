module CourseProject (input clk, reset, switch,
input [9:0] startNum,
output reg signal0, signal1, signal2,
output [6:0] hex0, hex1, hex2, hex3, hex4, hex5,
output reg [6:0] lights
);

reg [9:0] num;
reg s0, s1, s2;
wire bReset, bSwitch;
reg [3:0] startHour;
reg [5:0] startMin;
reg [8:0] minVal, hourVal;
reg [9:0] oneVal, tenVal, hunVal;
reg [6:0] tenHours, hours, tenMins, mins, tenSecs, secs;

wire oneSecClk, alarmClk;
reg timeDone;
ClockDivider_Lab4(clk, oneSecClk); // Clock divider based off off my work for lab 4
ClockDividerQuarterSecond(clk,alarmClk); // Modified clock divider from Lab 4 that creates a quater second clock
Debouncer(clk, reset, bReset); // Debouncers are for the switch and reset buttons. Slightly modified code from video on Eclass.
Debouncer(clk, switch, bSwitch);
//reg switcher;

initial begin
	s0 <= 1;
	s1 <= 0;
	s2 <= 0;
	minVal = 0;
	hourVal = 0;
    
end


always @(*) begin
	startMin <= startNum[5:0];
	startHour <= startNum[9:6];
end

always @(posedge clk && bSwitch) begin
	if (s0 == 1 && bSwitch == 0) begin // This controls the state switching
    	s0 <= 0;
    	s1 <= 1;
    	s2 <= 0;
	end
   	 
	else if (s1 == 1 && bSwitch == 0) begin
    	s0 <= 0;
    	s1 <= 0;
    	s2 <= 1;
	end
   	 
	else if (s2 == 1 && bSwitch == 0) begin
    	s0 <= 1;
    	s1 <= 0;
    	s2 <= 0;
	end
    
end
    
always @(posedge oneSecClk && bSwitch) begin
    
//	if (s0 == 1 && switch == 0) begin // This controls the state switching
//    	s0 <= 0;
//    	s1 <= 1;
//    	s2 <= 0;
//	end
//   	 
//	else if (s1 == 1 && switch == 0) begin
//    	s0 <= 0;
//    	s1 <= 0;
//    	s2 <= 1;
//	end
//   	 
//	else if (s2 == 1 && switch == 0) begin
//    	s0 <= 1;
//    	s1 <= 0;
//    	s2 <= 0;
//	end
    
    
	if (s0 == 1) begin //Timer
    	signal0 <= 1; //Signals are meant to signal which state the board is in while the circuit is running
    	signal1 <= 0;
    	signal2 <= 0;
   	 
    	if (bReset == 0) begin
        	num <= startNum;
        	timeDone <= 0;
    	end
    
//    	else if (pauser == 0) begin
//        	num <= num;
//    	end
    
    	else if (bReset == 1) begin
        	if (num == 0) begin
            	num <= 0;
            	timeDone <= 1;
        	end
   	 
    
        	else begin
            	num <= num - 1;
            	timeDone <= 0;
        	end
       	 
    	end //end of reset == 1 block
   	 
	end // end of state 0
   	 
   	 
	else if (s1 == 1) begin // Stopwatch
    	signal0 <= 0;
    	signal1 <= 1;
    	signal2 <= 0;
   	 
    	if (bReset == 0) begin
        	num <= 0;
        	//secVal <= 0;
        	minVal <= 0;
        	hourVal <= 0;
    	end
    
//    	else if (pauser == 0) begin
//        	num <= num;
//        	minVal = minVal;
//        	hourVal = hourVal;
//    	end
    
    	else if (bReset == 1) begin
        	if (num < 59) begin
            	num <= num + 1;
        	end
   	 
        	if (num == 59 && minVal < 59) begin
            	minVal <= minVal + 1;
            	num <= 0;
        	end
   	 
        	if (minVal == 59 && hourVal < 23) begin
            	hourVal <= hourVal + 1;
            	minVal <= 0;
        	end
   	 
        	if (hourVal == 23) begin
            	hourVal <= 0;
        	end
   	 
    	end // end of reset == 1 block
       	 
	end // end of state 1
    
    
	else if (s2 == 1) begin
    	signal0 <= 0;
    	signal1 <= 0;
    	signal2 <= 1;
   	 
    	if (bReset == 0) begin
        	num <= 0;
        	hourVal <= startHour;
        	minVal <= startMin;
//        	secVal <= 0
    	end
    
//	else if (pauser == 0) begin
//    	num <= num;
//    	minVal <= minVal;
//    	hourVal <= hourVal;
//	end
    
    	else if (bReset == 1) begin
        	if (num < 59) begin
            	num <= num + 1;
        	end
   	 
        	if (hourVal == 0) begin //Since there can't be zero hours on a clock, it the goes to zero, then the clock quickly goes to one.
            	hourVal <=12;
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
            	hourVal <= hourVal + 1;
            	minVal <= minVal % 60;
        	end
   	 
//        	if (hourVal == 12) begin
//            	hourVal <= 0;
//        	end
   	 
        	if (hourVal > 12) begin //If the user input a number greater than 12, then the time that's shown would be the result of their number minus 12.
            	hourVal <= hourVal - 12;
        	end
   	 
    	end // end of reset == 1 block
   	 
	end // end of state 2 block
    
    
end // end of always block

always @(posedge alarmClk) begin // LED lights flash on and off if the timer has reached zero.
	if (s0 == 1) begin
    	if (timeDone == 1) begin
        	lights <= ~lights;
    	end
    
    	else begin
        	lights <= 0;
    	end
	end
    
	else begin
    	//timeDone <= 0;
    	lights <= 0;
	end
    
    
end

always @ (num or oneSecClk) begin

	if (s0 != 1) begin
    
    	tenSecs = num / 10;
    
    	secs = num % 10;
    
    	tenMins = minVal / 10;
    
    	mins = minVal % 10;
    
    	tenHours = hourVal / 10;
    
    	hours = hourVal % 10;
   	 
	end
    
	else begin
    
    	tenHours <= 0;
    	hours <= 0;
    	if (num > 999) begin
        	//rem <= num;
        	tenMins = num / 1000; //tenHours would equal the quotient num / 1000 with no remainder
        	hunVal <= num % 1000; // rem then equals the result of itself mod 1000
    
        	mins = hunVal / 100; //The above process would carry on
        	tenVal <= hunVal % 100;
    
        	tenSecs = tenVal / 10;
        	oneVal <= tenVal % 10;
   	 
        	secs = oneVal;
   	 
    	end
   	 
    	else if (num > 99 && num < 1000) begin
        	//rem <= num;
        	tenMins = 0;
        	mins = num / 100; //The above process for tenHours would carry on for the rest of the digits
        	tenVal <= num % 100;
    
        	tenSecs = tenVal / 10;
        	oneVal <= tenVal % 10;
   	 
        	secs = oneVal;
    	end
    
    	else if (num > 9 && num < 100) begin
        	//rem <= num;
        	tenMins = 0;
        	mins = 0;
        	tenSecs = num / 10;
   	 
        	oneVal <= num % 10;
        	secs = oneVal;
   	 
    	end
    
    	else begin
        	tenMins = 0;
        	mins = 0;
        	tenSecs = 0;
        	secs = num;
    	end
   	 
	end
    
end

SegmentDisplay(tenHours[3], tenHours[2], tenHours[1], tenHours[0], hex5[0], hex5[1], hex5[2], hex5[3], hex5[4], hex5[5], hex5[6]);
SegmentDisplay(hours[3], hours[2], hours[1], hours[0], hex4[0], hex4[1], hex4[2], hex4[3], hex4[4], hex4[5], hex4[6]);
SegmentDisplay(tenMins[3], tenMins[2], tenMins[1], tenMins[0], hex3[0], hex3[1], hex3[2], hex3[3], hex3[4], hex3[5], hex3[6]);
SegmentDisplay(mins[3], mins[2], mins[1], mins[0], hex2[0], hex2[1], hex2[2], hex2[3], hex2[4], hex2[5], hex2[6]);
SegmentDisplay(tenSecs[3], tenSecs[2], tenSecs[1], tenSecs[0], hex1[0], hex1[1], hex1[2], hex1[3], hex1[4], hex1[5], hex1[6]);
SegmentDisplay(secs[3], secs[2], secs[1], secs[0], hex0[0], hex0[1], hex0[2], hex0[3], hex0[4], hex0[5], hex0[6]);

endmodule













module Debouncer(clk, button, outbutton);

input clk, button;

output reg outbutton = 0;

reg[22:0] timer = 23'b0;
reg hold = 0;

always @ (posedge clk) begin
	if (hold == 1) begin
    	timer <= timer + 1;
	end
    
	else if (button != outbutton) begin
    	outbutton <= button;
   	 
	end
    
    
    
	if (timer == 5000000) begin
    	hold <= 0;
    	timer <= 0;
	end
    
    
    
	if (button == 0) begin
    	timer <= 0;
    	hold <= 1;
	end
    
end

endmodule
