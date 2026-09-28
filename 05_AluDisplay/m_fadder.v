/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : m_fadder.v
* Module Name  : m_fadder
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Brief description of the module functionality.
*
* Examples:
* Full adder
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. List the main responsibilities of the module.
* 2. Describe the implemented algorithm or logic.
* 3. Mention any assumptions or restrictions.
*
* Parameters:
* ---------------------------------------------------------------------------
* LENGTH : Defines the width of input and output data buses.
*
* Inputs:
* ---------------------------------------------------------------------------
* clk      : System clock.
* rst      : Active-high reset signal.
* enable   : Enables data storage/update.
* A        : Operand A.
* B        : Operand B.
* Control  : ALU operation selector.
*
* Outputs:
* ---------------------------------------------------------------------------
* Result   : Operation result.
* Carry    : Carry flag.
* Overflow : Overflow flag.
* Negative : Negative result flag.
* Zero     : Zero result flag.
*
* Dependencies:
* ---------------------------------------------------------------------------
* List any modules instantiated by this design.
*
* Notes:
* ---------------------------------------------------------------------------
* - Designed using synthesizable Verilog.
* - No latch inference allowed.
* - Compatible with Intel Quartus Prime.
*
******************************************************************************/

module m_fadder #(parameter N = 4) (
	input  	ivpDataA,
	input  	ivpDataB,
	input 	iCin,
	output	ovpSumOut,
	output	oCout
	
//	input inRst
//	input iClk
//	input inEnable
);
 
assign ovpSumOut = ivpDataA ^ ivpDataB ^ iCin;
assign oCout = (ivpDataA & ivpDataB)|(ivpDataA & iCin)|(ivpDataB & iCin);


endmodule
  
//assign {or_cout, orp_sum} <= ivpDataA + ivpDataB;

//reg rD_d
//reg rD_q
//
//assign oQ = rD_q
//
//always @(negedge iClk, negedge inRst) begin
//	
//	
//	if(iClk==1b´0) begin
//		{or_cout, orp_sum} <= (iClk)? rD_d=rO_q: viwp_a + iwp_b;
//	end
//	
//end
//
//endmodule

