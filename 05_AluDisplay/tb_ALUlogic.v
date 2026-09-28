//Operations test

`timescale 10ns/1ns

module tb_ALUlogic();


  localparam ADDER_SIZE = 4;
  
  	reg  	[ADDER_SIZE-1:0]	ivDataA;
	reg  	[ADDER_SIZE-1:0]	ivDataB;
	reg  	[ADDER_SIZE-1:0]	ivDataC;
	reg  	[ADDER_SIZE-1:0]	ivDataD;
	reg	[ADDER_SIZE-1:0]	expected;
	wire 	[ADDER_SIZE-1:0]	ovMuxOut;
	wire oCout;
	reg  [1:0] ivSel;
	
	integer i;
	integer pass_count;
	integer fail_count;
 
	mALUlogic #(.TRUNC(ADDER_SIZE))  
	ALUlogicDut(
		.ivDataA(ivDataA),
		.ivDataB(ivDataB),
		.ovMuxOut(ovMuxOut),
		.oOvf(oCout),
		.ivSel(ivSel)
	);

	initial begin
	
	 $display("-------------------------------------------------");
    $display("Sel A B C D | Exp Out | Result");
    $display("-------------------------------------------------");

    for(i=0; i<1024; i=i+1) begin

        {ivSel,ivDataD,ivDataC,ivDataB,ivDataA} = i;
		  #1; // deja propagar señales

        case(ivSel)
            2'b00: expected = ivDataA - ivDataB;
            2'b01: expected = ~(ivDataA + ivDataB) + 1;
            2'b10: expected = ivDataA;
            2'b11: expected = ivDataB;
        endcase
		  #1; // deja propagar señales

        if(expected == ovMuxOut) begin
            pass_count = pass_count + 1;
            $display(" %b %b %b %b  %b   %b        %b     PASS",
					ivSel,ivDataA,ivDataB,ivDataC,ivDataD,
					expected,ovMuxOut);
        end
        else begin
            fail_count = fail_count + 1;
            $display(" %b %b %b %b  %b   %b        %b     FAIL",
					ivSel,ivDataA,ivDataB,ivDataC,ivDataD,
					expected,ovMuxOut);
        end
			{ivSel,ivDataD,ivDataC,ivDataB,ivDataA} =
			{ivSel,ivDataD,ivDataC,ivDataB,ivDataA} + 6'h1;
	end //for
	
	if({ivSel,ivDataD,ivDataC,ivDataB,ivDataA} == 6'h0) begin
		$display("-----------------------");
		$display("PASS = %0d", pass_count);
		$display("FAIL = %0d", fail_count);
		$display("-----------------------");
		$stop;
	end
end

endmodule 

	
//	{ivDataB,ivDataA} = 1'b0;
//    $display("Init {ivDataB,ivDataA} = 0");
//		
//	
//    
//	 forever begin
//			#1
//			expected = ivDataA - ivDataB;
//			if  ( ovMuxOut !== expected )
//			  $display("@%0d ERROR => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			else
//			  $display("@%0d => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			
//			#1
//			{ivDataB,ivDataA} = {ivDataB,ivDataA}+1;
//			
//			if ({ivDataB,ivDataA} == 0) #2 $finish();
//
//		end //forever
//	 
//  end //initial
//
//	
//	////   
//	initial begin
//	//    $dumpfile("dump.vcd"); 
//	//    $dumpvars;
//	 #164 $stop();    
//	end 
//

//MUX 16to1 test
//
//`timescale 10ns/1ns
//
//module tb_ALUlogic();
//
//  localparam ADDER_SIZE = 4;
//  
//	reg  	[ADDER_SIZE-1:0]	ivData00;
//	reg  	[ADDER_SIZE-1:0]	ivData01;
//	reg  	[ADDER_SIZE-1:0]	ivData02;
//	reg  	[ADDER_SIZE-1:0]	ivData03;
//	reg  	[ADDER_SIZE-1:0]	ivData04;
//	reg  	[ADDER_SIZE-1:0]	ivData05;
//	reg  	[ADDER_SIZE-1:0]	ivData06;
//	reg  	[ADDER_SIZE-1:0]	ivData07;
//	reg  	[ADDER_SIZE-1:0]	ivData08;
//	
//	reg  	[ADDER_SIZE-1:0]	ivData09;
//	reg  	[ADDER_SIZE-1:0]	ivData0A;
//	reg  	[ADDER_SIZE-1:0]	ivData0B;
//	reg  	[ADDER_SIZE-1:0]	ivData0C;
//	reg  	[ADDER_SIZE-1:0]	ivData0D;
//	reg  	[ADDER_SIZE-1:0]	ivData0E;
//	reg  	[ADDER_SIZE-1:0]	ivData0F;
//	
//	reg	[ADDER_SIZE-1:0]	expected;
//	wire 	[ADDER_SIZE-1:0]	ovMuxOut;
//	
//	wire oCout;
//	reg  [3:0] ivSel;
//	
//	integer i;
//	integer pass_count;
//	integer fail_count;
// 
//	mux16to1 #(.NUM_BITS(ADDER_SIZE))
//	DUT(
//		 .ivData00(ivData00),
//		 .ivData01(ivData01),
//		 .ivData02(ivData02),
//		 .ivData03(ivData03),
//		 .ivData04(ivData04),
//		 .ivData05(ivData05),
//		 .ivData06(ivData06),
//		 .ivData07(ivData07),
//		 .ivData08(ivData08),
//		 .ivData09(ivData09),
//		 .ivData0A(ivData0A),
//		 .ivData0B(ivData0B),
//		 .ivData0C(ivData0C),
//		 .ivData0D(ivData0D),
//		 .ivData0E(ivData0E),
//		 .ivData0F(ivData0F),
//		 .ivSel(ivSel),
//		 .ovMuxout(ovMuxOut)
//	);
//
//initial begin
//
//    ivData00 = 4'h0;
//    ivData01 = 4'h1;
//    ivData02 = 4'h2;
//    ivData03 = 4'h3;
//    ivData04 = 4'h4;
//    ivData05 = 4'h5;
//    ivData06 = 4'h6;
//    ivData07 = 4'h7;
//
//    ivData08 = 4'h8;
//    ivData09 = 4'h9;
//    ivData0A = 4'hA;
//    ivData0B = 4'hB;
//    ivData0C = 4'hC;
//    ivData0D = 4'hD;
//    ivData0E = 4'hE;
//    ivData0F = 4'hF;
//	#1;
//end
//
//initial begin
//
//    pass_count = 0;
//    fail_count = 0;
//
//    $display("----------------------------------------");
//    $display("SEL | EXP | OUT");
//    $display("----------------------------------------");
//
//    for(i=0;i<16;i=i+1)
//    begin
//
//        ivSel = i[3:0];
//
//        #1;
//
//        expected = i[3:0];
//
//        if(expected == ovMuxOut)
//        begin
//            pass_count = pass_count + 1;
//
//            $display("%h    %h     %h   PASS",
//                     ivSel,
//                     expected,
//                     ovMuxOut);
//        end
//        else
//        begin
//            fail_count = fail_count + 1;
//
//            $display("%h    %h     %h   FAIL",
//                     ivSel,
//                     expected,
//                     ovMuxOut);
//        end
//
//    end
//
//    $display("---------------------");
//    $display("PASS = %0d",pass_count);
//    $display("FAIL = %0d",fail_count);
//    $display("---------------------");
//
//    $finish;
//end

