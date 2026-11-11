//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Cuauhtemoc Aguilera
// Functional model of a parametric register
// with asynchronous reset.
//////////////////////////////////////////////////////////////////////////////////
module Reg_Param_n  #(parameter width=4)(
    input iRst_n,
    input [width-1:0]D,
    input clk,
    input enable,
    output reg [width-1:0]Q
    );
always @(posedge clk)
    begin
        if (!iRst_n)
            Q <= {width{1'b0}};
        else
            if (enable)
                Q <= D;
            else
                Q <= Q;    
    end    
endmodule
