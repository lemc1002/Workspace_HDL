`timescale 10ns/1ns
module tb_topAlu();
	reg iDATAA;
	reg iDATAB;
	reg iDATAC;
	reg iDATAD;
	reg [3:0]ivSel;
	wire oMuxOut;
	
	reg expected;

	integer i;
	integer pass_count;
	integer fail_count;
	
	
	
	
top_alu dut(
	.ivDATAA(iDATAA),
	.ivDATAB(iDATAB),
	.ivSel(ivSel),
	.oMuxOut(oMuxOut)
);


endmodule




// one bit gate behaviour
//module tb_topAlu();
//
//	reg iDATAA;
//	reg iDATAB;
//	reg iDATAC;
//	reg iDATAD;
//	reg [3:0]ivSel;
//	wire oMuxOut;
//	
//	reg expected;
//
//	integer i;
//	integer pass_count;
//	integer fail_count;
//	
//	
//	
//	
//top_alu dut(
//	.ivDATAA(iDATAA),
//	.ivDATAB(iDATAB),
//	.ivSel(ivSel),
//	.oMuxOut(oMuxOut)
//);
//
//initial begin
//	{iDATAB,iDATAA} = 1'b0;
//	
//	 pass_count = 0;
//    fail_count = 0;
//
//    $display("-------------------------------------------------");
//    $display("Sel A B C D | Exp Out | Result");
//    $display("-------------------------------------------------");
//
//    for(i=0; i<128; i=i+1) begin
//
//        {ivSel,iDATAA,iDATAB,iDATAC,iDATAD} = i;
//        #10; // time for signal propagation
//
//        case(ivSel)
//            4'b0000: expected = iDATAA & iDATAB;
//            4'b0001: expected = iDATAA | iDATAB;
//            4'b0010: expected = iDATAA ^ iDATAB;
//            4'b0011: expected = !iDATAA;
//				4'b0100: expected = !iDATAA;
//        endcase
//		  #10; // time for signal propagation
//		  
//        if(expected == oMuxOut) begin
//            pass_count = pass_count + 1;
//            $display(" %b %b %b %b  %b   %b        %b     PASS",
//					ivSel,iDATAA,iDATAB,iDATAC,iDATAD,
//					expected,oMuxOut);
//        end
//        else begin
//            fail_count = fail_count + 1;
//            $display(" %b %b %b %b  %b   %b        %b     FAIL",
//					ivSel,iDATAA,iDATAB,iDATAC,iDATAD,
//					expected,oMuxOut);
//        end
//			{ivSel,iDATAD,iDATAC,iDATAB,iDATAA} =
//			{ivSel,iDATAD,iDATAC,iDATAB,iDATAA} + 6'h1;
//	end //for
//	
//	if({ivSel,iDATAD,iDATAC,iDATAB,iDATAA} == 6'h0) begin
//		$display("-----------------------");
//		$display("PASS = %0d", pass_count);
//		$display("FAIL = %0d", fail_count);
//		$display("-----------------------");
//		$stop;
//	end //if
//
//	
//	
//end
//
//endmodule