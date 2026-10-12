// Test bench
`timescale 10ns/1ns //Unit time and resolution defintion
module tbUnitCounter_UUT();

	localparam CNT_SIZE = 4
	localparam MAX_CNT = 9

	// Stimulous source
	reg iClk;
	reg iEnable;
	reg inRst;
	reg iUpDown;

	wire oMaxHit;
	wire [CNT_SIZE-1:0]ovCnt

endmodule
