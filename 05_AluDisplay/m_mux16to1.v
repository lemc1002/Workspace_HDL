/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : mux16to1.v
* Module Name  : mux16to1
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Parameterized 16-to-1 multiplexer implemented hierarchically using
* multiple instances of a 2-to-1 multiplexer. The module selects one of
* sixteen input buses and routes it to the output according to a 4-bit
* select signal.
*
* Black Box:
* ---------------------------------------------------------------------------
*
*                  +------------------------+
* ivData00[N-1:0]->|                        |
* ivData01[N-1:0]->|                        |
* ivData02[N-1:0]->|                        |
* ivData03[N-1:0]->|                        |
* ivData04[N-1:0]->|                        |
* ivData05[N-1:0]->|                        |
* ivData06[N-1:0]->|                        |
* ivData07[N-1:0]->|                        |
* ivData08[N-1:0]->|                        |
* ivData09[N-1:0]->|        mux16to1        |
* ivData0A[N-1:0]->|                        |--> ovMuxout[N-1:0]
* ivData0B[N-1:0]->|                        |
* ivData0C[N-1:0]->|                        |
* ivData0D[N-1:0]->|                        |
* ivData0E[N-1:0]->|                        |
* ivData0F[N-1:0]->|                        |
*      ivSel[3:0]->|                        |
*                  +------------------------+
*
* Examples:
* ---------------------------------------------------------------------------
* ivSel = 4'h0 --> ovMuxout = ivData00
* ivSel = 4'h1 --> ovMuxout = ivData01
* ivSel = 4'h2 --> ovMuxout = ivData02
* ...
* ivSel = 4'hE --> ovMuxout = ivData0E
* ivSel = 4'hF --> ovMuxout = ivData0F
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. Receives sixteen NUM_BITS-wide input buses.
* 2. Uses a hierarchical tree of 2-to-1 multiplexers.
* 3. Reduces 16 inputs to 8 candidates (Level 1).
* 4. Reduces 8 inputs to 4 candidates (Level 2).
* 5. Reduces 4 inputs to 2 candidates (Level 3).
* 6. Selects the final output from the remaining candidates (Level 4).
* 7. Routes the selected input bus to the output.
*
* Parameters:
* ---------------------------------------------------------------------------
* NUM_BITS : Width of all input and output buses.
*
* Inputs:
* ---------------------------------------------------------------------------
* ivData00 : Input data channel 0.
* ivData01 : Input data channel 1.
* ivData02 : Input data channel 2.
* ivData03 : Input data channel 3.
* ivData04 : Input data channel 4.
* ivData05 : Input data channel 5.
* ivData06 : Input data channel 6.
* ivData07 : Input data channel 7.
* ivData08 : Input data channel 8.
* ivData09 : Input data channel 9.
* ivData0A : Input data channel 10.
* ivData0B : Input data channel 11.
* ivData0C : Input data channel 12.
* ivData0D : Input data channel 13.
* ivData0E : Input data channel 14.
* ivData0F : Input data channel 15.
* ivSel    : 4-bit selection signal.
*
* Outputs:
* ---------------------------------------------------------------------------
* ovMuxout : Selected input bus.
*
* Dependencies:
* ---------------------------------------------------------------------------
* mux2to1 : Parameterized 2-to-1 multiplexer.
*
* Notes:
* ---------------------------------------------------------------------------
* - Implemented as a four-level multiplexer tree.
* - Synthesizers may optimize the hierarchy into LUT resources.
* - Used as the main operation selector in the ALU.
* - Fully combinational logic.
* - No clock or reset required.
* - Designed using synthesizable Verilog-2001.
* - No latch inference allowed.
* - Compatible with Intel Quartus Prime.
*
******************************************************************************/