////SUB
//`timescale 10ns/1ns
//
//module tb_ALUlogic();
//
//  localparam ADDER_SIZE = 4;
//  
//  	reg  	[ADDER_SIZE-1:0]	ivDataA;
//	reg  	[ADDER_SIZE-1:0]	ivDataB;
//	reg  	[ADDER_SIZE-1:0]	ivDataC;
//	reg  	[ADDER_SIZE-1:0]	ivDataD;
//	reg	[ADDER_SIZE-1:0]	expected;
//	wire 	[ADDER_SIZE-1:0]	ovMuxOut;
//	wire oCout;
//	reg  [1:0] ivSel;
//	
//	integer i;
//	integer pass_count;
//	integer fail_count;
// 
//	mALUlogic #(.TRUNC(ADDER_SIZE))  
//	ALUlogicDut(
//		.ivDataA(ivDataA),
//		.ivDataB(ivDataB),
//		.ovMuxOut(ovMuxOut),
//		.oOvf(oCout),
//		.ivSel(ivSel)
//	);
//
//	initial begin
//	
//	 $display("-------------------------------------------------");
//    $display("Sel A B C D | Exp Out | Result");
//    $display("-------------------------------------------------");
//
//    for(i=0; i<1024; i=i+1) begin
//
//        {ivSel,ivDataD,ivDataC,ivDataB,ivDataA} = i;
//		  #1; // deja propagar señales
//
//        case(ivSel)
//            2'b00: expected = ivDataA - ivDataB;
//            2'b01: expected = ~(ivDataA + ivDataB) + 1;
//            2'b10: expected = ivDataA;
//            2'b11: expected = ivDataB;
//        endcase
//		  #1; // deja propagar señales
//
//        if(expected == ovMuxOut) begin
//            pass_count = pass_count + 1;
//            $display(" %b %b %b %b  %b   %b        %b     PASS",
//					ivSel,ivDataA,ivDataB,ivDataC,ivDataD,
//					expected,ovMuxOut);
//        end
//        else begin
//            fail_count = fail_count + 1;
//            $display(" %b %b %b %b  %b   %b        %b     FAIL",
//					ivSel,ivDataA,ivDataB,ivDataC,ivDataD,
//					expected,ovMuxOut);
//        end
//			{ivSel,ivDataD,ivDataC,ivDataB,ivDataA} =
//			{ivSel,ivDataD,ivDataC,ivDataB,ivDataA} + 6'h1;
//	end //for
//	
//	if({ivSel,ivDataD,ivDataC,ivDataB,ivDataA} == 6'h0) begin
//		$display("-----------------------");
//		$display("PASS = %0d", pass_count);
//		$display("FAIL = %0d", fail_count);
//		$display("-----------------------");
//		$stop;
//	end
//end
	
