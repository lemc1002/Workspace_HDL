//Counter module
module mUnitCounter
#(
    parameter CNT_SIZE = 4,
    parameter [CNT_SIZE-1:0] MAX_CNT = 9
)
(
    input  wire                  iClk,
    input  wire                  inRst,
    input  wire                  iEnable,
    input  wire                  iUpDown,
	 input								iLoadMode,
	 input		 [CNT_SIZE-1:0]	ivLoadData,
    output wire [CNT_SIZE-1:0]   ovCnt,
    output wire                  oMaxHit
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
reg [CNT_SIZE-1:0] rCnt_d;
reg [CNT_SIZE-1:0] rCnt_q;

//********************************************************************
//                    Generate Section
//********************************************************************
  
//********************************************************************
//                    Continious Assignment
//********************************************************************

assign ovCnt = rCnt_q;
assign oMaxHit = !iLoadMode && iEnable && (	(iUpDown  && (rCnt_q == MAX_CNT)) || 
															(!iUpDown && (rCnt_q == {CNT_SIZE{1'b0}}) )
														);

//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************

always @(posedge iClk or negedge inRst)
begin
	if(!inRst)
	begin
		rCnt_q <= {CNT_SIZE{1'b0}};
	end//if nRst
	
	else
	begin
		rCnt_q <= rCnt_d;
	end //else nRst
end//always seq

//********************************************************************
//                    Combinatory logic section
//********************************************************************
//
always @(*)
begin
	// Default assignment: hold current state (prevents latches)
	rCnt_d = rCnt_q;
	
	if(iLoadMode)
	begin
		// Priority 1: Parallel Load Data
		rCnt_d = ivLoadData;
	end 
	else if(iEnable)
	begin
		if(iUpDown)
		begin
			if(rCnt_q >=MAX_CNT)
				begin
					rCnt_d = {CNT_SIZE{1'b0}};
				end//ifCNTMAX
				
				else
				begin
					rCnt_d = rCnt_q+1'b1;
				end//elseCNTMAX
		end//if UpDown
		
		else //CNT DOWN LOGIC
		begin
				if(rCnt_q == {CNT_SIZE{1'b0}})
				begin
					rCnt_d = MAX_CNT;
				end//ifCNTMAX
				
				else
				begin
					rCnt_d = rCnt_q-1'b1;
				end//elseCNTMAX
		end//else
		
		
	end // ienable
end //always

//********************************************************************
//                    module instantiation section
//********************************************************************



endmodule