//tbmFAddergenerate
//`timescale 10ns/1ns

// Code your testbench here
// or browse Examples


module tbFAddergenerate;
  
  parameter NUM_BITS = 5;
  
  		// DUT inputs
	reg iClk;
	reg inRst;
	reg inEn;
	
	reg  [NUM_BITS-1:0]	ivDataA;
	reg  [NUM_BITS-1:0]	ivDataB;
	wire [NUM_BITS-1:0]	ovpSumOut;
	wire oCout;
	wire oOvf;
	wire oNeg;
	wire oZero;
  
  //reg  [7:0] s_d;
  //reg  [7:0] s_l;

mFAddergenerate #(.NUM_BITS(NUM_BITS) )
mFAdder_dut 
(
	.iClk(iClk),
	.inRst(inRst),
	//iCE, not required
	.inEn(inEn),

	.ivDataA(ivDataA),
	.ivDataB(ivDataB),
	.iCin(1'b0),
	.ovSumOut(ovpSumOut),
	.oCout(oCout),
	.oOvf(oOvf),
	.oNeg(oNeg),
	.oZero(oZero)
);

//--------------------------------------------------
// Clock generation
//--------------------------------------------------
	initial
	begin
		iClk = 1'b0;
		forever #5 iClk = ~iClk;
	end

	
  initial begin
  	inRst  = 0;
	inEn   = 0;
	ivDataA = 0;
	ivDataB = 0;
	//iCin   = 0;

	// Reset
	#14;
	inRst = 1;
	
    {ivDataB,ivDataA} = 1'b0;
    $display("Init {ivDataB,ivDataA} = 0");
    forever begin
      #1
      if ((ivDataA+ivDataB) !== {oCout,ovpSumOut}) 
        $display("@%0d ERROR - ivDataA (%0d) + ivDataB (%0d) != {oCout,ovpSumOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovpSumOut});
      else
        $display("@%0d - ivDataA (%0d) + ivDataB (%0d) != {oCout,ovpSumOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovpSumOut});
      
      #1 
      {ivDataB,ivDataA} = {ivDataB,ivDataA}+1;
      
      if ({ivDataB,ivDataA} == 0) #2 $finish();
    end
  end

//  always @* s_l = #3 s;


  //  always @* s_d = repeat(3) //@(posedge a[0]) s_l;
  
  // Process to dump waves and finish sim
  initial begin
//    $dumpfile("dump.vcd"); 
//    $dumpvars;
    #260 $stop();    
  end  
  
  
endmodule

