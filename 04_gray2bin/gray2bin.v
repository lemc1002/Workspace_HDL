

// Half Adder
module ha(input a, b, output reg sum, cout);
	always @(*) {cout, sum} = a + b;
	initial $display("Half adder instantiated");
endmodule

// Full Adder
module fa(input a, b, cin, output reg sum, cout);
	always @(*) {cout, sum} = a + b + cin;
	initial $display("Full adder instantiated");
endmodule

	// Top-level with generate case
module gate_selector #(parameter GATE_TYPE = 1)
	(input a, b, output x);

	generate
		case (GATE_TYPE)
			0: begin 
				assign x = a | b;
			end
			1: begin 
				assign x = a | b;
			end
			default: begin 
				assign x = a & b | b;
			end
		endcase
	endgenerate
endmodule



module gray2bin #(parameter N=4)
(
    input  wire [N-1:0] irb_gray,
    output wire [N-1:0] orb_bite
);

genvar i;

assign orb_bite[N-1] = irb_gray[N-1];

generate
    for(i=N-2; i>=0; i=i-1) begin : gen_gray
        assign orb_bite[i] = orb_bite[i+1] ^ irb_gray[i];
    end
endgenerate

endmodule
//
//module gray2bin #(parameter N=4) ( 
//    input [N-1:0] irb_gray,
//    output reg [N-1:0] orb_bite
//);
// 
//
//always @(*) begin
//	 genvar i;
//    orb_bite[N-1] = irb_gray[N-1];  
//    generate
//	 for (i = N-2; i >= 0; i = i - 1) 
//        orb_bite[i] = irb_gray[i]^orb_bite[i+1];
//	 
//end
//
//endmodule

//
//module initialconfig (
//	 input wire [9:0] SW,
//    input  wire [3:0] KEY,
//    output wire [9:0] LEDR,
//    output reg  [6:0] HEX0,
//    output reg  [6:0] HEX1,
//    output reg  [6:0] HEX2,
//    output reg  [6:0] HEX3,
//    output reg  [6:0] HEX4,
//    output reg  [6:0] HEX5
//);
//
//    // KEY1 pressed -> LEDR0 ON
//    // Pushbuttons are active low on the DE10 board
//    assign LEDR[0]   = ~KEY[1];
//    assign LEDR[7:1] = 9'b000000000;
//	 assign LEDR[8] = (~SW[0]&~SW[1]&SW[2])+(~SW[0]&SW[1]&~SW[2])+(SW[0]&~SW[1]&~SW[2])+(SW[0]&SW[1]&SW[2]);
//	 assign LEDR[9 ] = (~SW[0]&SW[1]&SW[2])+(SW[0]&~SW[1]&SW[2])+(SW[0]&SW[1]&~SW[2])+(SW[0]&SW[1]&SW[2]);
//
//    always @(*) begin
//
//        // KEY0 = Reset (active low)
//        if (!KEY[0]) begin
//            HEX0 = 7'b1111111;
//            HEX1 = 7'b1111111;
//            HEX2 = 7'b1111111;
//            HEX3 = 7'b1111111;
//            HEX4 = 7'b1111111;
//            HEX5 = 7'b1111111;
//        end
//
//        // KEY1 pressed -> display HELLO
//        else if (!KEY[1]) begin
//
//            // Segment order: {g,f,e,d,c,b,a}
//            // Active low segments
//
//            HEX5 = 7'b0001001; // H
//            HEX4 = 7'b0000110; // E
//            HEX3 = 7'b1000111; // L
//            HEX2 = 7'b1000111; // L
//            HEX1 = 7'b1000000; // O
//            HEX0 = 7'b1111111; // Blank
//
//        end
//
//        // Default state
//        else begin
//            HEX0 = 7'b1111111;
//            HEX1 = 7'b1111111;
//            HEX2 = 7'b1111111;
//            HEX3 = 7'b1111111;
//            HEX4 = 7'b1111111;
//            HEX5 = 7'b1111111;
//        end
//
//    end
//
//endmodule