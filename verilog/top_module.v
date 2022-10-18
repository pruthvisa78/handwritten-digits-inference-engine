`timescale 1ns / 1ps

module top_module(
    input clk,
    input rst,
    input [15:0] data_in,
    input data_read,
    output reg valid,
    output reg [9:0] data_out
    );
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
 reg [2:0]PS,NS;
 parameter IDLE=2'b000,READ=2'b001,L1=2'b010,L2=2'b011,OUT=3'b100;
 reg hidden_con,output_con,hidden_comp,output_comp,max_con,lfsr_con;
 wire signed [7:0] a,b;
 reg signed [7:0] A,B;
 reg signed [15:0] acc_hidden [0:511];
 reg signed [31:0] acc_out [0:9]; 
 reg signed [15:0] W21;
 reg [255:0] data;
 reg [15:0] hidden_op;
 reg [3:0] i;
 reg [7:0] data_addr;
 reg [7:0] hidden_addr;
 reg [8:0] hidden_addr_out;
 reg [12:0] rom_addr;
 reg [3:0] out_addr;
 wire [9:0]data_out_temp;
 wire signed [15:0] w21_temp;
 wire valid_temp;
 reg signed [31:0] M0;
 wire signed [31:0] m0;
 
////////////////////////////////////////////////////////////////////////////
///////////////////////// Control PATH FSM /////////////////////////////////
///////////////////////////////////////////////////////////////////////////
always @(posedge clk,negedge rst)
    if(~rst)
        PS<=IDLE;
    else
        PS<=NS;
        
always @(PS,data_read,hidden_comp,max_con,output_comp)
    case(PS)
    IDLE:begin
        if(data_read) begin
            NS=READ; hidden_con=0;output_con=0; end
        else begin
            NS=IDLE; hidden_con=0;output_con=0; end end
    READ:begin
         if(~data_read)begin
            NS=L1;hidden_con=1;output_con=0;end
         else begin
            NS=READ; hidden_con=0;output_con=0; end end
    L1: begin
        if(hidden_comp)begin
            NS=L2;hidden_con=0;output_con=1;end
        else begin
            NS=L1;hidden_con=1;output_con=0; end end            
    L2:   
        if(max_con)begin
           NS=OUT;hidden_con=0;output_con=0;end
        else begin
            NS=L2; hidden_con=0;output_con=1;end
             
    OUT:if(output_comp)begin
            NS=IDLE;hidden_con=0;output_con=0;end
        else begin
            NS=OUT;hidden_con=0;output_con=0;end
    default: begin NS=IDLE; hidden_con=0;output_con=0;end
  endcase
     
 //////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////// COUNTERS - Addressing ////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////       
 /// DATA READ
 always @(posedge clk)
    if(PS==READ)
        i<=i+1; 
    else i<=0;
    
///// LFSR CONTROL
always @(posedge clk)
    if(i==12 || i==13)
        lfsr_con<=1;
     else
        lfsr_con<=0;   
                   
/// HIDDEN OPERATION COUNTER
 always @(posedge clk)
    if(PS==L1)begin
        hidden_addr<=hidden_addr+1;end
    else
        hidden_addr<=0;
    
 always @(posedge clk)
    if(PS==L1)begin
        if(&hidden_addr)
        data_addr<=data_addr-1;
        else
        data_addr<=data_addr; end
    else
        data_addr<=255;
// CHECK FOR COMPLETION OF HIDDEN OPERATION
always @(posedge clk)
    if(PS==L1)begin
        hidden_op<=hidden_op+1;
        hidden_comp<=&hidden_op;
    end
    else begin
        hidden_op<=0;
        hidden_comp<=0; end
// ROM ADDRESS        
 always @(posedge clk)
    if(PS==L2 && rom_addr<5119)
        rom_addr<=rom_addr+1;
    else
        rom_addr<=0;
 always @(posedge clk)       
        if(rom_addr==5119)
          max_con<=1;
        else
          max_con<=0;
     
// OUTPUT ACCUMULATOR ADDRESS
 always @(posedge clk)
    if(PS==L2 && out_addr<9)
        out_addr<=out_addr+1;
    else 
        out_addr<=0;
// HIDDEN LAYER ADDRESS FOR OUTPUT OPERATION
 always @(posedge clk)
    if(PS==L2 && out_addr==9)
        hidden_addr_out<=hidden_addr_out+1;
    else if(PS==IDLE)
        hidden_addr_out<=0;             
 
       
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////// DATA PATH ///////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
 /// LFSR FOR W10
 lfsr L(clk,lfsr_con,a,b);
 always @(a,b) begin
    A=a;
    B=b;end
 // DATA READ
 always @(posedge clk)
    if(PS==READ)begin
        data[255-16*i-:16]<=data_in; end 
    
////////// HIDDEN LAYER ////////
///accumualation
always @(posedge clk)
    if(PS==L1 && hidden_con)begin
        if(data[data_addr])begin
        acc_hidden[2*hidden_addr]<=acc_hidden[2*hidden_addr]+A;
        acc_hidden[2*hidden_addr+1]<=acc_hidden[2*hidden_addr+1]+B; end 
        else begin
        acc_hidden[2*hidden_addr]<=acc_hidden[2*hidden_addr];
        acc_hidden[2*hidden_addr+1]<=acc_hidden[2*hidden_addr+1];end end
else if(PS==IDLE) begin
acc_hidden[0]<=0;
acc_hidden[1]<=0;
acc_hidden[2]<=0;
acc_hidden[3]<=0;
acc_hidden[4]<=0;
acc_hidden[5]<=0;
acc_hidden[6]<=0;
acc_hidden[7]<=0;
acc_hidden[8]<=0;
acc_hidden[9]<=0;
acc_hidden[10]<=0;
acc_hidden[11]<=0;
acc_hidden[12]<=0;
acc_hidden[13]<=0;
acc_hidden[14]<=0;
acc_hidden[15]<=0;
acc_hidden[16]<=0;
acc_hidden[17]<=0;
acc_hidden[18]<=0;
acc_hidden[19]<=0;
acc_hidden[20]<=0;
acc_hidden[21]<=0;
acc_hidden[22]<=0;
acc_hidden[23]<=0;
acc_hidden[24]<=0;
acc_hidden[25]<=0;
acc_hidden[26]<=0;
acc_hidden[27]<=0;
acc_hidden[28]<=0;
acc_hidden[29]<=0;
acc_hidden[30]<=0;
acc_hidden[31]<=0;
acc_hidden[32]<=0;
acc_hidden[33]<=0;
acc_hidden[34]<=0;
acc_hidden[35]<=0;
acc_hidden[36]<=0;
acc_hidden[37]<=0;
acc_hidden[38]<=0;
acc_hidden[39]<=0;
acc_hidden[40]<=0;
acc_hidden[41]<=0;
acc_hidden[42]<=0;
acc_hidden[43]<=0;
acc_hidden[44]<=0;
acc_hidden[45]<=0;
acc_hidden[46]<=0;
acc_hidden[47]<=0;
acc_hidden[48]<=0;
acc_hidden[49]<=0;
acc_hidden[50]<=0;
acc_hidden[51]<=0;
acc_hidden[52]<=0;
acc_hidden[53]<=0;
acc_hidden[54]<=0;
acc_hidden[55]<=0;
acc_hidden[56]<=0;
acc_hidden[57]<=0;
acc_hidden[58]<=0;
acc_hidden[59]<=0;
acc_hidden[60]<=0;
acc_hidden[61]<=0;
acc_hidden[62]<=0;
acc_hidden[63]<=0;
acc_hidden[64]<=0;
acc_hidden[65]<=0;
acc_hidden[66]<=0;
acc_hidden[67]<=0;
acc_hidden[68]<=0;
acc_hidden[69]<=0;
acc_hidden[70]<=0;
acc_hidden[71]<=0;
acc_hidden[72]<=0;
acc_hidden[73]<=0;
acc_hidden[74]<=0;
acc_hidden[75]<=0;
acc_hidden[76]<=0;
acc_hidden[77]<=0;
acc_hidden[78]<=0;
acc_hidden[79]<=0;
acc_hidden[80]<=0;
acc_hidden[81]<=0;
acc_hidden[82]<=0;
acc_hidden[83]<=0;
acc_hidden[84]<=0;
acc_hidden[85]<=0;
acc_hidden[86]<=0;
acc_hidden[87]<=0;
acc_hidden[88]<=0;
acc_hidden[89]<=0;
acc_hidden[90]<=0;
acc_hidden[91]<=0;
acc_hidden[92]<=0;
acc_hidden[93]<=0;
acc_hidden[94]<=0;
acc_hidden[95]<=0;
acc_hidden[96]<=0;
acc_hidden[97]<=0;
acc_hidden[98]<=0;
acc_hidden[99]<=0;
acc_hidden[100]<=0;
acc_hidden[101]<=0;
acc_hidden[102]<=0;
acc_hidden[103]<=0;
acc_hidden[104]<=0;
acc_hidden[105]<=0;
acc_hidden[106]<=0;
acc_hidden[107]<=0;
acc_hidden[108]<=0;
acc_hidden[109]<=0;
acc_hidden[110]<=0;
acc_hidden[111]<=0;
acc_hidden[112]<=0;
acc_hidden[113]<=0;
acc_hidden[114]<=0;
acc_hidden[115]<=0;
acc_hidden[116]<=0;
acc_hidden[117]<=0;
acc_hidden[118]<=0;
acc_hidden[119]<=0;
acc_hidden[120]<=0;
acc_hidden[121]<=0;
acc_hidden[122]<=0;
acc_hidden[123]<=0;
acc_hidden[124]<=0;
acc_hidden[125]<=0;
acc_hidden[126]<=0;
acc_hidden[127]<=0;
acc_hidden[128]<=0;
acc_hidden[129]<=0;
acc_hidden[130]<=0;
acc_hidden[131]<=0;
acc_hidden[132]<=0;
acc_hidden[133]<=0;
acc_hidden[134]<=0;
acc_hidden[135]<=0;
acc_hidden[136]<=0;
acc_hidden[137]<=0;
acc_hidden[138]<=0;
acc_hidden[139]<=0;
acc_hidden[140]<=0;
acc_hidden[141]<=0;
acc_hidden[142]<=0;
acc_hidden[143]<=0;
acc_hidden[144]<=0;
acc_hidden[145]<=0;
acc_hidden[146]<=0;
acc_hidden[147]<=0;
acc_hidden[148]<=0;
acc_hidden[149]<=0;
acc_hidden[150]<=0;
acc_hidden[151]<=0;
acc_hidden[152]<=0;
acc_hidden[153]<=0;
acc_hidden[154]<=0;
acc_hidden[155]<=0;
acc_hidden[156]<=0;
acc_hidden[157]<=0;
acc_hidden[158]<=0;
acc_hidden[159]<=0;
acc_hidden[160]<=0;
acc_hidden[161]<=0;
acc_hidden[162]<=0;
acc_hidden[163]<=0;
acc_hidden[164]<=0;
acc_hidden[165]<=0;
acc_hidden[166]<=0;
acc_hidden[167]<=0;
acc_hidden[168]<=0;
acc_hidden[169]<=0;
acc_hidden[170]<=0;
acc_hidden[171]<=0;
acc_hidden[172]<=0;
acc_hidden[173]<=0;
acc_hidden[174]<=0;
acc_hidden[175]<=0;
acc_hidden[176]<=0;
acc_hidden[177]<=0;
acc_hidden[178]<=0;
acc_hidden[179]<=0;
acc_hidden[180]<=0;
acc_hidden[181]<=0;
acc_hidden[182]<=0;
acc_hidden[183]<=0;
acc_hidden[184]<=0;
acc_hidden[185]<=0;
acc_hidden[186]<=0;
acc_hidden[187]<=0;
acc_hidden[188]<=0;
acc_hidden[189]<=0;
acc_hidden[190]<=0;
acc_hidden[191]<=0;
acc_hidden[192]<=0;
acc_hidden[193]<=0;
acc_hidden[194]<=0;
acc_hidden[195]<=0;
acc_hidden[196]<=0;
acc_hidden[197]<=0;
acc_hidden[198]<=0;
acc_hidden[199]<=0;
acc_hidden[200]<=0;
acc_hidden[201]<=0;
acc_hidden[202]<=0;
acc_hidden[203]<=0;
acc_hidden[204]<=0;
acc_hidden[205]<=0;
acc_hidden[206]<=0;
acc_hidden[207]<=0;
acc_hidden[208]<=0;
acc_hidden[209]<=0;
acc_hidden[210]<=0;
acc_hidden[211]<=0;
acc_hidden[212]<=0;
acc_hidden[213]<=0;
acc_hidden[214]<=0;
acc_hidden[215]<=0;
acc_hidden[216]<=0;
acc_hidden[217]<=0;
acc_hidden[218]<=0;
acc_hidden[219]<=0;
acc_hidden[220]<=0;
acc_hidden[221]<=0;
acc_hidden[222]<=0;
acc_hidden[223]<=0;
acc_hidden[224]<=0;
acc_hidden[225]<=0;
acc_hidden[226]<=0;
acc_hidden[227]<=0;
acc_hidden[228]<=0;
acc_hidden[229]<=0;
acc_hidden[230]<=0;
acc_hidden[231]<=0;
acc_hidden[232]<=0;
acc_hidden[233]<=0;
acc_hidden[234]<=0;
acc_hidden[235]<=0;
acc_hidden[236]<=0;
acc_hidden[237]<=0;
acc_hidden[238]<=0;
acc_hidden[239]<=0;
acc_hidden[240]<=0;
acc_hidden[241]<=0;
acc_hidden[242]<=0;
acc_hidden[243]<=0;
acc_hidden[244]<=0;
acc_hidden[245]<=0;
acc_hidden[246]<=0;
acc_hidden[247]<=0;
acc_hidden[248]<=0;
acc_hidden[249]<=0;
acc_hidden[250]<=0;
acc_hidden[251]<=0;
acc_hidden[252]<=0;
acc_hidden[253]<=0;
acc_hidden[254]<=0;
acc_hidden[255]<=0;
acc_hidden[256]<=0;
acc_hidden[257]<=0;
acc_hidden[258]<=0;
acc_hidden[259]<=0;
acc_hidden[260]<=0;
acc_hidden[261]<=0;
acc_hidden[262]<=0;
acc_hidden[263]<=0;
acc_hidden[264]<=0;
acc_hidden[265]<=0;
acc_hidden[266]<=0;
acc_hidden[267]<=0;
acc_hidden[268]<=0;
acc_hidden[269]<=0;
acc_hidden[270]<=0;
acc_hidden[271]<=0;
acc_hidden[272]<=0;
acc_hidden[273]<=0;
acc_hidden[274]<=0;
acc_hidden[275]<=0;
acc_hidden[276]<=0;
acc_hidden[277]<=0;
acc_hidden[278]<=0;
acc_hidden[279]<=0;
acc_hidden[280]<=0;
acc_hidden[281]<=0;
acc_hidden[282]<=0;
acc_hidden[283]<=0;
acc_hidden[284]<=0;
acc_hidden[285]<=0;
acc_hidden[286]<=0;
acc_hidden[287]<=0;
acc_hidden[288]<=0;
acc_hidden[289]<=0;
acc_hidden[290]<=0;
acc_hidden[291]<=0;
acc_hidden[292]<=0;
acc_hidden[293]<=0;
acc_hidden[294]<=0;
acc_hidden[295]<=0;
acc_hidden[296]<=0;
acc_hidden[297]<=0;
acc_hidden[298]<=0;
acc_hidden[299]<=0;
acc_hidden[300]<=0;
acc_hidden[301]<=0;
acc_hidden[302]<=0;
acc_hidden[303]<=0;
acc_hidden[304]<=0;
acc_hidden[305]<=0;
acc_hidden[306]<=0;
acc_hidden[307]<=0;
acc_hidden[308]<=0;
acc_hidden[309]<=0;
acc_hidden[310]<=0;
acc_hidden[311]<=0;
acc_hidden[312]<=0;
acc_hidden[313]<=0;
acc_hidden[314]<=0;
acc_hidden[315]<=0;
acc_hidden[316]<=0;
acc_hidden[317]<=0;
acc_hidden[318]<=0;
acc_hidden[319]<=0;
acc_hidden[320]<=0;
acc_hidden[321]<=0;
acc_hidden[322]<=0;
acc_hidden[323]<=0;
acc_hidden[324]<=0;
acc_hidden[325]<=0;
acc_hidden[326]<=0;
acc_hidden[327]<=0;
acc_hidden[328]<=0;
acc_hidden[329]<=0;
acc_hidden[330]<=0;
acc_hidden[331]<=0;
acc_hidden[332]<=0;
acc_hidden[333]<=0;
acc_hidden[334]<=0;
acc_hidden[335]<=0;
acc_hidden[336]<=0;
acc_hidden[337]<=0;
acc_hidden[338]<=0;
acc_hidden[339]<=0;
acc_hidden[340]<=0;
acc_hidden[341]<=0;
acc_hidden[342]<=0;
acc_hidden[343]<=0;
acc_hidden[344]<=0;
acc_hidden[345]<=0;
acc_hidden[346]<=0;
acc_hidden[347]<=0;
acc_hidden[348]<=0;
acc_hidden[349]<=0;
acc_hidden[350]<=0;
acc_hidden[351]<=0;
acc_hidden[352]<=0;
acc_hidden[353]<=0;
acc_hidden[354]<=0;
acc_hidden[355]<=0;
acc_hidden[356]<=0;
acc_hidden[357]<=0;
acc_hidden[358]<=0;
acc_hidden[359]<=0;
acc_hidden[360]<=0;
acc_hidden[361]<=0;
acc_hidden[362]<=0;
acc_hidden[363]<=0;
acc_hidden[364]<=0;
acc_hidden[365]<=0;
acc_hidden[366]<=0;
acc_hidden[367]<=0;
acc_hidden[368]<=0;
acc_hidden[369]<=0;
acc_hidden[370]<=0;
acc_hidden[371]<=0;
acc_hidden[372]<=0;
acc_hidden[373]<=0;
acc_hidden[374]<=0;
acc_hidden[375]<=0;
acc_hidden[376]<=0;
acc_hidden[377]<=0;
acc_hidden[378]<=0;
acc_hidden[379]<=0;
acc_hidden[380]<=0;
acc_hidden[381]<=0;
acc_hidden[382]<=0;
acc_hidden[383]<=0;
acc_hidden[384]<=0;
acc_hidden[385]<=0;
acc_hidden[386]<=0;
acc_hidden[387]<=0;
acc_hidden[388]<=0;
acc_hidden[389]<=0;
acc_hidden[390]<=0;
acc_hidden[391]<=0;
acc_hidden[392]<=0;
acc_hidden[393]<=0;
acc_hidden[394]<=0;
acc_hidden[395]<=0;
acc_hidden[396]<=0;
acc_hidden[397]<=0;
acc_hidden[398]<=0;
acc_hidden[399]<=0;
acc_hidden[400]<=0;
acc_hidden[401]<=0;
acc_hidden[402]<=0;
acc_hidden[403]<=0;
acc_hidden[404]<=0;
acc_hidden[405]<=0;
acc_hidden[406]<=0;
acc_hidden[407]<=0;
acc_hidden[408]<=0;
acc_hidden[409]<=0;
acc_hidden[410]<=0;
acc_hidden[411]<=0;
acc_hidden[412]<=0;
acc_hidden[413]<=0;
acc_hidden[414]<=0;
acc_hidden[415]<=0;
acc_hidden[416]<=0;
acc_hidden[417]<=0;
acc_hidden[418]<=0;
acc_hidden[419]<=0;
acc_hidden[420]<=0;
acc_hidden[421]<=0;
acc_hidden[422]<=0;
acc_hidden[423]<=0;
acc_hidden[424]<=0;
acc_hidden[425]<=0;
acc_hidden[426]<=0;
acc_hidden[427]<=0;
acc_hidden[428]<=0;
acc_hidden[429]<=0;
acc_hidden[430]<=0;
acc_hidden[431]<=0;
acc_hidden[432]<=0;
acc_hidden[433]<=0;
acc_hidden[434]<=0;
acc_hidden[435]<=0;
acc_hidden[436]<=0;
acc_hidden[437]<=0;
acc_hidden[438]<=0;
acc_hidden[439]<=0;
acc_hidden[440]<=0;
acc_hidden[441]<=0;
acc_hidden[442]<=0;
acc_hidden[443]<=0;
acc_hidden[444]<=0;
acc_hidden[445]<=0;
acc_hidden[446]<=0;
acc_hidden[447]<=0;
acc_hidden[448]<=0;
acc_hidden[449]<=0;
acc_hidden[450]<=0;
acc_hidden[451]<=0;
acc_hidden[452]<=0;
acc_hidden[453]<=0;
acc_hidden[454]<=0;
acc_hidden[455]<=0;
acc_hidden[456]<=0;
acc_hidden[457]<=0;
acc_hidden[458]<=0;
acc_hidden[459]<=0;
acc_hidden[460]<=0;
acc_hidden[461]<=0;
acc_hidden[462]<=0;
acc_hidden[463]<=0;
acc_hidden[464]<=0;
acc_hidden[465]<=0;
acc_hidden[466]<=0;
acc_hidden[467]<=0;
acc_hidden[468]<=0;
acc_hidden[469]<=0;
acc_hidden[470]<=0;
acc_hidden[471]<=0;
acc_hidden[472]<=0;
acc_hidden[473]<=0;
acc_hidden[474]<=0;
acc_hidden[475]<=0;
acc_hidden[476]<=0;
acc_hidden[477]<=0;
acc_hidden[478]<=0;
acc_hidden[479]<=0;
acc_hidden[480]<=0;
acc_hidden[481]<=0;
acc_hidden[482]<=0;
acc_hidden[483]<=0;
acc_hidden[484]<=0;
acc_hidden[485]<=0;
acc_hidden[486]<=0;
acc_hidden[487]<=0;
acc_hidden[488]<=0;
acc_hidden[489]<=0;
acc_hidden[490]<=0;
acc_hidden[491]<=0;
acc_hidden[492]<=0;
acc_hidden[493]<=0;
acc_hidden[494]<=0;
acc_hidden[495]<=0;
acc_hidden[496]<=0;
acc_hidden[497]<=0;
acc_hidden[498]<=0;
acc_hidden[499]<=0;
acc_hidden[500]<=0;
acc_hidden[501]<=0;
acc_hidden[502]<=0;
acc_hidden[503]<=0;
acc_hidden[504]<=0;
acc_hidden[505]<=0;
acc_hidden[506]<=0;
acc_hidden[507]<=0;
acc_hidden[508]<=0;
acc_hidden[509]<=0;
acc_hidden[510]<=0;
acc_hidden[511]<=0;
end
else if(hidden_comp)begin
acc_hidden[0]<=acc_hidden[0][15]?0:acc_hidden[0];
acc_hidden[1]<=acc_hidden[1][15]?0:acc_hidden[1];
acc_hidden[2]<=acc_hidden[2][15]?0:acc_hidden[2];
acc_hidden[3]<=acc_hidden[3][15]?0:acc_hidden[3];
acc_hidden[4]<=acc_hidden[4][15]?0:acc_hidden[4];
acc_hidden[5]<=acc_hidden[5][15]?0:acc_hidden[5];
acc_hidden[6]<=acc_hidden[6][15]?0:acc_hidden[6];
acc_hidden[7]<=acc_hidden[7][15]?0:acc_hidden[7];
acc_hidden[8]<=acc_hidden[8][15]?0:acc_hidden[8];
acc_hidden[9]<=acc_hidden[9][15]?0:acc_hidden[9];
acc_hidden[10]<=acc_hidden[10][15]?0:acc_hidden[10];
acc_hidden[11]<=acc_hidden[11][15]?0:acc_hidden[11];
acc_hidden[12]<=acc_hidden[12][15]?0:acc_hidden[12];
acc_hidden[13]<=acc_hidden[13][15]?0:acc_hidden[13];
acc_hidden[14]<=acc_hidden[14][15]?0:acc_hidden[14];
acc_hidden[15]<=acc_hidden[15][15]?0:acc_hidden[15];
acc_hidden[16]<=acc_hidden[16][15]?0:acc_hidden[16];
acc_hidden[17]<=acc_hidden[17][15]?0:acc_hidden[17];
acc_hidden[18]<=acc_hidden[18][15]?0:acc_hidden[18];
acc_hidden[19]<=acc_hidden[19][15]?0:acc_hidden[19];
acc_hidden[20]<=acc_hidden[20][15]?0:acc_hidden[20];
acc_hidden[21]<=acc_hidden[21][15]?0:acc_hidden[21];
acc_hidden[22]<=acc_hidden[22][15]?0:acc_hidden[22];
acc_hidden[23]<=acc_hidden[23][15]?0:acc_hidden[23];
acc_hidden[24]<=acc_hidden[24][15]?0:acc_hidden[24];
acc_hidden[25]<=acc_hidden[25][15]?0:acc_hidden[25];
acc_hidden[26]<=acc_hidden[26][15]?0:acc_hidden[26];
acc_hidden[27]<=acc_hidden[27][15]?0:acc_hidden[27];
acc_hidden[28]<=acc_hidden[28][15]?0:acc_hidden[28];
acc_hidden[29]<=acc_hidden[29][15]?0:acc_hidden[29];
acc_hidden[30]<=acc_hidden[30][15]?0:acc_hidden[30];
acc_hidden[31]<=acc_hidden[31][15]?0:acc_hidden[31];
acc_hidden[32]<=acc_hidden[32][15]?0:acc_hidden[32];
acc_hidden[33]<=acc_hidden[33][15]?0:acc_hidden[33];
acc_hidden[34]<=acc_hidden[34][15]?0:acc_hidden[34];
acc_hidden[35]<=acc_hidden[35][15]?0:acc_hidden[35];
acc_hidden[36]<=acc_hidden[36][15]?0:acc_hidden[36];
acc_hidden[37]<=acc_hidden[37][15]?0:acc_hidden[37];
acc_hidden[38]<=acc_hidden[38][15]?0:acc_hidden[38];
acc_hidden[39]<=acc_hidden[39][15]?0:acc_hidden[39];
acc_hidden[40]<=acc_hidden[40][15]?0:acc_hidden[40];
acc_hidden[41]<=acc_hidden[41][15]?0:acc_hidden[41];
acc_hidden[42]<=acc_hidden[42][15]?0:acc_hidden[42];
acc_hidden[43]<=acc_hidden[43][15]?0:acc_hidden[43];
acc_hidden[44]<=acc_hidden[44][15]?0:acc_hidden[44];
acc_hidden[45]<=acc_hidden[45][15]?0:acc_hidden[45];
acc_hidden[46]<=acc_hidden[46][15]?0:acc_hidden[46];
acc_hidden[47]<=acc_hidden[47][15]?0:acc_hidden[47];
acc_hidden[48]<=acc_hidden[48][15]?0:acc_hidden[48];
acc_hidden[49]<=acc_hidden[49][15]?0:acc_hidden[49];
acc_hidden[50]<=acc_hidden[50][15]?0:acc_hidden[50];
acc_hidden[51]<=acc_hidden[51][15]?0:acc_hidden[51];
acc_hidden[52]<=acc_hidden[52][15]?0:acc_hidden[52];
acc_hidden[53]<=acc_hidden[53][15]?0:acc_hidden[53];
acc_hidden[54]<=acc_hidden[54][15]?0:acc_hidden[54];
acc_hidden[55]<=acc_hidden[55][15]?0:acc_hidden[55];
acc_hidden[56]<=acc_hidden[56][15]?0:acc_hidden[56];
acc_hidden[57]<=acc_hidden[57][15]?0:acc_hidden[57];
acc_hidden[58]<=acc_hidden[58][15]?0:acc_hidden[58];
acc_hidden[59]<=acc_hidden[59][15]?0:acc_hidden[59];
acc_hidden[60]<=acc_hidden[60][15]?0:acc_hidden[60];
acc_hidden[61]<=acc_hidden[61][15]?0:acc_hidden[61];
acc_hidden[62]<=acc_hidden[62][15]?0:acc_hidden[62];
acc_hidden[63]<=acc_hidden[63][15]?0:acc_hidden[63];
acc_hidden[64]<=acc_hidden[64][15]?0:acc_hidden[64];
acc_hidden[65]<=acc_hidden[65][15]?0:acc_hidden[65];
acc_hidden[66]<=acc_hidden[66][15]?0:acc_hidden[66];
acc_hidden[67]<=acc_hidden[67][15]?0:acc_hidden[67];
acc_hidden[68]<=acc_hidden[68][15]?0:acc_hidden[68];
acc_hidden[69]<=acc_hidden[69][15]?0:acc_hidden[69];
acc_hidden[70]<=acc_hidden[70][15]?0:acc_hidden[70];
acc_hidden[71]<=acc_hidden[71][15]?0:acc_hidden[71];
acc_hidden[72]<=acc_hidden[72][15]?0:acc_hidden[72];
acc_hidden[73]<=acc_hidden[73][15]?0:acc_hidden[73];
acc_hidden[74]<=acc_hidden[74][15]?0:acc_hidden[74];
acc_hidden[75]<=acc_hidden[75][15]?0:acc_hidden[75];
acc_hidden[76]<=acc_hidden[76][15]?0:acc_hidden[76];
acc_hidden[77]<=acc_hidden[77][15]?0:acc_hidden[77];
acc_hidden[78]<=acc_hidden[78][15]?0:acc_hidden[78];
acc_hidden[79]<=acc_hidden[79][15]?0:acc_hidden[79];
acc_hidden[80]<=acc_hidden[80][15]?0:acc_hidden[80];
acc_hidden[81]<=acc_hidden[81][15]?0:acc_hidden[81];
acc_hidden[82]<=acc_hidden[82][15]?0:acc_hidden[82];
acc_hidden[83]<=acc_hidden[83][15]?0:acc_hidden[83];
acc_hidden[84]<=acc_hidden[84][15]?0:acc_hidden[84];
acc_hidden[85]<=acc_hidden[85][15]?0:acc_hidden[85];
acc_hidden[86]<=acc_hidden[86][15]?0:acc_hidden[86];
acc_hidden[87]<=acc_hidden[87][15]?0:acc_hidden[87];
acc_hidden[88]<=acc_hidden[88][15]?0:acc_hidden[88];
acc_hidden[89]<=acc_hidden[89][15]?0:acc_hidden[89];
acc_hidden[90]<=acc_hidden[90][15]?0:acc_hidden[90];
acc_hidden[91]<=acc_hidden[91][15]?0:acc_hidden[91];
acc_hidden[92]<=acc_hidden[92][15]?0:acc_hidden[92];
acc_hidden[93]<=acc_hidden[93][15]?0:acc_hidden[93];
acc_hidden[94]<=acc_hidden[94][15]?0:acc_hidden[94];
acc_hidden[95]<=acc_hidden[95][15]?0:acc_hidden[95];
acc_hidden[96]<=acc_hidden[96][15]?0:acc_hidden[96];
acc_hidden[97]<=acc_hidden[97][15]?0:acc_hidden[97];
acc_hidden[98]<=acc_hidden[98][15]?0:acc_hidden[98];
acc_hidden[99]<=acc_hidden[99][15]?0:acc_hidden[99];
acc_hidden[100]<=acc_hidden[100][15]?0:acc_hidden[100];
acc_hidden[101]<=acc_hidden[101][15]?0:acc_hidden[101];
acc_hidden[102]<=acc_hidden[102][15]?0:acc_hidden[102];
acc_hidden[103]<=acc_hidden[103][15]?0:acc_hidden[103];
acc_hidden[104]<=acc_hidden[104][15]?0:acc_hidden[104];
acc_hidden[105]<=acc_hidden[105][15]?0:acc_hidden[105];
acc_hidden[106]<=acc_hidden[106][15]?0:acc_hidden[106];
acc_hidden[107]<=acc_hidden[107][15]?0:acc_hidden[107];
acc_hidden[108]<=acc_hidden[108][15]?0:acc_hidden[108];
acc_hidden[109]<=acc_hidden[109][15]?0:acc_hidden[109];
acc_hidden[110]<=acc_hidden[110][15]?0:acc_hidden[110];
acc_hidden[111]<=acc_hidden[111][15]?0:acc_hidden[111];
acc_hidden[112]<=acc_hidden[112][15]?0:acc_hidden[112];
acc_hidden[113]<=acc_hidden[113][15]?0:acc_hidden[113];
acc_hidden[114]<=acc_hidden[114][15]?0:acc_hidden[114];
acc_hidden[115]<=acc_hidden[115][15]?0:acc_hidden[115];
acc_hidden[116]<=acc_hidden[116][15]?0:acc_hidden[116];
acc_hidden[117]<=acc_hidden[117][15]?0:acc_hidden[117];
acc_hidden[118]<=acc_hidden[118][15]?0:acc_hidden[118];
acc_hidden[119]<=acc_hidden[119][15]?0:acc_hidden[119];
acc_hidden[120]<=acc_hidden[120][15]?0:acc_hidden[120];
acc_hidden[121]<=acc_hidden[121][15]?0:acc_hidden[121];
acc_hidden[122]<=acc_hidden[122][15]?0:acc_hidden[122];
acc_hidden[123]<=acc_hidden[123][15]?0:acc_hidden[123];
acc_hidden[124]<=acc_hidden[124][15]?0:acc_hidden[124];
acc_hidden[125]<=acc_hidden[125][15]?0:acc_hidden[125];
acc_hidden[126]<=acc_hidden[126][15]?0:acc_hidden[126];
acc_hidden[127]<=acc_hidden[127][15]?0:acc_hidden[127];
acc_hidden[128]<=acc_hidden[128][15]?0:acc_hidden[128];
acc_hidden[129]<=acc_hidden[129][15]?0:acc_hidden[129];
acc_hidden[130]<=acc_hidden[130][15]?0:acc_hidden[130];
acc_hidden[131]<=acc_hidden[131][15]?0:acc_hidden[131];
acc_hidden[132]<=acc_hidden[132][15]?0:acc_hidden[132];
acc_hidden[133]<=acc_hidden[133][15]?0:acc_hidden[133];
acc_hidden[134]<=acc_hidden[134][15]?0:acc_hidden[134];
acc_hidden[135]<=acc_hidden[135][15]?0:acc_hidden[135];
acc_hidden[136]<=acc_hidden[136][15]?0:acc_hidden[136];
acc_hidden[137]<=acc_hidden[137][15]?0:acc_hidden[137];
acc_hidden[138]<=acc_hidden[138][15]?0:acc_hidden[138];
acc_hidden[139]<=acc_hidden[139][15]?0:acc_hidden[139];
acc_hidden[140]<=acc_hidden[140][15]?0:acc_hidden[140];
acc_hidden[141]<=acc_hidden[141][15]?0:acc_hidden[141];
acc_hidden[142]<=acc_hidden[142][15]?0:acc_hidden[142];
acc_hidden[143]<=acc_hidden[143][15]?0:acc_hidden[143];
acc_hidden[144]<=acc_hidden[144][15]?0:acc_hidden[144];
acc_hidden[145]<=acc_hidden[145][15]?0:acc_hidden[145];
acc_hidden[146]<=acc_hidden[146][15]?0:acc_hidden[146];
acc_hidden[147]<=acc_hidden[147][15]?0:acc_hidden[147];
acc_hidden[148]<=acc_hidden[148][15]?0:acc_hidden[148];
acc_hidden[149]<=acc_hidden[149][15]?0:acc_hidden[149];
acc_hidden[150]<=acc_hidden[150][15]?0:acc_hidden[150];
acc_hidden[151]<=acc_hidden[151][15]?0:acc_hidden[151];
acc_hidden[152]<=acc_hidden[152][15]?0:acc_hidden[152];
acc_hidden[153]<=acc_hidden[153][15]?0:acc_hidden[153];
acc_hidden[154]<=acc_hidden[154][15]?0:acc_hidden[154];
acc_hidden[155]<=acc_hidden[155][15]?0:acc_hidden[155];
acc_hidden[156]<=acc_hidden[156][15]?0:acc_hidden[156];
acc_hidden[157]<=acc_hidden[157][15]?0:acc_hidden[157];
acc_hidden[158]<=acc_hidden[158][15]?0:acc_hidden[158];
acc_hidden[159]<=acc_hidden[159][15]?0:acc_hidden[159];
acc_hidden[160]<=acc_hidden[160][15]?0:acc_hidden[160];
acc_hidden[161]<=acc_hidden[161][15]?0:acc_hidden[161];
acc_hidden[162]<=acc_hidden[162][15]?0:acc_hidden[162];
acc_hidden[163]<=acc_hidden[163][15]?0:acc_hidden[163];
acc_hidden[164]<=acc_hidden[164][15]?0:acc_hidden[164];
acc_hidden[165]<=acc_hidden[165][15]?0:acc_hidden[165];
acc_hidden[166]<=acc_hidden[166][15]?0:acc_hidden[166];
acc_hidden[167]<=acc_hidden[167][15]?0:acc_hidden[167];
acc_hidden[168]<=acc_hidden[168][15]?0:acc_hidden[168];
acc_hidden[169]<=acc_hidden[169][15]?0:acc_hidden[169];
acc_hidden[170]<=acc_hidden[170][15]?0:acc_hidden[170];
acc_hidden[171]<=acc_hidden[171][15]?0:acc_hidden[171];
acc_hidden[172]<=acc_hidden[172][15]?0:acc_hidden[172];
acc_hidden[173]<=acc_hidden[173][15]?0:acc_hidden[173];
acc_hidden[174]<=acc_hidden[174][15]?0:acc_hidden[174];
acc_hidden[175]<=acc_hidden[175][15]?0:acc_hidden[175];
acc_hidden[176]<=acc_hidden[176][15]?0:acc_hidden[176];
acc_hidden[177]<=acc_hidden[177][15]?0:acc_hidden[177];
acc_hidden[178]<=acc_hidden[178][15]?0:acc_hidden[178];
acc_hidden[179]<=acc_hidden[179][15]?0:acc_hidden[179];
acc_hidden[180]<=acc_hidden[180][15]?0:acc_hidden[180];
acc_hidden[181]<=acc_hidden[181][15]?0:acc_hidden[181];
acc_hidden[182]<=acc_hidden[182][15]?0:acc_hidden[182];
acc_hidden[183]<=acc_hidden[183][15]?0:acc_hidden[183];
acc_hidden[184]<=acc_hidden[184][15]?0:acc_hidden[184];
acc_hidden[185]<=acc_hidden[185][15]?0:acc_hidden[185];
acc_hidden[186]<=acc_hidden[186][15]?0:acc_hidden[186];
acc_hidden[187]<=acc_hidden[187][15]?0:acc_hidden[187];
acc_hidden[188]<=acc_hidden[188][15]?0:acc_hidden[188];
acc_hidden[189]<=acc_hidden[189][15]?0:acc_hidden[189];
acc_hidden[190]<=acc_hidden[190][15]?0:acc_hidden[190];
acc_hidden[191]<=acc_hidden[191][15]?0:acc_hidden[191];
acc_hidden[192]<=acc_hidden[192][15]?0:acc_hidden[192];
acc_hidden[193]<=acc_hidden[193][15]?0:acc_hidden[193];
acc_hidden[194]<=acc_hidden[194][15]?0:acc_hidden[194];
acc_hidden[195]<=acc_hidden[195][15]?0:acc_hidden[195];
acc_hidden[196]<=acc_hidden[196][15]?0:acc_hidden[196];
acc_hidden[197]<=acc_hidden[197][15]?0:acc_hidden[197];
acc_hidden[198]<=acc_hidden[198][15]?0:acc_hidden[198];
acc_hidden[199]<=acc_hidden[199][15]?0:acc_hidden[199];
acc_hidden[200]<=acc_hidden[200][15]?0:acc_hidden[200];
acc_hidden[201]<=acc_hidden[201][15]?0:acc_hidden[201];
acc_hidden[202]<=acc_hidden[202][15]?0:acc_hidden[202];
acc_hidden[203]<=acc_hidden[203][15]?0:acc_hidden[203];
acc_hidden[204]<=acc_hidden[204][15]?0:acc_hidden[204];
acc_hidden[205]<=acc_hidden[205][15]?0:acc_hidden[205];
acc_hidden[206]<=acc_hidden[206][15]?0:acc_hidden[206];
acc_hidden[207]<=acc_hidden[207][15]?0:acc_hidden[207];
acc_hidden[208]<=acc_hidden[208][15]?0:acc_hidden[208];
acc_hidden[209]<=acc_hidden[209][15]?0:acc_hidden[209];
acc_hidden[210]<=acc_hidden[210][15]?0:acc_hidden[210];
acc_hidden[211]<=acc_hidden[211][15]?0:acc_hidden[211];
acc_hidden[212]<=acc_hidden[212][15]?0:acc_hidden[212];
acc_hidden[213]<=acc_hidden[213][15]?0:acc_hidden[213];
acc_hidden[214]<=acc_hidden[214][15]?0:acc_hidden[214];
acc_hidden[215]<=acc_hidden[215][15]?0:acc_hidden[215];
acc_hidden[216]<=acc_hidden[216][15]?0:acc_hidden[216];
acc_hidden[217]<=acc_hidden[217][15]?0:acc_hidden[217];
acc_hidden[218]<=acc_hidden[218][15]?0:acc_hidden[218];
acc_hidden[219]<=acc_hidden[219][15]?0:acc_hidden[219];
acc_hidden[220]<=acc_hidden[220][15]?0:acc_hidden[220];
acc_hidden[221]<=acc_hidden[221][15]?0:acc_hidden[221];
acc_hidden[222]<=acc_hidden[222][15]?0:acc_hidden[222];
acc_hidden[223]<=acc_hidden[223][15]?0:acc_hidden[223];
acc_hidden[224]<=acc_hidden[224][15]?0:acc_hidden[224];
acc_hidden[225]<=acc_hidden[225][15]?0:acc_hidden[225];
acc_hidden[226]<=acc_hidden[226][15]?0:acc_hidden[226];
acc_hidden[227]<=acc_hidden[227][15]?0:acc_hidden[227];
acc_hidden[228]<=acc_hidden[228][15]?0:acc_hidden[228];
acc_hidden[229]<=acc_hidden[229][15]?0:acc_hidden[229];
acc_hidden[230]<=acc_hidden[230][15]?0:acc_hidden[230];
acc_hidden[231]<=acc_hidden[231][15]?0:acc_hidden[231];
acc_hidden[232]<=acc_hidden[232][15]?0:acc_hidden[232];
acc_hidden[233]<=acc_hidden[233][15]?0:acc_hidden[233];
acc_hidden[234]<=acc_hidden[234][15]?0:acc_hidden[234];
acc_hidden[235]<=acc_hidden[235][15]?0:acc_hidden[235];
acc_hidden[236]<=acc_hidden[236][15]?0:acc_hidden[236];
acc_hidden[237]<=acc_hidden[237][15]?0:acc_hidden[237];
acc_hidden[238]<=acc_hidden[238][15]?0:acc_hidden[238];
acc_hidden[239]<=acc_hidden[239][15]?0:acc_hidden[239];
acc_hidden[240]<=acc_hidden[240][15]?0:acc_hidden[240];
acc_hidden[241]<=acc_hidden[241][15]?0:acc_hidden[241];
acc_hidden[242]<=acc_hidden[242][15]?0:acc_hidden[242];
acc_hidden[243]<=acc_hidden[243][15]?0:acc_hidden[243];
acc_hidden[244]<=acc_hidden[244][15]?0:acc_hidden[244];
acc_hidden[245]<=acc_hidden[245][15]?0:acc_hidden[245];
acc_hidden[246]<=acc_hidden[246][15]?0:acc_hidden[246];
acc_hidden[247]<=acc_hidden[247][15]?0:acc_hidden[247];
acc_hidden[248]<=acc_hidden[248][15]?0:acc_hidden[248];
acc_hidden[249]<=acc_hidden[249][15]?0:acc_hidden[249];
acc_hidden[250]<=acc_hidden[250][15]?0:acc_hidden[250];
acc_hidden[251]<=acc_hidden[251][15]?0:acc_hidden[251];
acc_hidden[252]<=acc_hidden[252][15]?0:acc_hidden[252];
acc_hidden[253]<=acc_hidden[253][15]?0:acc_hidden[253];
acc_hidden[254]<=acc_hidden[254][15]?0:acc_hidden[254];
acc_hidden[255]<=acc_hidden[255][15]?0:acc_hidden[255];
acc_hidden[256]<=acc_hidden[256][15]?0:acc_hidden[256];
acc_hidden[257]<=acc_hidden[257][15]?0:acc_hidden[257];
acc_hidden[258]<=acc_hidden[258][15]?0:acc_hidden[258];
acc_hidden[259]<=acc_hidden[259][15]?0:acc_hidden[259];
acc_hidden[260]<=acc_hidden[260][15]?0:acc_hidden[260];
acc_hidden[261]<=acc_hidden[261][15]?0:acc_hidden[261];
acc_hidden[262]<=acc_hidden[262][15]?0:acc_hidden[262];
acc_hidden[263]<=acc_hidden[263][15]?0:acc_hidden[263];
acc_hidden[264]<=acc_hidden[264][15]?0:acc_hidden[264];
acc_hidden[265]<=acc_hidden[265][15]?0:acc_hidden[265];
acc_hidden[266]<=acc_hidden[266][15]?0:acc_hidden[266];
acc_hidden[267]<=acc_hidden[267][15]?0:acc_hidden[267];
acc_hidden[268]<=acc_hidden[268][15]?0:acc_hidden[268];
acc_hidden[269]<=acc_hidden[269][15]?0:acc_hidden[269];
acc_hidden[270]<=acc_hidden[270][15]?0:acc_hidden[270];
acc_hidden[271]<=acc_hidden[271][15]?0:acc_hidden[271];
acc_hidden[272]<=acc_hidden[272][15]?0:acc_hidden[272];
acc_hidden[273]<=acc_hidden[273][15]?0:acc_hidden[273];
acc_hidden[274]<=acc_hidden[274][15]?0:acc_hidden[274];
acc_hidden[275]<=acc_hidden[275][15]?0:acc_hidden[275];
acc_hidden[276]<=acc_hidden[276][15]?0:acc_hidden[276];
acc_hidden[277]<=acc_hidden[277][15]?0:acc_hidden[277];
acc_hidden[278]<=acc_hidden[278][15]?0:acc_hidden[278];
acc_hidden[279]<=acc_hidden[279][15]?0:acc_hidden[279];
acc_hidden[280]<=acc_hidden[280][15]?0:acc_hidden[280];
acc_hidden[281]<=acc_hidden[281][15]?0:acc_hidden[281];
acc_hidden[282]<=acc_hidden[282][15]?0:acc_hidden[282];
acc_hidden[283]<=acc_hidden[283][15]?0:acc_hidden[283];
acc_hidden[284]<=acc_hidden[284][15]?0:acc_hidden[284];
acc_hidden[285]<=acc_hidden[285][15]?0:acc_hidden[285];
acc_hidden[286]<=acc_hidden[286][15]?0:acc_hidden[286];
acc_hidden[287]<=acc_hidden[287][15]?0:acc_hidden[287];
acc_hidden[288]<=acc_hidden[288][15]?0:acc_hidden[288];
acc_hidden[289]<=acc_hidden[289][15]?0:acc_hidden[289];
acc_hidden[290]<=acc_hidden[290][15]?0:acc_hidden[290];
acc_hidden[291]<=acc_hidden[291][15]?0:acc_hidden[291];
acc_hidden[292]<=acc_hidden[292][15]?0:acc_hidden[292];
acc_hidden[293]<=acc_hidden[293][15]?0:acc_hidden[293];
acc_hidden[294]<=acc_hidden[294][15]?0:acc_hidden[294];
acc_hidden[295]<=acc_hidden[295][15]?0:acc_hidden[295];
acc_hidden[296]<=acc_hidden[296][15]?0:acc_hidden[296];
acc_hidden[297]<=acc_hidden[297][15]?0:acc_hidden[297];
acc_hidden[298]<=acc_hidden[298][15]?0:acc_hidden[298];
acc_hidden[299]<=acc_hidden[299][15]?0:acc_hidden[299];
acc_hidden[300]<=acc_hidden[300][15]?0:acc_hidden[300];
acc_hidden[301]<=acc_hidden[301][15]?0:acc_hidden[301];
acc_hidden[302]<=acc_hidden[302][15]?0:acc_hidden[302];
acc_hidden[303]<=acc_hidden[303][15]?0:acc_hidden[303];
acc_hidden[304]<=acc_hidden[304][15]?0:acc_hidden[304];
acc_hidden[305]<=acc_hidden[305][15]?0:acc_hidden[305];
acc_hidden[306]<=acc_hidden[306][15]?0:acc_hidden[306];
acc_hidden[307]<=acc_hidden[307][15]?0:acc_hidden[307];
acc_hidden[308]<=acc_hidden[308][15]?0:acc_hidden[308];
acc_hidden[309]<=acc_hidden[309][15]?0:acc_hidden[309];
acc_hidden[310]<=acc_hidden[310][15]?0:acc_hidden[310];
acc_hidden[311]<=acc_hidden[311][15]?0:acc_hidden[311];
acc_hidden[312]<=acc_hidden[312][15]?0:acc_hidden[312];
acc_hidden[313]<=acc_hidden[313][15]?0:acc_hidden[313];
acc_hidden[314]<=acc_hidden[314][15]?0:acc_hidden[314];
acc_hidden[315]<=acc_hidden[315][15]?0:acc_hidden[315];
acc_hidden[316]<=acc_hidden[316][15]?0:acc_hidden[316];
acc_hidden[317]<=acc_hidden[317][15]?0:acc_hidden[317];
acc_hidden[318]<=acc_hidden[318][15]?0:acc_hidden[318];
acc_hidden[319]<=acc_hidden[319][15]?0:acc_hidden[319];
acc_hidden[320]<=acc_hidden[320][15]?0:acc_hidden[320];
acc_hidden[321]<=acc_hidden[321][15]?0:acc_hidden[321];
acc_hidden[322]<=acc_hidden[322][15]?0:acc_hidden[322];
acc_hidden[323]<=acc_hidden[323][15]?0:acc_hidden[323];
acc_hidden[324]<=acc_hidden[324][15]?0:acc_hidden[324];
acc_hidden[325]<=acc_hidden[325][15]?0:acc_hidden[325];
acc_hidden[326]<=acc_hidden[326][15]?0:acc_hidden[326];
acc_hidden[327]<=acc_hidden[327][15]?0:acc_hidden[327];
acc_hidden[328]<=acc_hidden[328][15]?0:acc_hidden[328];
acc_hidden[329]<=acc_hidden[329][15]?0:acc_hidden[329];
acc_hidden[330]<=acc_hidden[330][15]?0:acc_hidden[330];
acc_hidden[331]<=acc_hidden[331][15]?0:acc_hidden[331];
acc_hidden[332]<=acc_hidden[332][15]?0:acc_hidden[332];
acc_hidden[333]<=acc_hidden[333][15]?0:acc_hidden[333];
acc_hidden[334]<=acc_hidden[334][15]?0:acc_hidden[334];
acc_hidden[335]<=acc_hidden[335][15]?0:acc_hidden[335];
acc_hidden[336]<=acc_hidden[336][15]?0:acc_hidden[336];
acc_hidden[337]<=acc_hidden[337][15]?0:acc_hidden[337];
acc_hidden[338]<=acc_hidden[338][15]?0:acc_hidden[338];
acc_hidden[339]<=acc_hidden[339][15]?0:acc_hidden[339];
acc_hidden[340]<=acc_hidden[340][15]?0:acc_hidden[340];
acc_hidden[341]<=acc_hidden[341][15]?0:acc_hidden[341];
acc_hidden[342]<=acc_hidden[342][15]?0:acc_hidden[342];
acc_hidden[343]<=acc_hidden[343][15]?0:acc_hidden[343];
acc_hidden[344]<=acc_hidden[344][15]?0:acc_hidden[344];
acc_hidden[345]<=acc_hidden[345][15]?0:acc_hidden[345];
acc_hidden[346]<=acc_hidden[346][15]?0:acc_hidden[346];
acc_hidden[347]<=acc_hidden[347][15]?0:acc_hidden[347];
acc_hidden[348]<=acc_hidden[348][15]?0:acc_hidden[348];
acc_hidden[349]<=acc_hidden[349][15]?0:acc_hidden[349];
acc_hidden[350]<=acc_hidden[350][15]?0:acc_hidden[350];
acc_hidden[351]<=acc_hidden[351][15]?0:acc_hidden[351];
acc_hidden[352]<=acc_hidden[352][15]?0:acc_hidden[352];
acc_hidden[353]<=acc_hidden[353][15]?0:acc_hidden[353];
acc_hidden[354]<=acc_hidden[354][15]?0:acc_hidden[354];
acc_hidden[355]<=acc_hidden[355][15]?0:acc_hidden[355];
acc_hidden[356]<=acc_hidden[356][15]?0:acc_hidden[356];
acc_hidden[357]<=acc_hidden[357][15]?0:acc_hidden[357];
acc_hidden[358]<=acc_hidden[358][15]?0:acc_hidden[358];
acc_hidden[359]<=acc_hidden[359][15]?0:acc_hidden[359];
acc_hidden[360]<=acc_hidden[360][15]?0:acc_hidden[360];
acc_hidden[361]<=acc_hidden[361][15]?0:acc_hidden[361];
acc_hidden[362]<=acc_hidden[362][15]?0:acc_hidden[362];
acc_hidden[363]<=acc_hidden[363][15]?0:acc_hidden[363];
acc_hidden[364]<=acc_hidden[364][15]?0:acc_hidden[364];
acc_hidden[365]<=acc_hidden[365][15]?0:acc_hidden[365];
acc_hidden[366]<=acc_hidden[366][15]?0:acc_hidden[366];
acc_hidden[367]<=acc_hidden[367][15]?0:acc_hidden[367];
acc_hidden[368]<=acc_hidden[368][15]?0:acc_hidden[368];
acc_hidden[369]<=acc_hidden[369][15]?0:acc_hidden[369];
acc_hidden[370]<=acc_hidden[370][15]?0:acc_hidden[370];
acc_hidden[371]<=acc_hidden[371][15]?0:acc_hidden[371];
acc_hidden[372]<=acc_hidden[372][15]?0:acc_hidden[372];
acc_hidden[373]<=acc_hidden[373][15]?0:acc_hidden[373];
acc_hidden[374]<=acc_hidden[374][15]?0:acc_hidden[374];
acc_hidden[375]<=acc_hidden[375][15]?0:acc_hidden[375];
acc_hidden[376]<=acc_hidden[376][15]?0:acc_hidden[376];
acc_hidden[377]<=acc_hidden[377][15]?0:acc_hidden[377];
acc_hidden[378]<=acc_hidden[378][15]?0:acc_hidden[378];
acc_hidden[379]<=acc_hidden[379][15]?0:acc_hidden[379];
acc_hidden[380]<=acc_hidden[380][15]?0:acc_hidden[380];
acc_hidden[381]<=acc_hidden[381][15]?0:acc_hidden[381];
acc_hidden[382]<=acc_hidden[382][15]?0:acc_hidden[382];
acc_hidden[383]<=acc_hidden[383][15]?0:acc_hidden[383];
acc_hidden[384]<=acc_hidden[384][15]?0:acc_hidden[384];
acc_hidden[385]<=acc_hidden[385][15]?0:acc_hidden[385];
acc_hidden[386]<=acc_hidden[386][15]?0:acc_hidden[386];
acc_hidden[387]<=acc_hidden[387][15]?0:acc_hidden[387];
acc_hidden[388]<=acc_hidden[388][15]?0:acc_hidden[388];
acc_hidden[389]<=acc_hidden[389][15]?0:acc_hidden[389];
acc_hidden[390]<=acc_hidden[390][15]?0:acc_hidden[390];
acc_hidden[391]<=acc_hidden[391][15]?0:acc_hidden[391];
acc_hidden[392]<=acc_hidden[392][15]?0:acc_hidden[392];
acc_hidden[393]<=acc_hidden[393][15]?0:acc_hidden[393];
acc_hidden[394]<=acc_hidden[394][15]?0:acc_hidden[394];
acc_hidden[395]<=acc_hidden[395][15]?0:acc_hidden[395];
acc_hidden[396]<=acc_hidden[396][15]?0:acc_hidden[396];
acc_hidden[397]<=acc_hidden[397][15]?0:acc_hidden[397];
acc_hidden[398]<=acc_hidden[398][15]?0:acc_hidden[398];
acc_hidden[399]<=acc_hidden[399][15]?0:acc_hidden[399];
acc_hidden[400]<=acc_hidden[400][15]?0:acc_hidden[400];
acc_hidden[401]<=acc_hidden[401][15]?0:acc_hidden[401];
acc_hidden[402]<=acc_hidden[402][15]?0:acc_hidden[402];
acc_hidden[403]<=acc_hidden[403][15]?0:acc_hidden[403];
acc_hidden[404]<=acc_hidden[404][15]?0:acc_hidden[404];
acc_hidden[405]<=acc_hidden[405][15]?0:acc_hidden[405];
acc_hidden[406]<=acc_hidden[406][15]?0:acc_hidden[406];
acc_hidden[407]<=acc_hidden[407][15]?0:acc_hidden[407];
acc_hidden[408]<=acc_hidden[408][15]?0:acc_hidden[408];
acc_hidden[409]<=acc_hidden[409][15]?0:acc_hidden[409];
acc_hidden[410]<=acc_hidden[410][15]?0:acc_hidden[410];
acc_hidden[411]<=acc_hidden[411][15]?0:acc_hidden[411];
acc_hidden[412]<=acc_hidden[412][15]?0:acc_hidden[412];
acc_hidden[413]<=acc_hidden[413][15]?0:acc_hidden[413];
acc_hidden[414]<=acc_hidden[414][15]?0:acc_hidden[414];
acc_hidden[415]<=acc_hidden[415][15]?0:acc_hidden[415];
acc_hidden[416]<=acc_hidden[416][15]?0:acc_hidden[416];
acc_hidden[417]<=acc_hidden[417][15]?0:acc_hidden[417];
acc_hidden[418]<=acc_hidden[418][15]?0:acc_hidden[418];
acc_hidden[419]<=acc_hidden[419][15]?0:acc_hidden[419];
acc_hidden[420]<=acc_hidden[420][15]?0:acc_hidden[420];
acc_hidden[421]<=acc_hidden[421][15]?0:acc_hidden[421];
acc_hidden[422]<=acc_hidden[422][15]?0:acc_hidden[422];
acc_hidden[423]<=acc_hidden[423][15]?0:acc_hidden[423];
acc_hidden[424]<=acc_hidden[424][15]?0:acc_hidden[424];
acc_hidden[425]<=acc_hidden[425][15]?0:acc_hidden[425];
acc_hidden[426]<=acc_hidden[426][15]?0:acc_hidden[426];
acc_hidden[427]<=acc_hidden[427][15]?0:acc_hidden[427];
acc_hidden[428]<=acc_hidden[428][15]?0:acc_hidden[428];
acc_hidden[429]<=acc_hidden[429][15]?0:acc_hidden[429];
acc_hidden[430]<=acc_hidden[430][15]?0:acc_hidden[430];
acc_hidden[431]<=acc_hidden[431][15]?0:acc_hidden[431];
acc_hidden[432]<=acc_hidden[432][15]?0:acc_hidden[432];
acc_hidden[433]<=acc_hidden[433][15]?0:acc_hidden[433];
acc_hidden[434]<=acc_hidden[434][15]?0:acc_hidden[434];
acc_hidden[435]<=acc_hidden[435][15]?0:acc_hidden[435];
acc_hidden[436]<=acc_hidden[436][15]?0:acc_hidden[436];
acc_hidden[437]<=acc_hidden[437][15]?0:acc_hidden[437];
acc_hidden[438]<=acc_hidden[438][15]?0:acc_hidden[438];
acc_hidden[439]<=acc_hidden[439][15]?0:acc_hidden[439];
acc_hidden[440]<=acc_hidden[440][15]?0:acc_hidden[440];
acc_hidden[441]<=acc_hidden[441][15]?0:acc_hidden[441];
acc_hidden[442]<=acc_hidden[442][15]?0:acc_hidden[442];
acc_hidden[443]<=acc_hidden[443][15]?0:acc_hidden[443];
acc_hidden[444]<=acc_hidden[444][15]?0:acc_hidden[444];
acc_hidden[445]<=acc_hidden[445][15]?0:acc_hidden[445];
acc_hidden[446]<=acc_hidden[446][15]?0:acc_hidden[446];
acc_hidden[447]<=acc_hidden[447][15]?0:acc_hidden[447];
acc_hidden[448]<=acc_hidden[448][15]?0:acc_hidden[448];
acc_hidden[449]<=acc_hidden[449][15]?0:acc_hidden[449];
acc_hidden[450]<=acc_hidden[450][15]?0:acc_hidden[450];
acc_hidden[451]<=acc_hidden[451][15]?0:acc_hidden[451];
acc_hidden[452]<=acc_hidden[452][15]?0:acc_hidden[452];
acc_hidden[453]<=acc_hidden[453][15]?0:acc_hidden[453];
acc_hidden[454]<=acc_hidden[454][15]?0:acc_hidden[454];
acc_hidden[455]<=acc_hidden[455][15]?0:acc_hidden[455];
acc_hidden[456]<=acc_hidden[456][15]?0:acc_hidden[456];
acc_hidden[457]<=acc_hidden[457][15]?0:acc_hidden[457];
acc_hidden[458]<=acc_hidden[458][15]?0:acc_hidden[458];
acc_hidden[459]<=acc_hidden[459][15]?0:acc_hidden[459];
acc_hidden[460]<=acc_hidden[460][15]?0:acc_hidden[460];
acc_hidden[461]<=acc_hidden[461][15]?0:acc_hidden[461];
acc_hidden[462]<=acc_hidden[462][15]?0:acc_hidden[462];
acc_hidden[463]<=acc_hidden[463][15]?0:acc_hidden[463];
acc_hidden[464]<=acc_hidden[464][15]?0:acc_hidden[464];
acc_hidden[465]<=acc_hidden[465][15]?0:acc_hidden[465];
acc_hidden[466]<=acc_hidden[466][15]?0:acc_hidden[466];
acc_hidden[467]<=acc_hidden[467][15]?0:acc_hidden[467];
acc_hidden[468]<=acc_hidden[468][15]?0:acc_hidden[468];
acc_hidden[469]<=acc_hidden[469][15]?0:acc_hidden[469];
acc_hidden[470]<=acc_hidden[470][15]?0:acc_hidden[470];
acc_hidden[471]<=acc_hidden[471][15]?0:acc_hidden[471];
acc_hidden[472]<=acc_hidden[472][15]?0:acc_hidden[472];
acc_hidden[473]<=acc_hidden[473][15]?0:acc_hidden[473];
acc_hidden[474]<=acc_hidden[474][15]?0:acc_hidden[474];
acc_hidden[475]<=acc_hidden[475][15]?0:acc_hidden[475];
acc_hidden[476]<=acc_hidden[476][15]?0:acc_hidden[476];
acc_hidden[477]<=acc_hidden[477][15]?0:acc_hidden[477];
acc_hidden[478]<=acc_hidden[478][15]?0:acc_hidden[478];
acc_hidden[479]<=acc_hidden[479][15]?0:acc_hidden[479];
acc_hidden[480]<=acc_hidden[480][15]?0:acc_hidden[480];
acc_hidden[481]<=acc_hidden[481][15]?0:acc_hidden[481];
acc_hidden[482]<=acc_hidden[482][15]?0:acc_hidden[482];
acc_hidden[483]<=acc_hidden[483][15]?0:acc_hidden[483];
acc_hidden[484]<=acc_hidden[484][15]?0:acc_hidden[484];
acc_hidden[485]<=acc_hidden[485][15]?0:acc_hidden[485];
acc_hidden[486]<=acc_hidden[486][15]?0:acc_hidden[486];
acc_hidden[487]<=acc_hidden[487][15]?0:acc_hidden[487];
acc_hidden[488]<=acc_hidden[488][15]?0:acc_hidden[488];
acc_hidden[489]<=acc_hidden[489][15]?0:acc_hidden[489];
acc_hidden[490]<=acc_hidden[490][15]?0:acc_hidden[490];
acc_hidden[491]<=acc_hidden[491][15]?0:acc_hidden[491];
acc_hidden[492]<=acc_hidden[492][15]?0:acc_hidden[492];
acc_hidden[493]<=acc_hidden[493][15]?0:acc_hidden[493];
acc_hidden[494]<=acc_hidden[494][15]?0:acc_hidden[494];
acc_hidden[495]<=acc_hidden[495][15]?0:acc_hidden[495];
acc_hidden[496]<=acc_hidden[496][15]?0:acc_hidden[496];
acc_hidden[497]<=acc_hidden[497][15]?0:acc_hidden[497];
acc_hidden[498]<=acc_hidden[498][15]?0:acc_hidden[498];
acc_hidden[499]<=acc_hidden[499][15]?0:acc_hidden[499];
acc_hidden[500]<=acc_hidden[500][15]?0:acc_hidden[500];
acc_hidden[501]<=acc_hidden[501][15]?0:acc_hidden[501];
acc_hidden[502]<=acc_hidden[502][15]?0:acc_hidden[502];
acc_hidden[503]<=acc_hidden[503][15]?0:acc_hidden[503];
acc_hidden[504]<=acc_hidden[504][15]?0:acc_hidden[504];
acc_hidden[505]<=acc_hidden[505][15]?0:acc_hidden[505];
acc_hidden[506]<=acc_hidden[506][15]?0:acc_hidden[506];
acc_hidden[507]<=acc_hidden[507][15]?0:acc_hidden[507];
acc_hidden[508]<=acc_hidden[508][15]?0:acc_hidden[508];
acc_hidden[509]<=acc_hidden[509][15]?0:acc_hidden[509];
acc_hidden[510]<=acc_hidden[510][15]?0:acc_hidden[510];
acc_hidden[511]<=acc_hidden[511][15]?0:acc_hidden[511]; end 
            
/////////// OUTPUT LAYER //////////////////
always @(posedge clk)
    if(PS==L2 && output_con)
        acc_out[out_addr]<=acc_out[out_addr]+M0;
    else if(PS==IDLE) begin
        acc_out[0] <=0;
        acc_out[1] <=0;
        acc_out[2] <=0;
        acc_out[3] <=0;
        acc_out[4] <=0;
        acc_out[5] <=0;
        acc_out[6] <=0;
        acc_out[7] <=0;
        acc_out[8] <=0;
        acc_out[9] <=0; end

////////////////// INSTANSTIATION OF ROM for W21 ////////////////////////////

ROM_W21 R(rom_addr,w21_temp);
// W21 Weights from ROM
always @(output_con,w21_temp)
        if(output_con)
            W21=w21_temp;
        else
            W21=0;  
            
 // 16_16 to 32-bit MULTIPLIER               
  MUL_16 a0(output_con,acc_hidden[hidden_addr_out],W21,m0);

  
  always @(m0,output_con)
    if(output_con) 
        M0=m0;
     else
        M0=0;
  
//output_accumulator to 10-bit mapping --- MAX FINDER
 max m(clk,{acc_out[0],acc_out[1],acc_out[2],acc_out[3],acc_out[4],acc_out[5],acc_out[6],acc_out[7],acc_out[8],acc_out[9]},max_con,data_out_temp,valid_temp);
 always @(valid_temp,data_out_temp)
    if(valid_temp)begin
        data_out=data_out_temp;
        valid=valid_temp;
        output_comp=valid_temp; end
    else begin
        valid=0;
        output_comp=0;
        data_out=0;
        end         
endmodule
