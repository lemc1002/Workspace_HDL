module mFAddergenerate
#(
	parameter NUM_BITS = 4
)
(
	input iClk,
	input inRst,
//	input iCE, not required
	input inEn,
	
	input  	[NUM_BITS-1:00]	ivDataA,
	input  	[NUM_BITS-1:00]	ivDataB,
	input 	iCin,
	output	[NUM_BITS-1:00]	ovSumOut,
	
	output 	oCout,
	output	oOvf,
	output	oNeg,
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
//	wire	[NUM_BITS-1:0]	wvDataA;
reg [NUM_BITS-1:0]rSumOut_d;
reg [NUM_BITS-1:0]rSumOut_q;
reg rCout_d;
reg rCout_q;
reg rOvf_d;
reg rOvf_q;

//********************************************************************
//                    Generate Section
//********************************************************************
  wire [NUM_BITS:0] wvCarrie;
  wire [NUM_BITS:0] wvSumOut;
  //wire [NUM_BITS-1:0] b_b;
  
  assign wvCarrie[0] = iCin;
    
  

	genvar i;
	generate
	 for (i=0;i<NUM_BITS;i=i+1) begin : adder_loop //adder_loop[0].fa_i, adder_loop is simply the named generate block that groups and indexes all generated full-adder instances.
		mUnitFullAdder fa_i(
		.iDataA(ivDataA[i]),
		.iDataB(ivDataB[i]),
		.iCin(wvCarrie[i]),
		.oSumOut(wvSumOut[i]),
		.oCout(wvCarrie[i+1]));
	 end
	endgenerate
  
//********************************************************************
//                    Continious Assignment
//********************************************************************


//assign oOvf = wvCarrie[NUM_BITS-1] ^ wvCarrie[NUM_BITS]; //ovf
//assign oNeg = ovSumOut[NUM_BITS-1]; //overflow = (a[3]==b[3]) && (a[3]!=s[3]) => 	overflow = ~(a[3]^b[3]) & (a[3]^s[3])
//assign oZero = ~|ovSumOut;

assign ovSumOut = rSumOut_q;
assign oCout = rCout_q;
assign oZero = ~|rSumOut_q;
assign oNeg = rSumOut_q[NUM_BITS-1];
assign oOvf = rOvf_q;

//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************
always @(posedge iClk) 
begin
	if(!inRst) 
	begin
		rSumOut_q <= 1'b0;
		rCout_q <= 1'b0; 
		rOvf_q <= 1'b0;
	end//ifRst
	
	else 
	begin
		rSumOut_q <= rSumOut_d;
		rCout_q <= rCout_d; 
		rOvf_q <= rOvf_d;
	end //elseRst
	
end //secutial logic section

//********************************************************************
//                    Combinatory logic section
//********************************************************************
always @(*)
begin
	//if (!inEn) //Per profesor assessment it´s not required the inEn, because include a inEn means that you require memory if not enable then it{s not saving, else sent 0
	//begin
	rSumOut_d = wvSumOut;
	rCout_d = wvCarrie;
	rOvf_d = wvCarrie[NUM_BITS-1] ^ wvCarrie[NUM_BITS];
	//end//if_!iEn
	//else
	
end//always

//********************************************************************
//                    module instantiation section
//********************************************************************

// eng
//	mALUlogic
//	#(
//		.TRUNC(TRUNC),
//		.NUM_BITS(NUM_BITS),
//		.NUM_DISP(NUM_DISP)
//	)

endmodule
//module objective is to build a block that instantiate the required unit_adders
