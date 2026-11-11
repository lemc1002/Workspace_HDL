//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Cuauhtemoc Aguilera
// Testbench of the Functional model of a parametric register
// with asynchronous reset.
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 10 ps
module Reg_Param_n_TB ();

localparam width = 8;

reg iRst_n, clk, enable;
reg  [width-1:0] D;
wire [width-1:0]Q;

Reg_Param_n   #( .width(width) ) UUT (.iRst_n(iRst_n), .D(D), .clk(clk), .enable(enable), .Q(Q)     );

initial
	begin
	iRst_n 		= 1'b1;
	D 		= 8'h00;
	clk 		= 1'b0;
	enable 	= 1'b1;
#5	iRst_n 		= 1'b0;
#3	iRst_n 		= 1'b1;
	end

initial begin
  #1000;
    $stop;
end

always
    begin
      # 10 clk = ~ clk;
    end    

always
    begin
	 
	 
      # 20 D = D + 1'b1;
    end    

always
    begin
      # 800 enable  = ~ enable;
      # 80 enable  = ~ enable;
    end

always
    begin
      # 840 iRst_n  = ~ iRst_n;
	 #   15 iRst_n  = ~ iRst_n;
    end
endmodule
