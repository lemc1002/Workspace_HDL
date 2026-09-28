module mux4to1 #(parameter NUM_BITS=4)
(
	input	wire [NUM_BITS-1:00]	ivDataA,
	input	wire [NUM_BITS-1:00]	ivDataB,
	input	wire [NUM_BITS-1:00]	ivDataC,
	input	wire [NUM_BITS-1:00]	ivDataD,
	input	wire [1:0] ivSel,
	output [NUM_BITS-1:00]	ovMuxout
);

wire [NUM_BITS-1:00] w_m;
wire [NUM_BITS-1:00] w_n;

mux2to1 mux_i0(.iw_dataA(ivDataA),.iw_dataB(ivDataB),.iw_sel(ivSel[0]),.or_muxout(w_m));
mux2to1 mux_i1(.iw_dataA(ivDataC),.iw_dataB(ivDataD),.iw_sel(ivSel[0]),.or_muxout(w_n));
mux2to1 mux_i2(.iw_dataA(w_m),.iw_dataB(w_n),.iw_sel(ivSel[1]),.or_muxout(ovMuxout));

endmodule