/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : bin2bcd.v
* Module Name  : bin2bcd
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Parameterized Binary-to-BCD converter implemented using the Double-Dabble
* (Shift-Add-3) algorithm.
*
* The module converts an unsigned binary number of arbitrary width into
* its equivalent Binary-Coded Decimal (BCD) representation. The number of
* generated BCD digits is user configurable through a parameter.
*
* Black Box:
* ---------------------------------------------------------------------------
*
*                 +----------------------+
* ivBinary[N-1:0]->|                      |
*                  |       bin2bcd        |--> ovBCD[(D*4)-1:0]
*                  |                      |
*                 +----------------------+
*
* Where:
*   N = NUM_BITS
*   D = NUM_DIGITS
*
* Example:
*
*   ivBinary = 8'd156
*
*          156
*           |
*           V
*
*   BCD = {1,5,6}
*
*   ovBCD = 12'b0001_0101_0110
*
* Examples:
* ---------------------------------------------------------------------------
* Binary  = 4'd15
* BCD     = 2'd15
*
* Binary  = 8'd255
* BCD     = 3'd255
*
* Binary  = 10'd1023
* BCD     = 4'd1023
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. Receives an N-bit unsigned binary value.
* 2. Initializes a temporary shift register.
* 3. Places the binary value in the lower portion of the register.
* 4. Iteratively evaluates each BCD digit.
* 5. Adds three to any BCD nibble greater than or equal to five.
* 6. Shifts the complete register left by one bit.
* 7. Repeats the process NUM_BITS times.
* 8. Extracts the final BCD digits from the upper portion of the register.
*
* Parameters:
* ---------------------------------------------------------------------------
* NUM_DIGITS : Number of BCD digits to generate.
* NUM_BITS   : Width of the binary input value.
*
* Inputs:
* ---------------------------------------------------------------------------
* ivBinary : Binary number to be converted.
*
* Outputs:
* ---------------------------------------------------------------------------
* ovBCD : Packed BCD result.
*
*          Digit[NUM_DIGITS-1] ... Digit[0]
*
*          Each digit occupies 4 bits
*
* Dependencies:
* ---------------------------------------------------------------------------
* None.
*
* Notes:
* ---------------------------------------------------------------------------
* - Uses the Double-Dabble (Shift-Add-3) algorithm.
* - Implemented as combinational logic.
* - No clock or reset required.
* - Supports arbitrary input widths through parameterization.
* - Each BCD digit requires 4 bits of storage.
* - Intended for driving decimal display systems.
* - Designed using synthesizable Verilog-2001.
* - No latch inference allowed.
* - Compatible with Intel Quartus Prime.
*
******************************************************************************/

/*
* Internal Architecture
* ---------------------------------------------------------------------------
*
*               regvShift
*
* +----------------------+------------------+
* |      BCD Region      |  Binary Region   |
* +----------------------+------------------+
* | D*4 bits             | NUM_BITS bits    |
* +----------------------+------------------+
*
*
* Example (NUM_BITS=10, NUM_DIGITS=4)
*
* +----------------+------------+
* | BCD[15:0]      | BIN[9:0]   |
* +----------------+------------+
*
*
* Double-Dabble Algorithm
* ---------------------------------------------------------------------------
*
* Step 1:
*   Load binary value into shift register.
*
* Step 2:
*   For every BCD digit:
*
*       if (BCD_digit >= 5)
*           BCD_digit = BCD_digit + 3;
*
* Step 3:
*   Shift the entire register left by one bit.
*
* Step 4:
*   Repeat NUM_BITS times.
*
* Step 5:
*   Extract the BCD portion.
*
*
* Example: Binary 13
*
* Binary:
*
*       1101
*
* Iterations:
*
*       1101
*       |
*       +--> Add-3 when needed
*       |
*       +--> Shift Left
*       |
*       +--> Repeat
*
* Result:
*
*       BCD = 0001 0011
*
*       Tens = 1
*       Units = 3
*
*
* Sizing Guidelines
* ---------------------------------------------------------------------------
*
* NUM_BITS    Maximum Value      Required Digits
* ----------------------------------------------
*     4             15                2
*     8            255                3
*    10           1023                4
*    16          65535                5
*    20        1048575                7
*    32     4294967295               10
*
*/
module bin2bcd
#(
	parameter NUM_DIGITS	= 5, //BDC digits required
	parameter NUM_BITS 	= 10 //ivBinary lenght
)
(
	input [NUM_BITS-1:0] ivBinary,
	output reg [NUM_DIGITS*4-1:0] ovBCD //Each digit requires 4 bits for BCD representation
);

integer i, j;
reg [NUM_BITS+NUM_DIGITS*4-1:0] regvShift; //regvShift dimension is BCD digists (requires 4bits per register) + binari number bits dimension ie 10'd65535 = 16bits needed and  5 digits representation equal to BCDportion[0110 0101 0101 0011 0101] ivBinaryportion[1111 1111 1111 1111]

//Combinational block
always @(*) begin
	regvShift = 0;
	regvShift[NUM_BITS-1:0] = ivBinary; //ivBinary portion
	
	for(i=0; i<NUM_BITS; i=i+1)begin
		for(j=0; j<NUM_DIGITS; j=j+1)begin
			if(regvShift[NUM_BITS+j*4 +: 4] >= 5) //shift[10 + 0*4 +:4] if j=0 it becomes to shift[13:10]; j=1 then shift[10 + 1*4 +:4] becomes to shift[17:14]
					regvShift[NUM_BITS+j*4 +: 4] = regvShift[NUM_BITS+j*4 +: 4] + 3; //add 3 to jump to the next bcd nible
		end//for_j
		regvShift = regvShift << 1;
	end//for_i
	
	ovBCD = regvShift[NUM_BITS+NUM_DIGITS*4-1:NUM_BITS];
	
end//always

endmodule
