// Code your testbench here
// or browse Examples

module tb_mux4to1;

	reg  iDataA;
	reg  iDataB;
	reg  iDataC;
	reg  iDataD;
	reg  [1:0] ivSel;

	wire oMuxout;

	reg expected;

	integer i;
	integer pass_count;
	integer fail_count;

mux4to1 dut(
    iDataA,
    iDataB,
    iDataC,
    iDataD,
    ivSel,
    oMuxout
);

initial begin

    pass_count = 0;
    fail_count = 0;

    $display("-------------------------------------------------");
    $display("Sel A B C D | Exp Out | Result");
    $display("-------------------------------------------------");

    for(i=0; i<64; i=i+1) begin

        {ivSel,iDataD,iDataC,iDataB,iDataA} = i;
		  #1; // deja propagar señales
        #10;

        case(ivSel)
            2'b00: expected = iDataA;
            2'b01: expected = iDataB;
            2'b10: expected = iDataC;
            2'b11: expected = iDataD;
        endcase
		  #10; // deja propagar señales

        if(expected == oMuxout) begin
            pass_count = pass_count + 1;
            $display(" %b %b %b %b  %b   %b        %b     PASS",
					ivSel,iDataA,iDataB,iDataC,iDataD,
					expected,oMuxout);
        end
        else begin
            fail_count = fail_count + 1;
            $display(" %b %b %b %b  %b   %b        %b     FAIL",
					ivSel,iDataA,iDataB,iDataC,iDataD,
					expected,oMuxout);
        end
			{ivSel,iDataD,iDataC,iDataB,iDataA} =
			{ivSel,iDataD,iDataC,iDataB,iDataA} + 6'h1;
	end //for
	
	if({ivSel,iDataD,iDataC,iDataB,iDataA} == 6'h0) begin
		$display("-----------------------");
		$display("PASS = %0d", pass_count);
		$display("FAIL = %0d", fail_count);
		$display("-----------------------");
		$stop;
	end

end

endmodule

//  
//  
//  // Aqui hacemos drive de las entradas
//  initial begin
//    #10;
//    {iDataA,iDataB,iDataC,iDataD,ivSel} = 6'h0; // Le asigno 6b en hexadecimal 0 a las entradas
//    
//    forever begin
//      #10 {ivSel,iDataD,iDataC,iDataB,iDataA}={ivSel,iDataD,iDataC,iDataB,iDataA}+6'h1;
//      
//      // Detenemos la sim al volver a iniciar las combinaciones
//      if ({ivSel,iDataD,iDataC,iDataB,iDataA}==6'h0) $stop;
//      
//    end
//  end 
//  endmodule
  
//  // Para generar formas de onda
//  initial begin
//    $dumpfile("dump.vcd"); 
//    $dumpvars;
//  end
   
 
