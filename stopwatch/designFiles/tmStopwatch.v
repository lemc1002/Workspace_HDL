//top level
module tmStopwatch
#(
	parameter CNT_SIZE = 4,
	parameter MAX_CNT= 9
)
	
(
	input CLOCK_50,
	input [9:0] SW,
	input [3:0] KEY, // Active-low pushbuttons (1 unpressed, 0 pressed).
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5 
);

//********************************************************************
//                    		Includes section
//********************************************************************

//********************************************************************
//                    		defines section
//********************************************************************

//********************************************************************
//                    Internal signals section
//									(wire and reg)
//********************************************************************

//********************************************************************
//                    Generate Section
//********************************************************************
  
//********************************************************************
//                    Continious Assignment
//********************************************************************
assign HEX5[6:0] = 7'b011_1111;
wire [MAX_CNT-1:0]wvCnt;
wire wMaxHit; 

//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************


//********************************************************************
//                    Combinatory logic section
//********************************************************************


//********************************************************************
//                    module instantiation section
//********************************************************************

// Correct named parameter override
    mUnitCounter
    #(
        .CNT_SIZE(CNT_SIZE),
        .MAX_CNT(MAX_CNT)
    )
    mUnitCounter_UUT
    (
        .iClk    (CLOCK_50),
        .inRst   (KEY[0]|wMaxHit),
        .iEnable (~KEY[1]),
        .iUpDown (1'b1),
        .ovCnt   (wvCnt),
        .oMaxHit (wMaxHit)
    );

endmodule
