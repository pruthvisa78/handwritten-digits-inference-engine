`timescale 1ns / 1ps

module test_bench();
reg clk,data_read,rst;
wire [9:0] data_out;
wire valid;
reg [15:0] data_in;

top_module DUT(clk,rst,data_in,data_read,valid,data_out);

always #5 clk=~clk;

initial begin
#100 clk=0;rst=0;data_in=0;data_read=0; #100
#4 rst=1;data_read=1; 
//////// ZERO ////////
#10 data_in=16'b0000011111100000;
#10 data_in=16'b0000111000111000;
#10 data_in=16'b0001110000011100;
#10 data_in=16'b0011100000001110;
#10 data_in=16'b0011000000000111;
#10 data_in=16'b0110000000000011;
#10 data_in=16'b1110000000000011;
#10 data_in=16'b1100000000000011;
#10 data_in=16'b1100000000000011;
#10 data_in=16'b1110000000000011;
#10 data_in=16'b1010000000000110;
#10 data_in=16'b1011000000001110;
#10 data_in=16'b1011000000011000;
#10 data_in=16'b1011100011111000;
#10 data_in=16'b0001111111000000;
#10 data_in=16'b0000011100000000; data_read=0; 
$display("Input Digit is 0");
@ (posedge valid)
////////// ONE ////////////
#20 data_read=1;
#10 data_in=16'b0000000000000111;
#10 data_in=16'b0000000000000111;
#10 data_in=16'b0000000000000111;
#10 data_in=16'b0000000000001110;
#10 data_in=16'b0000000000001110;
#10 data_in=16'b0000000000111110;
#10 data_in=16'b0000000001111110;
#10 data_in=16'b0000000011111100;
#10 data_in=16'b0000001111101100;
#10 data_in=16'b0000011110001100;
#10 data_in=16'b1111111000001100;
#10 data_in=16'b0000000000001100;
#10 data_in=16'b0000000000001100;
#10 data_in=16'b0000000000001100;
#10 data_in=16'b0000000000001100;
#10 data_in=16'b0000000000000100; data_read=0;
$display("Input Digit is 1 -----");
@ (posedge valid)
//////////// TWO ////////////
#20 data_read=1;
#10 data_in=16'b0001111111000000;
#10 data_in=16'b0011100011000000;
#10 data_in=16'b0110000011100000;
#10 data_in=16'b1100000001100000;
#10 data_in=16'b1100000011100000;
#10 data_in=16'b0110001111000000;
#10 data_in=16'b0011111110000000;
#10 data_in=16'b0000011000000000;
#10 data_in=16'b0000011000000000;
#10 data_in=16'b0001110000000000;
#10 data_in=16'b0011000000000000;
#10 data_in=16'b0111000000000000;
#10 data_in=16'b1100000000000000;
#10 data_in=16'b1111010000000000;
#10 data_in=16'b0111111111111111;
#10 data_in=16'b0000000000011110; data_read=0;
$display("Input Digit is 2 -----");
//////////////THREE/////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b0011111111000000;
#10 data_in=16'b1111000011100000;
#10 data_in=16'b1000000001100000;
#10 data_in=16'b0000000001100000;
#10 data_in=16'b0000000001100000;
#10 data_in=16'b0000000111100000;
#10 data_in=16'b0100011110000000;
#10 data_in=16'b1111111111100000;
#10 data_in=16'b0000000001111100;
#10 data_in=16'b0000000000001110;
#10 data_in=16'b0000000000000110;
#10 data_in=16'b0000000000000011;
#10 data_in=16'b0000000000000011;
#10 data_in=16'b0111000000000011;
#10 data_in=16'b1111111111111111;
#10 data_in=16'b0000111111111100; data_read=0;
$display("Input Digit is 3 -----");
///////// FOUR////////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b0000001100000000;
#10 data_in=16'b0000011100000000;
#10 data_in=16'b0000111000000000;
#10 data_in=16'b0000110000000000;
#10 data_in=16'b0001110000000000;
#10 data_in=16'b0011100000001111;
#10 data_in=16'b0111000001111111;
#10 data_in=16'b1110000011100111;
#10 data_in=16'b1110011111000111;
#10 data_in=16'b1111111000001110;
#10 data_in=16'b1111000000011100;
#10 data_in=16'b0000000000011000;
#10 data_in=16'b0000000000111000;
#10 data_in=16'b0000000000110000;
#10 data_in=16'b0000000000111110;
#10 data_in=16'b0000000000011000;data_read=0;
$display("Input Digit is 4 -----");
//////// FIVE /////////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b0000000011111111;
#10 data_in=16'b0111111111111110;
#10 data_in=16'b1100000000000000;
#10 data_in=16'b1000000000000000;
#10 data_in=16'b1100000000000000;
#10 data_in=16'b1100000000000000;
#10 data_in=16'b0110000000000000;
#10 data_in=16'b0011000000000000;
#10 data_in=16'b0000000000000000;
#10 data_in=16'b0000000000000000;
#10 data_in=16'b0000000001110000;
#10 data_in=16'b0000000000110000;
#10 data_in=16'b1100000011110000;
#10 data_in=16'b1100000110000000;
#10 data_in=16'b1111111110000000;
#10 data_in=16'b0001000000000000;data_read=0;
$display("Input Digit is 5 -----");
//////////// SIX //////////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b0000000000001111;
#10 data_in=16'b0000000000111100;
#10 data_in=16'b0000000001111000;
#10 data_in=16'b0000000111100000;
#10 data_in=16'b0000001110000000;
#10 data_in=16'b0000011100000000;
#10 data_in=16'b0001111000000000;
#10 data_in=16'b0011110000000000;
#10 data_in=16'b0011001111100000;
#10 data_in=16'b1111111111110000;
#10 data_in=16'b1111100000110000;
#10 data_in=16'b1110000000111000;
#10 data_in=16'b1100000111110000;
#10 data_in=16'b1110011110000000;
#10 data_in=16'b1111111100000000;
#10 data_in=16'b0011100000000000;data_read=0;
$display("Input Digit is 6 -----");
/////////// SEVEN /////////////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b0000000000111111;
#10 data_in=16'b1111111111111111;
#10 data_in=16'b1111111110001110;
#10 data_in=16'b0000000000011110;
#10 data_in=16'b0000000000011000;
#10 data_in=16'b0000000000111000;
#10 data_in=16'b0000000001110000;
#10 data_in=16'b0000000011100000;
#10 data_in=16'b0000001111111000;
#10 data_in=16'b0000001111111100;
#10 data_in=16'b0000011100000000;
#10 data_in=16'b0000011000000000;
#10 data_in=16'b0000111000000000;
#10 data_in=16'b0000110000000000;
#10 data_in=16'b0001110000000000;
#10 data_in=16'b0000100000000000;data_read=0;
$display("Input Digit is 7 -----");
//////////// EIGHT //////////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b0000001111111110;
#10 data_in=16'b0000011000000110;
#10 data_in=16'b0000111000000111;
#10 data_in=16'b0000011000001110;
#10 data_in=16'b0000011100011100;
#10 data_in=16'b0000001111111000;
#10 data_in=16'b0000000011100000;
#10 data_in=16'b0000001111000000;
#10 data_in=16'b0000111111100000;
#10 data_in=16'b0001110000111000;
#10 data_in=16'b0111100000011100;
#10 data_in=16'b1110000000001100;
#10 data_in=16'b1110000000001100;
#10 data_in=16'b1110000000011100;
#10 data_in=16'b0111111111100000;
#10 data_in=16'b0000111110000000;data_read=0;
$display("Input Digit is 8 -----");

/////// NINE ///////////
@ (posedge valid)
#20 data_read=1;
#10 data_in=16'b1111111111000000;
#10 data_in=16'b1100000001100000;
#10 data_in=16'b1110000001100000;
#10 data_in=16'b1111111111110000;
#10 data_in=16'b0011111111111000;
#10 data_in=16'b0001111111110000;
#10 data_in=16'b0000000001110000;
#10 data_in=16'b0000000000110000;
#10 data_in=16'b0000000000111000;
#10 data_in=16'b0000000000011100;
#10 data_in=16'b0000000000001110;
#10 data_in=16'b0000000000000110;
#10 data_in=16'b0011111100000011;
#10 data_in=16'b0011111111100011;
#10 data_in=16'b0000000011111111;
#10 data_in=16'b0000000000001110;data_read=0;
$display("Input Digit is 9 -----");
@ (posedge valid)#10 $finish;
end
always @(posedge valid)
    case(data_out)
    10'd512:$display("Predicted Digit is 0");
    10'd256:$display("Predicted Digit is 1");
    10'd128:$display("Predicted Digit is 2");
    10'd64:$display("Predicted Digit is 3");
    10'd32:$display("Predicted Digit is 4");
    10'd16:$display("Predicted Digit is 5");
    10'd8:$display("Predicted Digit is 6");
    10'd4:$display("Predicted Digit is 7");
    10'd2:$display("Predicted Digit is 8");
    10'd1:$display("Predicted Digit is 9");
    default:$display("Couldn't Infer"); endcase

endmodule
