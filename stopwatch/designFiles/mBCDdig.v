module mBCDdig
#(
	parameter PRESCALER_MAX = 499_999
)
(
	input iClk,
	input inRst,
	input iEnable,
	input iUpDown,
	input iLoadMode,
	input [23:0] ivLoadData,
	
	// Counter BCD Outputs
    output	[3:0]	ovHOnes,	// Hundredths ones (0.01s)
    output	[3:0]	ovHTens,	// Hundredths tens (0.1s)
    output	[3:0]	ovSOnes,	// Seconds ones    (1s)
    output	[3:0]	ovSTens,	// Seconds tens    (10s)
    output	[3:0]	ovMOnes,	// Minutes ones    (1min)
	 output	[3:0]	ovMTens,	// Minutes ones    (10min)
	 
	 output			oCDAlert
	
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

    wire wTick100Hz;
    wire wHit_H_Ones;
    wire wHit_H_Tens;
    wire wHit_S_Ones;
    wire wHit_S_Tens;
    wire wHit_M_Ones;
	 wire wHit_M_Tens;

	 // Unary NOR reduction: 1 when ALL 6 digits equal 0
    wire wZeroDetected = ~|{ovMTens, ovMOnes, ovSTens, ovSOnes, ovHTens, ovHOnes};
	 
	 reg rZDAlert_d;
	 reg rZDAlert_q;

//********************************************************************
//                    Generate Section
//********************************************************************
  
//********************************************************************
//                    Continious Assignment
//********************************************************************
assign oCDAlert = rZDAlert_q;

//********************************************************************
//                    Sequential logic section
//	(registered output) Reg (left side) (blocking = and non blocking <=)
//********************************************************************
always @(posedge iClk or negedge inRst) 
begin
	if (!inRst) begin
		rZDAlert_q <= 1'b0;
	end else begin
	if (iLoadMode) begin
		rZDAlert_q <= 1'b0; // Clear alert when loading a new preset
		end else if (!iUpDown && wZeroDetected && iEnable) begin
			rZDAlert_q <= 1'b1; // Latch alert when countdown hits 00:00.00
		end
		// 2. Stop Alert when ovSOnes hits 6 (after 4 seconds of countdown rollover)
	  if (rZDAlert_q && (ovSOnes == 4'd6)) begin
			rZDAlert_q <= 1'b0;
	  end
	end
end//sequential always

//********************************************************************
//                    Combinatory logic section
//********************************************************************


//********************************************************************
//                    module instantiation section
//********************************************************************

// ----------------------------------------------------------------
// 1. Clock Prescaler (50 MHz -> 100 Hz Enable Tick)
// ----------------------------------------------------------------
    mUnitCounter
    #(
        .CNT_SIZE(20),
        .MAX_CNT(PRESCALER_MAX)
    )
    mPrescaler_ins
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (iEnable),
        .iUpDown (1'b1),
		  .iLoadMode	(1'b0),
		  .ivLoadData	(20'b0),
        .ovCnt   (),
        .oMaxHit (wTick100Hz)
    );
// ----------------------------------------------------------------
// 2. Hundredths Ones Digit. (0.01s)
// ----------------------------------------------------------------
	 mUnitCounter
    #(
        .CNT_SIZE(4),
        .MAX_CNT(9)
    )
    mH_Ones
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (wTick100Hz),
        .iUpDown (iUpDown),
		  .iLoadMode	(1'b0),
		  .ivLoadData	(4'b1001),
        .ovCnt   (ovHOnes),
        .oMaxHit (wHit_H_Ones)
    );
	 
// ----------------------------------------------------------------
// 3. Hundredths Tens Ones Digit. (0.1s)
// ----------------------------------------------------------------
	 mUnitCounter
    #(
        .CNT_SIZE(4),
        .MAX_CNT(9)
    )
    mH_Tens
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (wHit_H_Ones),
        .iUpDown (iUpDown),
		  .iLoadMode	(1'b0),
		  .ivLoadData	(4'b1001),
        .ovCnt   (ovHTens),
        .oMaxHit (wHit_H_Tens)
    );
// -------------------------------------------------------------------
// 4. Seconds Ones Digit (1s: 0 to 9)
// -------------------------------------------------------------------
    mUnitCounter
    #(
        .CNT_SIZE(4),
        .MAX_CNT(9)
    )
    mS_Ones
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (wHit_H_Tens),
        .iUpDown (iUpDown),
		  .iLoadMode	(iLoadMode),
		  .ivLoadData	(ivLoadData[11:8]),
        .ovCnt   (ovSOnes),
        .oMaxHit (wHit_S_Ones)
    );

// -------------------------------------------------------------------
// 5. Seconds Tens Digit (10s: 0 to 5 -> Rolls over at 59 seconds)
// -------------------------------------------------------------------
    mUnitCounter
    #(
        .CNT_SIZE(4),
        .MAX_CNT(5)
    )
    mS_Tens
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (wHit_S_Ones),
        .iUpDown (iUpDown),
		  .iLoadMode	(iLoadMode),
		  .ivLoadData	(ivLoadData[15:12]),
        .ovCnt   (ovSTens),
        .oMaxHit (wHit_S_Tens)
    );

// -------------------------------------------------------------------
// 6. Minutes Ones Digit (1 min: 0 to 9)
// -------------------------------------------------------------------
    mUnitCounter
    #(
        .CNT_SIZE(4),
        .MAX_CNT(9)
    )
    mM_Ones
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (wHit_S_Tens),
        .iUpDown (iUpDown),
		  .iLoadMode	(iLoadMode),
		  .ivLoadData	(ivLoadData[19:16]),
        .ovCnt   (ovMOnes),
        .oMaxHit (wHit_M_Ones)
    );

// -------------------------------------------------------------------
// 7. Minutes Tens Digit (10 min: 0 to 5 -> Rolls over at 59 minutes)
// -------------------------------------------------------------------
    mUnitCounter
    #(
        .CNT_SIZE(4),
        .MAX_CNT(5)
    )
    mM_Tens
    (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (wHit_M_Ones),
        .iUpDown (iUpDown),
		  .iLoadMode	(iLoadMode),
		  .ivLoadData	(ivLoadData[23:20]),
        .ovCnt   (ovMTens),
        .oMaxHit (wHit_M_Tens)
    );	 

endmodule