//	{ivDataB,ivDataA} = 1'b0;
//    $display("Init {ivDataB,ivDataA} = 0");
//		
//	
//    
//	 forever begin
//			#1
//			expected = ivDataA - ivDataB;
//			if  ( ovMuxOut !== expected )
//			  $display("@%0d ERROR => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			else
//			  $display("@%0d => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			
//			#1
//			{ivDataB,ivDataA} = {ivDataB,ivDataA}+1;
//			
//			if ({ivDataB,ivDataA} == 0) #2 $finish();
//
//		end //forever
//	 
//  end //initial
//
//	
//	////   
//	initial begin
//	//    $dumpfile("dump.vcd"); 
//	//    $dumpvars;
//	 #164 $stop();    
//	end 
//
//endmodule 

// SUM
//`timescale 10ns/1ns
//
//module tb_ALUlogic();
//
//  localparam ADDER_SIZE = 4;
//  
//  	reg  	[ADDER_SIZE-1:0]	ivDataA;
//	reg  	[ADDER_SIZE-1:0]	ivDataB;
//	reg	[ADDER_SIZE-1:0]	expected;
//	wire 	[ADDER_SIZE-1:0]	ovMuxOut;
//	wire oCout;
// 
//	mALUlogic #(.TRUNC(ADDER_SIZE))  
//	ALUlogicDut(
//		.ivDataA(ivDataA),
//		.ivDataB(ivDataB),
//		.ovMuxOut(ovMuxOut),
//		.oCout(oCout)	
//	);
//
//	initial begin
//	{ivDataB,ivDataA} = 1'b0;
//    $display("Init {ivDataB,ivDataA} = 0");
//		
//	
//    
//	 forever begin
//			#1
//			expected = ~(ivDataA + ivDataB) + 1;
//			if  ( ovMuxOut !== expected )
//			  $display("@%0d ERROR => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			else
//			  $display("@%0d => -ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			
//			#1
//			{ivDataB,ivDataA} = {ivDataB,ivDataA}+1;
//			
//			if ({ivDataB,ivDataA} == 0) #2 $finish();
//
//		end //forever
//	 
//  end //initial
//
//	
//	////   
//	initial begin
//	//    $dumpfile("dump.vcd"); 
//	//    $dumpvars;
//	 #164 $stop();    
//	end 
//
//endmodule 

////SUB
//`timescale 10ns/1ns
//
//module tb_ALUlogic();
//
//  localparam ADDER_SIZE = 4;
//  
//  	reg  	[ADDER_SIZE-1:0]	ivDataA;
//	reg  	[ADDER_SIZE-1:0]	ivDataB;
//	reg	[ADDER_SIZE-1:0]	expected;
//	wire 	[ADDER_SIZE-1:0]	ovMuxOut;
//	wire oCout;
// 
//	mALUlogic #(.TRUNC(ADDER_SIZE))  
//	ALUlogicDut(
//		.ivDataA(ivDataA),
//		.ivDataB(ivDataB),
//		.ovMuxOut(ovMuxOut),
//		.oOvf(oCout),
//		.ivSel(ivSel)
//	);
//
//	initial begin
//	{ivDataB,ivDataA} = 1'b0;
//    $display("Init {ivDataB,ivDataA} = 0");
//		
//	
//    
//	 forever begin
//			#1
//			expected = ivDataA - ivDataB;
//			if  ( ovMuxOut !== expected )
//			  $display("@%0d ERROR => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			else
//			  $display("@%0d => ivDataA (%0d) - ivDataB (%0d) != {oCout,ovMuxOut} (%0d)",$time,ivDataA,ivDataB,{oCout,ovMuxOut});
//			
//			#1
//			{ivDataB,ivDataA} = {ivDataB,ivDataA}+1;
//			
//			if ({ivDataB,ivDataA} == 0) #2 $finish();
//
//		end //forever
//	 
//  end //initial
//
	
