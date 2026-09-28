`timescale 10ns/1ns

// Code your testbench here
// or browse Examples


module tb_mp_fadder();
  
  localparam ADDER_SIZE = 20;
  
  	reg  [ADDER_SIZE-1:0]	ivDataA;
	reg  [ADDER_SIZE-1:0]	ivDataB;
	wire [ADDER_SIZE-1:0]	ovpSumOut;
	wire oCout;
  
  reg  [ADDER_SIZE-1:0] a,b;
  wire [ADDER_SIZE-1:0] s;
  wire       co;
  //reg  [7:0] s_d;
  //reg  [7:0] s_l;
  
mp_fadder #(.NUM_BITS(ADDER_SIZE)) 

mp_fadder_dut(
	.ivDataA(ivDataA),
	.ivDataB(ivDataB),
	.iCin(1'b0),
	.ovpSumOut(ovpSumOut),
	.oCout(oCout)
	
);
    
  initial begin
    {ivDataB,ivDataA} = '0;
    $display("Init {ivDataB,ivDataA} = 0");
    forever begin
      #1
      if ((ivDataA+ivDataB) !== {oCout,ovpSumOut}) 
        $display("@%0d ERROR - ivDataA (%0d) + ivDataB (%0d) != {oCout,ovpSumOut} (%0d)",$time,iDataA,iDataB,{oCout,ovpSumOut});
      else
        $display("@%0d - ivDataA (%0d) + ivDataB (%0d) != {oCout,ovpSumOut} (%0d)",$time,iDataA,iDataB,{oCout,ovpSumOut});
      
      #1 
      {ivDataB,ivDataA} = {ivDataB,ivDataA}+1;
      
      if ({ivDataB,ivDataA} == 0) #2 $finish();
    end
  end

//  always @* s_l = #3 s;


  //  always @* s_d = repeat(3) //@(posedge a[0]) s_l;
  
  // Process to dump waves and finish sim
//  initial begin
//    $dumpfile("dump.vcd"); 
//    $dumpvars;
//    #260000 $finish();    
//  end  
  
  
endmodule

