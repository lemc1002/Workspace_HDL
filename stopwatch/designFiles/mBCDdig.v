module mBCDdig
#(
	parameter PRESCALER_MAX = 499_999
)
(
	input iClk,
	input inRst,
	input iEnable,
	input iUpDown,
	
	// Counter BCD Outputs
    output	[3:0]	ovHOnes,	// Hundredths ones (0.01s)
    output	[3:0]	ovHTens,	// Hundredths tens (0.1s)
    output	[3:0]	ovSOnes,	// Seconds ones    (1s)
    output	[3:0]	ovSTens,	// Seconds tens    (10s)
    output	[3:0]	ovMOnes,	// Minutes ones    (1min)
	 output	[3:0]	ovMTens	// Minutes ones    (10min)
	
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

//********************************************************************
//                    Generate Section
//********************************************************************
  
//********************************************************************
//                    Continious Assignment
//********************************************************************


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
        .ovCnt   (ovMTens),
        .oMaxHit (wHit_M_Tens)
    );	 

endmodule