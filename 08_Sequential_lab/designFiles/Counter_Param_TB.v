// ITESO
// Cuauhtemoc Aguilera
// Testbench fo a Parametric Right-Shift Register,
// with high-active synchronous reset.

`timescale 1ns / 1ps
module Counter_Param_TB ( );

localparam n = 4;
reg clk, rst, enable;//, d;
wire [n-1:0] Q;

Counter_Param # (.n (n) )
   UUT (.clk(clk), .rst(rst), .enable(enable), .Q(Q) );
    
initial

	begin
	clk    = 1'b0;
    rst    = 1'b0;
    enable = 1'b1;

    #60  rst = 1'b1; // Assert reset high
    #20 rst = 1'b0; // Hold reset high for 20 ns, then release
	 
	end
initial begin
  #400;
    $stop;
end
always
	begin
	  #10 clk = ~clk;
	end

//always
//	begin
//	  #20  d = ~d;
//	  #20  d = ~d;
//	  #100 d = ~d;
//	  #100  d = ~d;
//	end	
endmodule