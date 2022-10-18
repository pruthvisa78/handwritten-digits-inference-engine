clc;
close all;
clear all;
W=load("weights_512.mat"); %importing stored W21 weights
dataX=load("X_test.mat"); %importing inputs for 493 test cases
dataY=load("Y_test.mat"); %importing outputs for 493 test cases
W10=rand_lfsr_512;        % generating W10 using lfsr
% inference part
Y=ReLU(dataX.X_test*W10)*W.parameters.W21; 
M=max(Y');
for i=1:493
    for j=1:10
        if(Y(i,j)==M(i))
            Y(i,j)=1;
        else
            Y(i,j)=0;
        end
    end
end
%accuracy check
count=0;
for i=1:493
    if(Y(i,:)==dataY.Y_test(i,:))
        count=count+1;
    end
end
accuracy= (count*100)/493
