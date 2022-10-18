`timescale 1ns / 1ps

module MUL_16(enable,a,b,c);
input enable;
input signed [15:0]a,b;
output reg signed [31:0] c;
always @(*)
if(enable)
    c=a*b;
else
    c=0;
endmodule

