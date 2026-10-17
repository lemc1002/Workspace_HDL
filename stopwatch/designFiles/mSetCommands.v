//Module commands
module SetCommands
(
	input					iClk,
	input					inRst,
	input					iEnable,
	
	input					iLoadMode,	//Key[3]
	input		[03:0]	ivLoadData,	//SW[7:4]
	input		[01:0]	ivDigitSel,	//Sw[8:9]
	output	[23:0]	ovLoadData	//(24'h17_37_25)
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
reg [3:0] rdigtUS_d;
reg [3:0] rdigtUS_q;
reg [3:0] rdigtTS_d;
reg [3:0] rdigtTS_q;
reg [3:0] rdigtUM_d;
reg [3:0] rdigtUM_q;
reg [3:0] rdigtTM_d;
reg [3:0] rdigtTM_q;


//********************************************************************
//                    Generate Section
//********************************************************************
  
//********************************************************************
//                    Continious Assignment
//********************************************************************
assign ovLoadData = {rdigtTM_q,rdigtUM_q,rdigtTS_q,rdigtUS_q,4'b0101,4'b0011};

//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************
always @(posedge iClk or negedge inRst)
begin
	if(!inRst)
	begin
		rdigtUS_q <= 4'b0;
		rdigtTS_q <= 4'b0;
		rdigtUM_q <= 4'b0;
		rdigtTM_q <= 4'b0;
	end//if nRst
	
	else
	begin
		rdigtUS_q <= rdigtUS_d;
		rdigtTS_q <= rdigtTS_d;
		rdigtUM_q <= rdigtUM_d;
		rdigtTM_q <= rdigtTM_d;
	end //else nRst
end//always seq

//********************************************************************
//                    Combinatory logic section
//********************************************************************
always @(*)
begin
	// Default assignment: hold current state (prevents latches)
	rdigtUS_d = rdigtUS_q;
	rdigtTS_d = rdigtTS_q;
	rdigtUM_d = rdigtUM_q;
	rdigtTM_d = rdigtTM_q; 
	
	if(iEnable && iLoadMode)
	begin
	case(ivDigitSel)
			2'b00: rdigtUS_d = (ivLoadData > 4'd9) ? 4'd9 : ivLoadData; // Units Seconds: Max 9
			2'b01: rdigtTS_d = (ivLoadData > 4'd5) ? 4'd5 : ivLoadData; // Tens Seconds: Max 5
			2'b10: rdigtUM_d = (ivLoadData > 4'd9) ? 4'd9 : ivLoadData; // Units Minutes: Max 9
			2'b11: rdigtTM_d = (ivLoadData > 4'd5) ? 4'd5 : ivLoadData; // Tens Minutes: Max 5
		default:
		begin
			rdigtUS_d = rdigtUS_q;
			rdigtTS_d = rdigtTS_q;
			rdigtUM_d = rdigtUM_q;
			rdigtTM_d = rdigtTM_q;
		end
	endcase // encase
	end//if
end //always


//********************************************************************
//                    module instantiation section
//********************************************************************



endmodule