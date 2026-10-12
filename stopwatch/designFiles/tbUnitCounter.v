// Test bench
`timescale 1ns/1ps //Unit time and resolution defintion
module tbUnitCounter();

	localparam CNT_SIZE = 4;
	localparam MAX_CNT = 9;

	// Stimulous source
	reg iClk;
	reg iEnable;
	reg inRst;
	reg iUpDown;
	
	//monitor signals
	wire wMaxHit;
	wire [CNT_SIZE-1:0]wvCnt;
	
//********************************************************************
//                    module instantiation section
//********************************************************************
// Correct named parameter override
    mUnitCounter
    #(
        .CNT_SIZE(CNT_SIZE),
        .MAX_CNT(MAX_CNT)
    )
    mUnitCounter_UUT
    (
        .iClk    (iClk),
        .inRst   (inRst|wMaxHit),
        .iEnable (iEnable),
        .iUpDown (iUpDown),
        .ovCnt   (wvCnt),
        .oMaxHit (wMaxHit)
    );
	
//--------------------------------------------------
// Clock generation
//--------------------------------------------------
	initial
	begin
		iClk = 1'b0;
		forever #10 iClk = ~iClk; //every 10 time units (#10) creates a 20 ns square wave 50MHz
	end
	
  initial 
  begin
	//Step A: initialize signals
	iEnable=0;
	inRst=0;	// Assert reset (Active Low)
	iUpDown=1;
	
	// Step B: Hold reset for 25ns, then release
	#10;
	inRst = 1;
	#10;
	
	// Step C: start count
	$display("=== STARTING UP-COUNT TEST ===");
	iEnable = 1;
	#240;
	
	// Step D: Test Disable / Pause feature
	$display("=== TESTING ENABLE PAUSE ===");
	iEnable = 0;
	inRst=0;	// Assert reset (Active Low)
	#10;
	inRst = 1;
	#40; // Count value should remain frozen
	
	// Step E: Test DOWN Counting
	$display("=== STARTING DOWN-COUNT TEST ===");
	iEnable = 1;
	iUpDown = 0; // Switch to DOWN mode
	// Wait 240ns (12 clock cycles) to watch it count 1->0->9->8...
	#240;
	
	// Step F: Finish simulation
	$display("=== SIMULATION COMPLETE ===");
	$finish;
  end
  
// ----------------------------------------------------------------
// 6. Monitor signal changes in console window
// ----------------------------------------------------------------
	initial 
	begin
	  $monitor("Time=%0tns | Rst=%b | En=%b | UpDown=%b | Count=%d | MaxHit=%b",
				  $time, inRst, iEnable, iUpDown, wvCnt, wMaxHit);
	end

  initial begin
//    $dumpfile("dump.vcd"); 
//    $dumpvars;
    #660 $stop();    
  end 
endmodule