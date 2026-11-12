`timescale 1ns / 1ps
`include "sysdefines_lab.vh"

module mdebouncer_v0p1 
#(
	parameter PRESCALER_MAX = 524287,
	parameter BTNS = 4,
	parameter N = 19
)
(
	input 		        	iClk,
	input 		        	inRst,
	input 		        	iEnable,
	input  	[BTNS-1:0]  iBtnA,
	output	[BTNS-1:0]	oQ_Btn
);

reg [BTNS-1:0] q_ff1;
reg [BTNS-1:0] q_ff2;
reg [BTNS-1:0] q_ff3;

wire [BTNS-1:0] btn_edge;
wire wTick;
wire [N-1:0]wCnt;

assign btn_edge = q_ff1 ^ q_ff2;
assign oQ_Btn = q_ff3;

// Flip-flop macro invocations
`DFF_E(iClk, inRst, iEnable, iBtnA, q_ff1)
`DFF_E(iClk, inRst, iEnable, q_ff1, q_ff2)
`DFF_E(iClk, inRst, wTick, q_ff2, q_ff3)

// ----------------------------------------------------------------
// 1. Clock Prescaler (50 MHz -> 100 Hz Enable Tick)
// ----------------------------------------------------------------
    mUnitCounter
    #(
        .CNT_SIZE(N),
        .MAX_CNT(PRESCALER_MAX)
    )
    mPrescaler_ins
    (
        .iClk    		(iClk),
        .inRst   		(inRst & !btn_edge),
        .iEnable 		(iEnable),
        .iUpDown 		(1'b1),
		  .iLoadMode	(1'b0), // means not load a specific value
		  .ivLoadData	({N{1'b0}}), //not required
        .ovCnt   		(wCnt),
        .oMaxHit 		(wTick)
    );

endmodule

