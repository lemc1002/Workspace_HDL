//mux 2 to 1

module mux2to1 #(parameter NUM_BITS=4)
(
	input	[NUM_BITS-1:00] iw_dataA,
	input	[NUM_BITS-1:00] iw_dataB,
	input iw_sel,
	output reg [NUM_BITS-1:00] or_muxout
);

always @(*) begin
	or_muxout = (iw_sel)? iw_dataB : iw_dataA;
end

endmodule