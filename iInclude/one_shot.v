//////////////////////////////////////////////////////////////////////////////////////////////////
//Company: ITESO                                                                                //
//Engineer: Ricardo Ruiz Ambriz                                                                 //
//Module description: This module generates a single pulse from a trigger signal using two     //
//D-type flip-flops to detect the trigger transition.                                           //
//Date: 09/28/2026                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////
module one_shot 
(
//Entradas
	input          clk,
	input 			reset,
	input        trigger,
//Salidas	
	output  		pulse
);

	wire first_pulse_w;
	wire second_pulse_w;
	reg response_r;

FFTypeD first
(
	.D(trigger),
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	
	.Q(first_pulse_w)
);

FFTypeD second
(
	.D(first_pulse_w),
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	
	.Q(second_pulse_w)
);

always @(*)	begin
		//response_r = (~second_pulse_w) & first_pulse_w;//Activo en alto
		response_r = second_pulse_w & (~first_pulse_w);//Activo en bajo
	end 

	assign pulse = !response_r;

endmodule 

