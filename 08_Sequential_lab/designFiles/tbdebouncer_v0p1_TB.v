`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Testbench for Multi-Button Debouncer (mdebouncer_v0p1)
// Simulates button bounce (unstable for ~100ns -> stable -> unstable release -> stable)
//////////////////////////////////////////////////////////////////////////////////
module tbdebouncer_v0p1_TB ();

    // Simulation parameters:
    // With 50 MHz (20 ns clock), PRESCALER_MAX = 10 gives a 200 ns debounce window.
    // This allows the ~100 ns bounce to be rejected, while the >200 ns steady phase
    // validates and updates the output.
    localparam BTNS          = 4;
    localparam N             = 4;  // 4 bits can count up to 15
    localparam PRESCALER_MAX = 10; // 10 clock cycles = 200 ns window

    reg              iClk;
    reg              inRst;
    reg              iEnable;
    reg  [BTNS-1:0]  iBtnA;
    wire [BTNS-1:0]  oQ_Btn;

    // Instantiate Unit Under Test (UUT)
    mdebouncer_v0p1 #(
        .PRESCALER_MAX (PRESCALER_MAX),
        .BTNS          (BTNS),
        .N             (N)
    ) UUT (
        .iClk    (iClk),
        .inRst   (inRst),
        .iEnable (iEnable),
        .iBtnA   (iBtnA),
        .oQ_Btn  (oQ_Btn)
    );

    // 50 MHz Clock Generator (Period = 20 ns, Half-period = 10 ns)
    always begin
        #10 iClk = ~iClk;
    end

    // Monitor output changes in console
    always @(oQ_Btn) begin
        $display("[Time %0t ns] ---> Output oQ_Btn changed to: %b", $time, oQ_Btn);
    end

    // Simulation timeout
    initial begin
        #1500;
        $display("[Time %0t ns] Simulation finished successfully.", $time);
        $stop;
    end

    // Stimulus Process
    initial begin
        // 1. Initial State
        iClk    = 1'b0;
        inRst   = 1'b0; // Active-low reset asserted
        iEnable = 1'b1;
        iBtnA   = {BTNS{1'b0}};

        // 2. Release Reset after 20 ns
        #20;
        inRst = 1'b1;
        $display("[Time %0t ns] System Reset released.", $time);

        #30; // Wait a few clock cycles before pressing button

        // =====================================================================
        // BUTTON PRESS: UNSTABLE / BOUNCE PHASE (~100 ns)
        // Pulses are 10-20 ns wide (less than the 200 ns window), so oQ_Btn MUST NOT change!
        // =====================================================================
        $display("[Time %0t ns] Button 0 pressed - Bouncing / Unstable phase (~100 ns)...", $time);
        #12 iBtnA[0] = 1'b1;
        #15 iBtnA[0] = 1'b0;
        #10 iBtnA[0] = 1'b1;
        #18 iBtnA[0] = 1'b0;
        #15 iBtnA[0] = 1'b1;
        #10 iBtnA[0] = 1'b0;
        #20 iBtnA[0] = 1'b1; // Total ~100 ns elapsed, now settles HIGH

        // =====================================================================
        // BUTTON PRESS: STABLE HIGH PHASE (> 200 ns debounce window)
        // After 200 ns of continuous HIGH, the timer expires and oQ_Btn[0] becomes 1!
        // =====================================================================
        $display("[Time %0t ns] Button 0 settled HIGH - waiting for debounce timer (200 ns)...", $time);
        #400; // Stably held down for 400 ns

        // =====================================================================
        // BUTTON RELEASE: UNSTABLE / BOUNCE PHASE (~100 ns)
        // Mechanical release chatter; oQ_Btn should stay 1 until contact settles
        // =====================================================================
        $display("[Time %0t ns] Button 0 released - Bouncing / Unstable phase (~100 ns)...", $time);
        #10 iBtnA[0] = 1'b0;
        #15 iBtnA[0] = 1'b1;
        #12 iBtnA[0] = 1'b0;
        #18 iBtnA[0] = 1'b1;
        #15 iBtnA[0] = 1'b0;
        #10 iBtnA[0] = 1'b1;
        #20 iBtnA[0] = 1'b0; // Settles LOW

        // =====================================================================
        // BUTTON RELEASE: STABLE LOW PHASE (> 200 ns debounce window)
        // After 200 ns of continuous LOW, the timer expires and oQ_Btn[0] becomes 0!
        // =====================================================================
        $display("[Time %0t ns] Button 0 settled LOW - waiting for debounce timer (200 ns)...", $time);
        #300;
    end

endmodule
