`timescale 1ns / 1ps
module lfsr(
    input clk,seed_set,
    output reg[7:0] n1,n2);
    reg [15:0]out_temp,out;
    always @(posedge clk)
     if(seed_set) begin
        out<=14472;
        n1<={out[4],out[5],out[6],out[7],out[8],out[9],out[10],out[11]};
        n2<={out[6],out[7],out[8],out[9],out[10],out[11],out[12],out[13]}; end
      else begin
        out<=out_temp;
         n1<={out[4],out[5],out[6],out[7],out[8],out[9],out[10],out[11]};
         n2<={out[6],out[7],out[8],out[9],out[10],out[11],out[12],out[13]}; end
        
     always @(*)
        out_temp = {out[14:0],out[15]^out[4]^out[2]^out[1]};         
endmodule
