/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : top_alu.v
* Module Name  : top_alu
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Top-level integration module for the ALU and display system.
* Connects board switches, push buttons, LEDs, and seven-segment displays
* to the Arithmetic Logic Unit and display conversion modules.
*
* Examples:
* ---------------------------------------------------------------------------
* - SW[4:0]  : Operand A
* - SW[9:5]  : Operand B
* - KEY[3:0] : ALU operation selection
* - HEX0-HEX4: Result display
* - LEDR     : Status flags and ALU result
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. Acquires operands from board switches.
* 2. Sends operands and control signals to the ALU.
* 3. Receives arithmetic or logical results from the ALU.
* 4. Converts arithmetic results from binary to BCD format.
* 5. Routes data to seven-segment display decoders.
* 6. Displays ALU status flags through LEDs.
* 7. Displays the negative sign when the result is negative.
*
* Parameters:
* ---------------------------------------------------------------------------
* NUM_BITS : Width of ALU operands and result buses.
* TRUNC    : Number of bits used to select ALU operation.
* NUM_DISP : Number of decimal display digits.
*
* Inputs:
* ---------------------------------------------------------------------------
* SW       : Input switches containing operands A and B.
* KEY      : Push-button controls used as ALU operation selectors.
*
* Outputs:
* ---------------------------------------------------------------------------
* LEDR     : Displays ALU result bits and status flags.
* HEX0     : Seven-segment display digit 0 (LSB).
* HEX1     : Seven-segment display digit 1.
* HEX2     : Seven-segment display digit 2.
* HEX3     : Seven-segment display digit 3.
* HEX4     : Seven-segment display digit 4.
/******************************************************************************/
module top_alu
#(
	parameter NUM_BITS=5,
	parameter TRUNC=4,
	parameter NUM_DISP=4
)
(
	input [9:0] SW,
	input [3:0] KEY,
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
	wire	[NUM_BITS-1:0]	wvDataA;
	wire	[NUM_BITS-1:0]	wvDataB;
	wire	[NUM_DISP*4-1:0]	wvBCD;
	wire	[NUM_BITS-1:0]	wvMuxOut;
	wire	wOvf;
	wire	wCout;
	wire	wZero;
	wire	wNegative;
	wire	[6:0]	wvHex0;
	wire	[6:0]	wvHex1;
	wire	[6:0]	wvHex2;
	wire	[6:0]	wvHex3;
	wire	[6:0]	wvHex4;
	wire	[6:0]	wvHex5;
	
//********************************************************************
//                    Assign logic section
//********************************************************************
	assign HEX0[6:0] = wvHex0;
	assign HEX1[6:0] = wvHex1;
	assign HEX2[6:0] = wvHex2;
	assign HEX3[6:0] = wvHex3;
	assign HEX4[6:0] = wvHex4; //7seg-display off
	assign HEX5[6:0] = wNegative? 7'b011_1111:7'b111_1111;

	
	assign wvDataA = SW[NUM_BITS*0 +:NUM_BITS];
	assign wvDataB = SW[NUM_BITS*1 +:NUM_BITS];
	assign LEDR[9] = wOvf;
	assign LEDR[8] = wNegative;
	assign LEDR[7] = wCout;
	assign LEDR[6] = wZero;
	assign LEDR[5:0] = wvMuxOut;
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
	mALUlogic
	#(
		.TRUNC(TRUNC),
		.NUM_BITS(NUM_BITS),
		.NUM_DISP(NUM_DISP)
	)
	mALU_i0(
		.ivDataA(wvDataA),
		.ivDataB(wvDataB),
		.ivSel(~KEY[3:0]),
		.ovMuxOut(wvMuxOut),
		.oCout(wCout),
		.oOvf(wOvf),
		.oNegative(wNegative),
		.oZero(wZero)
	);

	bin2bcd
	#(
		.NUM_DIGITS(NUM_DISP),
		.NUM_BITS(NUM_BITS) //ivBinary lenght without sign
	)
	mAritmetic(
		.ivBinary(wvMuxOut[NUM_BITS-1:0]), //to preserve the magnitud without sign
		.ovBCD(wvBCD)
	);
	
	m7SegDisp
	m7segU(
		.ivSeg(~&KEY[3:2]? {3'b000,wvMuxOut[0]}:wvBCD[3:0]),//~&KEY[3:2]? wvBCD[3:0]:{3'b000,wvMuxOut[0]}
		.ov7Seg(wvHex0)
	);
	
	m7SegDisp
	m7segD(
		.ivSeg(~&KEY[3:2]? {3'b000,wvMuxOut[1]}:wvBCD[7:4]),
		.ov7Seg(wvHex1)
	);
	
	m7SegDisp
	m7segH(
		.ivSeg(~&KEY[3:2]? {3'b000,wvMuxOut[2]}:4'b0000),//wvBCD[11:8]),
		.ov7Seg(wvHex2)
	);
	m7SegDisp
	m7segT(
		.ivSeg(~&KEY[3:2]? {3'b000,wvMuxOut[3]}:4'b0000),
		.ov7Seg(wvHex3)
	);
	
	m7SegDisp
	m7segDT(
		.ivSeg(~&KEY[3:2]? {3'b000,wvMuxOut[4]}:4'b0000),
		.ov7Seg(wvHex4)
	);
	
//	m7SegDisp
//	m7segA(
//		.ivSeg(wvBCD[19:16]),
//		.ov7Seg(wvHex4)
//	);
//	m7SegDisp
//	m7segB(
//		.ivSeg(wvBCD[24:20]),
//		.ov7Seg(wvHex5)
//	);


	

endmodule

//NUM_BITS    Max Value    Digits
//--------------------------------
//4           15           2
//8           255          3
//10          1023         4
//16          65535        5
//20          1048575      7
//32          4294967295   10