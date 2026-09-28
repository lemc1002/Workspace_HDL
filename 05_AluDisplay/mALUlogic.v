/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : mALUlogic.v
* Module Name  : mALUlogic
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Core Arithmetic Logic Unit (ALU) module.
* Performs arithmetic and logical operations selected through a 4-bit
* control signal and generates the corresponding status flags.
*
* Examples:
* ---------------------------------------------------------------------------
* ivSel = 4'h0 : A + B
* ivSel = 4'h1 : A - B
* ivSel = 4'h2 : Two's complement of B
* ivSel = 4'h3 : A * B
* ivSel = 4'h4 : A AND B
* ivSel = 4'h5 : A OR B
* ivSel = 4'h6 : NOT A
* ivSel = 4'h7 : A XOR B
* ivSel = 4'h8 : A << B
* ivSel = 4'h9 : A >> B
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. Receives two NUM_BITS-wide operands.
* 2. Performs addition or subtraction using a parameterized full adder.
* 3. Generates Carry, Overflow, Zero, and Negative flags.
* 4. Implements arithmetic, logical, and shift operations.
* 5. Selects the requested operation through a 16-to-1 multiplexer.
* 6. Routes the selected result to the module output.
*
* Parameters:
* ---------------------------------------------------------------------------
* TRUNC     : Number of operation-select bits used by the ALU.
* NUM_BITS  : Width of operand and result buses.
* NUM_DISP  : Number of display digits available in the top-level design.
*
* Inputs:
* ---------------------------------------------------------------------------
* ivDataA   : Operand A.
* ivDataB   : Operand B.
* ivSel     : ALU operation selector.
*
* Outputs:
* ---------------------------------------------------------------------------
* ovMuxOut  
/******************************************************************************/
module mALUlogic
#(
	parameter TRUNC=4,
	parameter NUM_BITS=5,
	parameter NUM_DISP=5
	
)
(
	input		[NUM_BITS-1:00]	ivDataA,
	input		[NUM_BITS-1:00]	ivDataB,
	input		[3:0]					ivSel,
	output	[NUM_BITS-1:00]	ovMuxOut,
	output	oCout,
	output	oOvf,
	output	oNegative,
	output	oZero
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

	wire	[NUM_BITS-1:0] 	wvMuxOut;
	wire	[NUM_BITS-1:00]	wvSumSubOut;
//	wire	[NUM_BITS-1:00]	wvSumOut;
//	wire 	[NUM_BITS-1:00]	wvSubOut;
	wire	wCout;
	wire	wOvf;
	wire 	wZero;
	wire	wNegative;

//********************************************************************
//                    Assign logic section                                                                                                                                                                                  
//********************************************************************
	assign oCout = wCout;
	assign oOvf	 = wOvf;
	assign oZero = wZero;
	assign oNegative = wNegative;
	assign ovMuxOut[NUM_BITS-1:00] = wvMuxOut;
	
//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************

//********************************************************************
//                    Combinatory logic section
//********************************************************************
	
//	always@(*) begin
//		if ((ivSel[0] & ivSel[1]) == 1'b0) begin
//			ivSelBCD <= 1'b0;// BCD
//		end //if
//					
//		else begin
//			ivSelBCD <= 1'b1;//logic
//		end//else
//	end//always


	
//********************************************************************
//                    module instantiation section
//********************************************************************
	
	mp_fadder #(.NUM_BITS(NUM_BITS))
	signedSumSub(
		.ivDataA(ivDataA),
		.ivDataB(ivSel[0]? (~ivDataB):ivDataB),
		.iCin(ivSel[0]? 1'b1:1'b0),
		.ovpSumOut(wvSumSubOut),
		.oCout(wCout),
		.oOvf(wOvf),
		.oZero(wZero),
		.oNeg(wNegative)
	);

//	mp_fadder #(.NUM_BITS(NUM_BITS))
//	signedSub(
//		.ivDataA(ivDataA),
//		.ivDataB(~ivDataB),
//		.iCin(1'b1),
//		.ovpSumOut(wvSubOut)
////		.oOvf(wOvf),
////		.oNeg(wNegative)
//	);

	mux16to1 #(.NUM_BITS(NUM_BITS))
	mainMux(
		.ivData00(wvSumSubOut),
		.ivData01(wvSumSubOut),
		.ivData02(~ivDataB+1),
		.ivData03(ivDataA*ivDataB),
		.ivData04(ivDataA & ivDataB),
		.ivData05(ivDataA | ivDataB),
		.ivData06(~ivDataA),
		.ivData07(ivDataA ^ ivDataB),
		.ivData08(ivDataA << ivDataB),
		.ivData09(ivDataA >> ivDataB),
		.ivData0A(4'b0),
		.ivData0B(4'b0),
		.ivData0C(4'b0),
		.ivData0D(4'b0),
		.ivData0E(4'b0),
		.ivData0F(4'b0001),
		.ivSel(ivSel),
		.ovMuxout(wvMuxOut)
	);
	
//	mux2to1  
//	mBCDSel(
//		.iw_dataA(iBIN),
//		.iw_dataB(ovBCD),
//		.iw_sel(ivSelBCD),
//		.or_muxout(w7SegOut)
//	);

endmodule
