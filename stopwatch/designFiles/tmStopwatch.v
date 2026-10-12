//top level
module tmStopwatch
#(
	parameter CNT_SIZE = 4,
	parameter MAX_CNT= 9,
	parameter NUM_DISP = 6,
	parameter NUM_BITS = 4
	
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
	wire	[NUM_DISP*4-1:0]	wvBCD;
	
	wire	[1:0]	wvMode;
	wire	[6:0]	wvHex0;
	wire	[6:0]	wvHex1;
	wire	[6:0]	wvHex2;
	wire	[6:0]	wvHex3;
	wire	[6:0]	wvHex4;
	wire	[6:0]	wvHex5;
	
// 4-bit BCD buses connecting counter outputs to decoders
    wire [3:0] wvHOnes;
    wire [3:0] wvHTens;
    wire [3:0] wvSOnes;
    wire [3:0] wvSTens;
    wire [3:0] wvMOnes;
    wire [3:0] wvMTens;
	
//********************************************************************
//                    Generate Section
//********************************************************************
  
//********************************************************************
//                    Continious Assignment
//********************************************************************
	assign HEX0[6:0] = wvHex0;
	assign HEX1[6:0] = wvHex1;
	assign HEX2[6:0] = wvHex2;
	assign HEX3[6:0] = wvHex3;
	assign HEX4[6:0] = wvHex4;
	assign HEX5[6:0] = wvHex5;

	assign wvMode = SW[3:2];
	assign LEDR[9:0] = 10'b11_0011_0011;
	
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
// -------------------------------------------------------------------
// 1. 6-Digit Cascaded BCD Stopwatch Counter
// -------------------------------------------------------------------
    mBCDdig
    #(
        .PRESCALER_MAX(499_999) // 500,000 cycles = 10ms tick at 50 MHz
    )
    mBCDdig_inst
    (
        .iClk    (CLOCK_50), // DE10-Standard 50 MHz Clock
        .inRst   (KEY[0]),   // KEY[0] pressed = 0 (Active-Low Reset)
        .iEnable (SW[0]),    // SW[0] UP = Run/Enable, DOWN = Pause
        .iUpDown (SW[1]),    // SW[1] UP = Count UP, DOWN = Count DOWN
        .ovHOnes (wvHOnes),  // 0.01s digit
        .ovHTens (wvHTens),  // 0.1s  digit
        .ovSOnes (wvSOnes),  // 1s    digit
        .ovSTens (wvSTens),  // 10s   digit
        .ovMOnes (wvMOnes),  // 1m    digit
        .ovMTens (wvMTens)   // 10m   digit
    );
// Correct named parameter override

// -------------------------------------------------------------------
// 2. 7-Segment Display Decoders (HEX0 to HEX5)
// -------------------------------------------------------------------
    // HEX0: Hundredths Ones (0.01s)
    mSevenSegDisp m7segU (
        .ivSeg  (wvHOnes),
        .ov7Seg (wvHex0)
    );

    // HEX1: Hundredths Tens (0.1s)
    mSevenSegDisp m7segD (
        .ivSeg  (wvHTens),
        .ov7Seg (wvHex1)
    );

    // HEX2: Seconds Ones (1s)
    mSevenSegDisp m7segH (
        .ivSeg  (wvSOnes),
        .ov7Seg (wvHex2)
    );

    // HEX3: Seconds Tens (10s)
    mSevenSegDisp m7segT (
        .ivSeg  (wvSTens),
        .ov7Seg (wvHex3)
    );

    // HEX4: Minutes Ones (1min)
    mSevenSegDisp m7segDT (
        .ivSeg  (wvMOnes),
        .ov7Seg (wvHex4)
    );

    // HEX5: Minutes Tens (10min) - Fixed assignment to wvHex5
    mSevenSegDisp m7segA (
        .ivSeg  (wvMTens),
        .ov7Seg (wvHex5)
    );
	

endmodule

//NUM_BITS    Max Value    Digits
//--------------------------------
//4           15           2
//8           255          3
//10          1023         4
//16          65535        5
//20          1048575      7
//32          4294967295   10
