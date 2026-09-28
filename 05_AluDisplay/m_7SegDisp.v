/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : m7SegDisp.v
* Module Name  : m7SegDisp
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Seven-segment display decoder. Converts a 4-bit hexadecimal value into
* the corresponding seven-segment display pattern.
*
* The display is assumed to be active-low, where a logic '0' turns a
* segment ON and a logic '1' turns a segment OFF.
*
* Black Box:
* ---------------------------------------------------------------------------
*
*                  +--------------------+
*  ivSeg[3:0] ---->|      m7SegDisp     |----> ov7Seg[6:0]
*                  +--------------------+
*
*         Input                     Output
*      Hex Digit              Seven-Segment Code
*
*          0      --------->      1000000
*          1      --------->      1111001
*          2      --------->      0100100
*          .                    .
*          .                    .
*          F      --------->      0001110
*
* Examples:
* ---------------------------------------------------------------------------
* ivSeg = 4'h0 --> Displays "0"
* ivSeg = 4'h7 --> Displays "7"
* ivSeg = 4'hA --> Displays "A"
* ivSeg = 4'hF --> Displays "F"
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. Receives a 4-bit binary/hexadecimal value.
* 2. Decodes the value using a combinational CASE statement.
* 3. Generates the corresponding seven-segment pattern.
* 4. Supports hexadecimal digits from 0 to F.
* 5. Blanks the display for invalid input values.
*
* Parameters:
* ---------------------------------------------------------------------------
* None.
*
* Inputs:
* ---------------------------------------------------------------------------
* ivSeg : 4-bit hexadecimal digit to be displayed.
*
* Outputs:
* ---------------------------------------------------------------------------
* ov7Seg : Seven-segment control signals {g,f,e,d,c,b,a}.
*
* Dependencies:
* ---------------------------------------------------------------------------
* None.
*
* Notes:
* ---------------------------------------------------------------------------
* - Implemented as purely combinational logic.
* - No clock or reset required.
* - Designed for common-anode (active-low) seven-segment displays.
* - Supports hexadecimal representation (0-F).
* - Default condition turns all segments OFF.
* - Designed using synthesizable Verilog-2001.
* - No latch inference allowed.
* - Compatible with Intel Quartus Prime.
*
******************************************************************************/

/*
* Segment Mapping
* ---------------------------------------------------------------------------
*
*         ---a---
*        |       |
*        f       b
*        |       |
*         ---g---
*        |       |
*        e       c
*        |       |
*         ---d---
*
* ov7Seg[6:0] = {g,f,e,d,c,b,a}
*
* Example:
*
* Digit '0'
*
*         ---a---
*        |       |
*        f       b
*        |       |
*
*        e       c
*        |       |
*         ---d---
*
* ov7Seg = 7'b1000000
*
*/
module m7SegDisp(
	input  [03:00]	ivSeg,
	output reg [06:00] ov7Seg
);

always @(*)begin
	case(ivSeg)
		4'h0: ov7Seg = 7'b100_0000;
		4'h1: ov7Seg = 7'b111_1001;
		4'h2: ov7Seg = 7'b010_0100;
		4'h3: ov7Seg = 7'b011_0000;
		4'h4: ov7Seg = 7'b001_1001;
		4'h5: ov7Seg = 7'b001_0010;
		4'h6: ov7Seg = 7'b000_0010;
		4'h7: ov7Seg = 7'b111_1000;
		4'h8: ov7Seg = 7'b000_0000;
		4'h9: ov7Seg = 7'b001_1000;
		4'hA: ov7Seg = 7'b000_0100;
		4'hB: ov7Seg = 7'b000_0011;
		4'hC: ov7Seg = 7'b010_0111;
		4'hd: ov7Seg = 7'b010_0001;
		4'he: ov7Seg = 7'b000_0110;
		4'hf: ov7Seg = 7'b000_1110;
		default: ov7Seg = 7'b111_1111;
	endcase
	

end//always
endmodule
