// ITESO
// Cuauhtemoc Aguilera
// Testbench fo a Parametric Right-Shift Register,
// with high-active synchronous reset.

`timescale 1ns / 1ps
module Shift_Register_R_Param_n_TB ( );

localparam width = 4;
reg clk, rst, enable, d;
wire [width-1:0] Q;

Shift_Register_R_Param_n # (.width (width) )
   UUT (.clk(clk), .rst(rst), .enable(enable),.d(d), .Q(Q) );
    
initial
	begin
		clk 		= 1'b0;
		rst 		= 1'b1;
		enable	= 1'b1;
		d 		= 1'b0;
		#5 rst	= 1'b0;
		   rst	= 1'b1;
	  #225  rst	= 1'b0;
	  #15	rst 		= 1'b1;
	end
initial begin
  #300;
    $stop;
end
always
	begin
	  #10 clk = ~clk;
	end

always
	begin
	  #20  d = ~d;
	  #20  d = ~d;
	  #100 d = ~d;
	  #100  d = ~d;
	end	
endmodule