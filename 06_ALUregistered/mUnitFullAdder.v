module mUnitFullAdder 
(
	input  	iDataA,
	input  	iDataB,
	input 	iCin,
	output	oSumOut,
	output	oCout
);
 
	assign oSumOut = iDataA ^ iDataB ^ iCin;
	assign oCout = (iDataA & iDataB)|(iDataA & iCin)|(iDataB & iCin);


endmodule

////according with proffesor discussion full adder and generate adder generally speaking is a cobinational circuit, the outputs of the full adder are the ones that should be registered.


////********************************************************************
//// 	                   		module name
////********************************************************************
//
//module mUnitFullAdder
//(
//	input iClk,
//	input inRst,
////	input iCE, not in use because it is not iCE required
//	input inEn,
//	
//	input  	iDataA,
//	input  	iDataB,
//	input 	iCin,
//	output	oSumOut,
//	output	oCout
//);
//
//
////********************************************************************
////                    		Includes section
////********************************************************************
//
////********************************************************************
////                    		defines section
////********************************************************************
//
////********************************************************************
////                    Internal signals section
////									(wire and reg)
////********************************************************************
////	wire	[NUM_BITS-1:0]	wvDataA;
//reg rSumOut_d;
//reg rSumOut_q;
//reg rCout_d;
//reg rCout_q;
//
////********************************************************************
////                    Continious Assignment
////********************************************************************
//assign oSumOut = rSumOut_q;
//assign oCout = rCout_q;
//
////********************************************************************
////                    Sequential logic section
////	(registered output) Reg (left side) (blocking = and non blocking <=)
////********************************************************************
//always @(posedge iClk) //synchronous FFD 
//begin
//	if(!inRst) 
//	begin
//		rSumOut_q <= 1'b0;
//		rCout_q <= 1'b0; 
//	end//ifRst
//	
//	else 
//	begin
//		rSumOut_q <= rSumOut_d;
//		rCout_q <= rCout_d; 
//	end //elseRst
//	
//end //secutial logic section
//
////********************************************************************
////                    Combinatory logic section
////********************************************************************
//always @(*)
//begin
//	if (!inEn) 
//	begin
//		rSumOut_d = iDataA ^ iDataB ^ iCin;
//		rCout_d = (iDataA & iDataB)|(iDataA & iCin)|(iDataB & iCin);
//	end//if_!iEn
//end//always
////********************************************************************
////                    module instantiation section
////********************************************************************
//
//
////	mALUlogic
////	#(
////		.TRUNC(TRUNC),
////		.NUM_BITS(NUM_BITS),
////		.NUM_DISP(NUM_DISP)
////	)
//
//endmodule