/************************************************************************
*	Module name:
*		FFTypeD.sv
*	Description:
*		Type d flip flop
*	Inputs:
*		D input
*		clock signal
*		reset signal
*		enable signal
*	Outputs:
*		Q output
*	Version:
*		1.0
*	Author:
*		José Aurelio Montes Ramírez
*	Date:
*		March 06th 2022
************************************************************************/

module FFTypeD
(
	input  D,
	input  clk,
	input  reset,
	input  enable,
	
	output reg Q
);



	always@(posedge clk or negedge reset)
	begin
			if(!reset)
				Q <= 0;
			else if (enable)
				Q <= D;
	end // always_ff

endmodule