/*
* Internal Architecture
* ---------------------------------------------------------------------------
*
*                    Level 4
*
*                  +--------+
*                  | MUX0E  |
*    
******************************************************************************/
module mux16to1 #(parameter NUM_BITS=4)
(
	input	wire [NUM_BITS-1:00]	ivData00,
	input	wire [NUM_BITS-1:00]	ivData01,
	input	wire [NUM_BITS-1:00]	ivData02,
	input	wire [NUM_BITS-1:00]	ivData03,
	input	wire [NUM_BITS-1:00]	ivData04,
	input	wire [NUM_BITS-1:00]	ivData05,
	input	wire [NUM_BITS-1:00]	ivData06,
	input	wire [NUM_BITS-1:00]	ivData07,
	input	wire [NUM_BITS-1:00]	ivData08,
	input	wire [NUM_BITS-1:00]	ivData09,
	input	wire [NUM_BITS-1:00]	ivData0A,
	input	wire [NUM_BITS-1:00]	ivData0B,
	input	wire [NUM_BITS-1:00]	ivData0C,
	input	wire [NUM_BITS-1:00]	ivData0D,
	input	wire [NUM_BITS-1:00]	ivData0E,
	input	wire [NUM_BITS-1:00]	ivData0F,
	input	wire [3:0] ivSel,
	output [NUM_BITS-1:00]	ovMuxout
);

wire [NUM_BITS-1:00] w00;
wire [NUM_BITS-1:00] w01;
wire [NUM_BITS-1:00] w02;
wire [NUM_BITS-1:00] w03;
wire [NUM_BITS-1:00] w04;
wire [NUM_BITS-1:00] w05;
wire [NUM_BITS-1:00] w06;
wire [NUM_BITS-1:00] w07;
wire [NUM_BITS-1:00] w08;
wire [NUM_BITS-1:00] w09;
wire [NUM_BITS-1:00] w0A;
wire [NUM_BITS-1:00] w0B;
wire [NUM_BITS-1:00] w0C;
wire [NUM_BITS-1:00] w0D;
wire [NUM_BITS-1:00] w0E;
wire [NUM_BITS-1:00] w0F;

//L1
mux2to1 mux_i00(.iw_dataA(ivData00),.iw_dataB(ivData01),.iw_sel(ivSel[0]),.or_muxout(w00));
mux2to1 mux_i01(.iw_dataA(ivData02),.iw_dataB(ivData03),.iw_sel(ivSel[0]),.or_muxout(w01));
mux2to1 mux_i02(.iw_dataA(ivData04),.iw_dataB(ivData05),.iw_sel(ivSel[0]),.or_muxout(w02));
mux2to1 mux_i03(.iw_dataA(ivData06),.iw_dataB(ivData07),.iw_sel(ivSel[0]),.or_muxout(w03));
mux2to1 mux_i04(.iw_dataA(ivData08),.iw_dataB(ivData09),.iw_sel(ivSel[0]),.or_muxout(w04));
mux2to1 mux_i05(.iw_dataA(ivData0A),.iw_dataB(ivData0B),.iw_sel(ivSel[0]),.or_muxout(w05));
mux2to1 mux_i06(.iw_dataA(ivData0C),.iw_dataB(ivData0D),.iw_sel(ivSel[0]),.or_muxout(w06));
mux2to1 mux_i07(.iw_dataA(ivData0E),.iw_dataB(ivData0F),.iw_sel(ivSel[0]),.or_muxout(w07));

//L2
mux2to1 mux_i08(.iw_dataA(w00),.iw_dataB(w01),.iw_sel(ivSel[1]),.or_muxout(w08));
mux2to1 mux_i09(.iw_dataA(w02),.iw_dataB(w03),.iw_sel(ivSel[1]),.or_muxout(w09));
mux2to1 mux_i0A(.iw_dataA(w04),.iw_dataB(w05),.iw_sel(ivSel[1]),.or_muxout(w0A));
mux2to1 mux_i0B(.iw_dataA(w06),.iw_dataB(w07),.iw_sel(ivSel[1]),.or_muxout(w0B));

//L3
mux2to1 mux_i0C(.iw_dataA(w08),.iw_dataB(w09),.iw_sel(ivSel[2]),.or_muxout(w0C));
mux2to1 mux_i0D(.iw_dataA(w0A),.iw_dataB(w0B),.iw_sel(ivSel[2]),.or_muxout(w0D));

//L4
mux2to1 mux_i0E(.iw_dataA(w0C),.iw_dataB(w0D),.iw_sel(ivSel[3]),.or_muxout(ovMuxout));

endmodule