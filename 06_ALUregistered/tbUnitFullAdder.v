`timescale 1ns/1ps

module tb_mUnitFullAdder;

	// DUT inputs
	reg iClk;
	reg inRst;
	reg inEn;
	
	reg iDataA;
	reg iDataB;
	reg iCin;

	// DUT outputs
	wire oSumOut;
	wire oCout;

	// Expected values
	reg expSum;
	reg expCout;

	// Error counter
	integer i;
	integer error_count;

	//--------------------------------------------------
	// DUT
	//--------------------------------------------------
	mUnitFullAdder DUT
	(
		.iClk    (iClk),
		.inRst   (inRst),
		.inEn    (inEn),
		.iDataA  (iDataA),
		.iDataB  (iDataB),
		.iCin    (iCin),
		.oSumOut (oSumOut),
		.oCout   (oCout)
	);

	//--------------------------------------------------
	// Clock generation
	//--------------------------------------------------
	initial
	begin
		iClk = 1'b0;
		forever #5 iClk = ~iClk;
	end

	//--------------------------------------------------
	// Test
	//--------------------------------------------------
	initial
	begin
		error_count = 0;

		inRst  = 0;
		inEn   = 0;
		iDataA = 0;
		iDataB = 0;
		iCin   = 0;

		// Reset
		#14;
		inRst = 1;

		$display("------------------------------------------------");
		$display(" A B Cin | EXP_COUT EXP_SUM | DUT_COUT DUT_SUM");
		$display("------------------------------------------------");

		// Test all combinations
		for(i=0; i<8; i=i+1)
		begin
			{iDataA,iDataB,iCin} = i[2:0];

			// Expected result
			{expCout,expSum} = iDataA + iDataB + iCin;

			@(posedge iClk);
			#1;

			$display(" %b %b  %b  |     %b       %b    |     %b       %b",
					 iDataA,
					 iDataB,
					 iCin,
					 expCout,
					 expSum,
					 oCout,
					 oSumOut);

			if({oCout,oSumOut} !== {expCout,expSum})
			begin
				error_count = error_count + 1;

				$display("ERROR @%0t : A=%b B=%b Cin=%b Expected=%b%b Got=%b%b",
						 $time,
						 iDataA,
						 iDataB,
						 iCin,
						 expCout,
						 expSum,
						 oCout,
						 oSumOut);
			end
		end

		$display("------------------------------------------------");
		$display("TOTAL ERRORS = %0d", error_count);
		$display("------------------------------------------------");

		if(error_count == 0)
			$display("TEST PASSED");
		else
			$display("TEST FAILED");

		$stop;
	end

endmodule