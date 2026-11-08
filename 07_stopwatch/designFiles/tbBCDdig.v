`timescale 1ns/1ps

module tb_mBCDdig();

    // Stimulus signals
    reg	iClk;
    reg	inRst;
    reg	iEnable;
    reg	iUpDown;

    // BCD Outputs
    wire	[3:0]	wHOnes;
    wire	[3:0]	wHTens;
    wire	[3:0]	wSOnes;
    wire	[3:0]	wSTens;
    wire	[3:0]	wMOnes;
    wire	[3:0]	wMTens;

//********************************************************************
// Module Instantiation (Overriding PRESCALER_MAX for Fast Simulation)
//********************************************************************
    mBCDdig
    #(
        .PRESCALER_MAX(4) // 5 clock cycles per tick = 100 ns
    )
    uut
    (
		.iClk    (iClk),
		.inRst   (inRst),
		.iEnable (iEnable),
		.iUpDown (iUpDown),
		.ovHOnes (wHOnes),
		.ovHTens (wHTens),
		.ovSOnes (wSOnes),
		.ovSTens (wSTens),
		.ovMOnes (wMOnes),
		.ovMTens (wMTens)
    );

//--------------------------------------------------
// 50 MHz Clock Generation (20 ns Period)
//--------------------------------------------------
    initial begin
        iClk = 1'b0;
        forever #10 iClk = ~iClk;
    end

//--------------------------------------------------
// Test Stimulus Sequence
//--------------------------------------------------
    initial begin
        // Initialize
        inRst   = 1'b0; // Assert reset
        iEnable = 1'b0;
        iUpDown = 1'b1; // UP mode

        #40;
        inRst   = 1'b1; // Release reset
        #20;

        $display("=== STARTING FAST 6-DIGIT CASCADED SIMULATION ===");
        iEnable = 1'b1;

        // Run for 3,000 clock cycles (60,000 ns) to see digits transition
        #60_000;

        $display("=== TESTING DOWN-COUNT CASCADING ===");
        iUpDown = 1'b0; // Switch to DOWN mode
        #30_000;

        $display("=== SIMULATION COMPLETE ===");
        $finish;
    end

//--------------------------------------------------
// Display Monitor (Formatted MM:SS.hh)
//--------------------------------------------------
    initial begin
        $monitor("Time=%0t ns | Display = %d%d : %d%d . %d%d",
                 $time, wMTens, wMOnes, wSTens, wSOnes, wHTens, wHOnes);
    end

endmodule

// vlib work
//cd C:/altera_ws/Workspace_HDL/stopwatch/designFiles

//
//# 1. Close current simulation
//quit -sim
//
//# 2. Delete stale compiled library
//vdel -all -lib work
//
//# 3. Create fresh work library
//vlib work
//
//# 4. Recompile design and testbench with explicit Verilog-2001 standard (-2001)
//vlog -2001 C:/altera_ws/Workspace_HDL/stopwatch/designFiles/mUnitCounter.v
//vlog -2001 C:/altera_ws/Workspace_HDL/stopwatch/designFiles/tbUnitCounter.v
//
//# 5. Run simulation
//vsim -voptargs="+acc" work.tbUnitCounter_UUT