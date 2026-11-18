// FSM UART TX

module mFSM
	#(
		parameter BAUDRATE = 9600,
	)
	(
		input 	iClk,
		input 	nRst,
		input		iEnable,
		input		iHit,
		input		iTXSEND,
		input		iShiftCount,
		output	oSerialShift,
		output	oLoadParallel,
		output	
	);
//********************************************************************
//                    		Includes section
//********************************************************************
	parameter stIdle 			= 4'h0;
	parameter stLoadData 	= 4'h1;
	parameter stSendStart 	= 4'h2;
	parameter stWait 			= 4'h3;
	parameter stShift			= 4'h4;
	parameter stSendParity	= 4'h5;
//********************************************************************
//                    		defines section
//********************************************************************
          
//********************************************************************
//                    Internal signals section
//									(wire and reg)
//********************************************************************
//	wire	[NUM_BITS-1:00]	wvSumOut;
	reg [1:0] state;
	reg nxt_state;
	reg orSerialShift;
	reg orLoadParallel;
//********************************************************************
//                    Assign logic section                                                                                                                                                                                  
//********************************************************************
//	assign oCout = wCout;

assign oSerialShift	= 1'b0;
assign oLoadParallel	= 1'b0;
	
//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************

    always @(posedge iClk, negedge inRst) 
	 begin
        if (!inRst)
            state <= stIdle; 
        else
            state <= nxt_state;
    end
	
//********************************************************************
//                    Combinatory logic section
//********************************************************************
	
	always@(*) begin
		next_state = state;

		case(state)
		
			stIdle: begin
				if 	(!iTXSEND) next_state = stLoadData;
				else 	next_state = stIdle;
			end// state_idle

			stLoadData: begin
			
			end// stLoadData
			
			stSendStart: begin
			
			end// stSendStart
		
			stWait: begin
			
			end// stWait

			stShift: begin
			
			end// stShift
			
			stSendParity: begin
			
			end// stSendParity
			
			// Recovery from illegal state
			default:	nxt_state = stIdle;
			
		endcase	
	end//always *
	

//********************************************************************
//                   State Register
//********************************************************************
	always @* begin
		// Default for illegal state
        dout = 6'bxxxxxx;
		  
		case (state)
			stIdle:    		
				oLoadParallel = 1'b0;
				oSerialShift =	1'b0;
			stLoadData:    dout =6'd32;
			stSendStart:	dout = 6'd12;
			stWait:    		dout = 6'd9;
			stShift:			dout = 6'd45;
			stSendParity:	dout = 6'd32;
			default:dout = 6'bxxxxxx;
		endcase
	end//always *
	
endmodule
//********************************************************************
//                    module instantiation section
//********************************************************************

//	mp_fadder #(.NUM_BITS(NUM_BITS))
//	signedSub(
//		.ivDataA(ivDataA),
//		.ivDataB(~ivDataB),
//		.iCin(1'b1),
//		.ovpSumOut(wvSubOut)
////		.oOvf(wOvf),
////		.oNeg(wNegative)
//	);

//				if 		(!oLoadParallel && !oSerialShift && iShiftCount && nRst && !iEnable && iTXSEND) next_state = stLoadData;
//				else if 	(!oLoadParallel && !oSerialShift && iShiftCount && nRst && !iEnable && !iTXSEND) next_state = stIdle;





