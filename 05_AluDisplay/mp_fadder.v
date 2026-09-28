/******************************************************************************
* Project      : ALU_Display
* Course       : Digital Systems Design
* Institution  : ITESO Graduate Program
* Laboratory   : Practice 1 - Arithmetic Logic Unit (ALU) with Display
*
* File Name    : mp_fadder.v
* Module Name  : mp_fadder
*
* Author(s)    : enmoca
* Date Created : 16/09/2026
* Version      : 0.1
*
* Description:
* ---------------------------------------------------------------------------
* Parameterized ripple-carry full adder constructed from multiple instances
* of a 1-bit full adder. The module performs N-bit addition and generates
* Carry, Overflow, Negative, and Zero status flags.
*
* Black Box:
* ---------------------------------------------------------------------------
*
*                    +----------------------+
*  ivDataA[N-1:0] -->|                      |
*  ivDataB[N-1:0] -->|      mp_fadder       |--> ovpSumOut[N-1:0]
*            iCin -->|                      |--> oCout
*                    |                      |--> oOvf
*                    |                      |--> oNeg
*                    |                      |--> oZero
*                    +----------------------+
*
* Examples:
* ---------------------------------------------------------------------------
* 5 + 3  = 8
* 7 + 1  = 8
* 5 - 2  = 3            (using two's complement at the inputs)
* -4 + 2 = -2
*
* Functionality:
* ---------------------------------------------------------------------------
* 1. Creates a parameterized ripple-carry adder using generate statements.
* 2. Chains NUM_BITS one-bit full adders together.
* 3. Propagates carry signals between adder stages.
* 4. Produces the final arithmetic result.
* 5. Generates Carry-Out flag.
* 6. Generates Signed Overflow flag.
* 7. Generates Negative flag from the result sign bit.
* 8. Generates Zero flag when the result equals zero.
*
* Parameters:
* ---------------------------------------------------------------------------
* NUM_BITS : Width of operands, result bus, and carry chain.
*
* Inputs:
* ---------------------------------------------------------------------------
* ivDataA : Operand A.
* ivDataB : Operand B.
* iCin    : Initial carry input.
*
* Outputs:
* ---------------------------------------------------------------------------
* ovpSumOut : Arithmetic result.
* oCout     : Final carry output.
* oOvf      : Signed overflow flag.
* oNeg      : Negative result flag.
* oZero     : Zero result flag.
*
* Dependencies:
* ---------------------------------------------------------------------------
* m_fadder : One-bit full adder cell.
*
* Notes:
* ---------------------------------------------------------------------------
* - Implemented as a Ripple-Carry Adder (RCA).
* - Carry propagates sequentially through all stages.
* - Overflow detection uses:
*
*       Overflow = Carry(MSB-1) XOR Carry(MSB)
*
* - Negative flag is the most-significant bit of the result.
*
*       oNeg = ovpSumOut[NUM_BITS-1]
*
* - Zero flag is asserted when all result bits are cleared.
*
*       oZero = ~|ovpSumOut
*
* - Addition and subtraction can share this hardware by modifying
*   ivDataB and iCin externally.
* - Designed using synthesizable Verilog-2001.
* - No latch inference allowed.
* - Compatible with Intel Quartus Prime.
*
******************************************************************************/
module mp_fadder #(parameter NUM_BITS = 8)(
	input  	[NUM_BITS-1:00]	ivDataA,
	input  	[NUM_BITS-1:00]	ivDataB,
	input 			  				iCin,
	output 	[NUM_BITS-1:00]	ovpSumOut,
	output 	oCout,
	output	oOvf,
	output	oNeg,
	output	oZero	
);

  wire [NUM_BITS:0] wvCarrie;
  //wire [NUM_BITS-1:0] b_b;
  
  assign wvCarrie[0] = iCin;
    
  genvar i;
  generate
    for (i=0;i<NUM_BITS;i=i+1) begin : adder_loop //adder_loop[0].fa_i, adder_loop is simply the named generate block that groups and indexes all generated full-adder instances.
      m_fadder fa_i(.ivpDataA(ivDataA[i]),.ivpDataB(ivDataB[i]),.iCin(wvCarrie[i]),.ovpSumOut(ovpSumOut[i]),.oCout(wvCarrie[i+1]));
    end
  endgenerate
  
  assign oCout = wvCarrie[NUM_BITS];
  assign oOvf = wvCarrie[NUM_BITS-1] ^ wvCarrie[NUM_BITS]; //ovf
  assign oNeg = ovpSumOut[NUM_BITS-1]; //overflow = (a[3]==b[3]) && (a[3]!=s[3]) => 	overflow = ~(a[3]^b[3]) & (a[3]^s[3])
  assign oZero = ~|ovpSumOut;
 endmodule
 
 /*
* Internal Architecture (NUM_BITS = 4 example)
*
*          Carry Chain
*
*      C0      C1      C2      C3      C4
*      |       |       |       |       |
*      v       v       v       v       v
*
*   +-----+ +-----+ +-----+ +-----+
* A0|     | |     | |     | |     |
* B0| FA0 |-| FA1 |-| FA2 |-| FA3 |
*   |     | |     | |     | |     |
*   +-----+ +-----+ +-----+ +-----+
*      |       |       |       |
*      S0      S1      S2      S3
*
* Result = {S3,S2,S1,S0}
* Carry  = C4
* Ovf    = C3 ^ C4
*/
 
   //wire [6:0] c;
  //full_adder (input a,b,ci, output s,co );
  //full_adder fa_i0(a[0],b[0],1'b0,s[0],c[0]);
  //full_adder fa_i1(a[1],b[1],c[0],s[1],c[1]);
  //full_adder fa_i2(a[2],b[2],c[1],s[2],c[2]);
  //full_adder fa_i3(a[3],b[3],c[2],s[3],c[3]);
  //full_adder fa_i4(a[4],b[4],c[3],s[4],c[4]);
  //full_adder fa_i5(a[5],b[5],c[4],s[5],c[5]);
  //full_adder fa_i6(a[6],b[6],c[5],s[6],c[6]);
  //full_adder fa_i7(a[7],b[7],c[6],s[7],co);

  //wire [8:0] c;
  //assign c[0] = 1'b0;
  //full_adder fa_i0(a[0],b[0],c[0],s[0],c[1]);
  //full_adder fa_i1(a[1],b[1],c[1],s[1],c[2]);
  //full_adder fa_i2(a[2],b[2],c[2],s[2],c[3]);
  //full_adder fa_i3(a[3],b[3],c[3],s[3],c[4]);
  //full_adder fa_i4(a[4],b[4],c[4],s[4],c[5]);
  //full_adder fa_i5(a[5],b[5],c[5],s[5],c[6]);
  //full_adder fa_i6(a[6],b[6],c[6],s[6],c[7]);
  //full_adder fa_i7(a[7],b[7],c[7],s[7],c[8]);
  //assign co = c[8];
  
  //wire [8:0] c;
  //assign c[0] = 1'b0;
  //genvar i;
  //generate
  //  for (i=0;i<8;i=i+1)
  //    full_adder fa_i(a[i],b[i],c[i],s[i],c[i+1]);
  //endgenerate
  //assign co = c[8];