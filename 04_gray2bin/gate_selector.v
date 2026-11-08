	// Top-level with generate case
module gate_selector #(parameter GATE_TYPE = 3)
	(input a, b, output x);

	generate
		case (GATE_TYPE)
			0: begin 
				assign x = a & b;
			end
			1: begin 
				assign x = a | b;
			end
			default: begin 
				assign x = a | b & a;
			end
		endcase
	endgenerate
endmodule
