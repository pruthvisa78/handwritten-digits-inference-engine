`timescale 1ns / 1ps
module max(
input           clk,
input   [319:0] data,
input           enable,
output reg [9:0] out,
output  reg    valid
);

reg [31:0] max_val;
reg [319:0] data_buff;
reg [3:0] counter;
reg [3:0] cout;

always @(posedge clk)
 begin
    valid <= 1'b0;
    if(enable)
    begin
        max_val <= data[31:0];
        counter <= 1;
        data_buff <= data;
        cout<=0;
    end
    else if(counter == 10)
    begin
        counter <= 0;
        valid <= 1'b1;
    end
    else if(counter != 0)
    begin
        counter <= counter + 1;
        if($signed(data_buff[counter*32+:32]) > $signed(max_val))
        begin
            max_val <= data_buff[counter*32+:32];
            cout <= counter;
        end
    end
end
always @(cout)
    case(cout)
    4'b0000:out=10'b0000000001;
    4'b0001:out=10'b0000000010;
    4'b0010:out=10'b0000000100;
    4'b0011:out=10'b0000001000;
    4'b0100:out=10'b0000010000;
    4'b0101:out=10'b0000100000;
    4'b0110:out=10'b0001000000;
    4'b0111:out=10'b0010000000;
    4'b1000:out=10'b0100000000;
    4'b1001:out=10'b1000000000;
    default:out=10'b0000000000; endcase
endmodule