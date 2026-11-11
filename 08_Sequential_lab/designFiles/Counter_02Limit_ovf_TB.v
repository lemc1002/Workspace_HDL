`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Cuauhtemoc Aguilera
////////////////////////////////////////////////////////////////////////////
module Counter_02Limit_ovf_TB(    );
localparam N = 8;     // Correct: compile-time constant
localparam Limit = 8'h80; // Correct: compile-time constant

reg rst, clk, enable;
wire [N-1:0]Q;
wire overflow;
Counter_02Limit_ovf #(
    .N(N),
    .Limit(Limit)
) UUT (
    .rst(rst),
    .enable(enable),
    .clk(clk),
    .Q(Q),
    .overflow(overflow)
);
initial begin
  #1000;
    $stop;
end
initial
    begin
        rst = 1'b1;
        clk = 1'b0;
        enable = 1'b1;
        #5 rst = 1'b0;
    end                                                                                
always
    begin
        #10 clk = ~clk;
    end                                      
endmodule
