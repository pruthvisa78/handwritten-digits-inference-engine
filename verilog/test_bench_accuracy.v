`timescale 1ns / 1ps

module test_bench_accuracy();
reg clk,data_read,rst;
wire [9:0] data_out;
wire valid;
reg [15:0] data_in;
reg [3:0] digit [0:492];
reg [15:0] test [0:492][0:15];
reg [8:0] count;
integer i,j;
reg [3:0] predicted;
top_module DUT(clk,rst,data_in,data_read,valid,data_out);
initial begin
$readmemh("Digit.txt",digit);
$readmemb("test_patt.txt",test);end
always #5 clk=~clk;

initial begin
#100 count=0;i=0;clk=0;rst=0;data_in=0;data_read=0;j=0; #200
#4 rst=1;
for(i=0;i<493;i=i+1)begin
  #20 data_read=1;
  for(j=0;j<16;j=j+1)begin
    #10 data_in=test[i][j];
  end
  data_read=0;
  $display("Input digit is %d",digit[i]);
  @(posedge valid) begin
    if(predicted==digit[i-1])
       count<=count+1;end
end
 #10 $display("count = %d",count);
 #10 $finish;
 
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
    
always @(posedge valid)
    case(data_out)
    10'd512:predicted=0;
    10'd256:predicted=1;
    10'd128:predicted=2;
    10'd64:predicted=3;
    10'd32:predicted=4;
    10'd16:predicted=5;
    10'd8:predicted=6;
    10'd4:predicted=7;
    10'd2:predicted=8;
    10'd1:predicted=9; endcase


endmodule
