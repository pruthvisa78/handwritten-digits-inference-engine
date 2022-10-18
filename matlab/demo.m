%%
clc
close all;
clear all;
load("weights_512.mat") %W21
load("test_sample.mat") %importing test sample of 10 numbers
W10=rand_lfsr_512; % W10 from lfsr
%showing input images
digit_0 = reshape(test_sample(1,:),16,16);
digit_1 = reshape(test_sample(2,:),16,16);
digit_2 = reshape(test_sample(3,:),16,16);
digit_3 = reshape(test_sample(4,:),16,16);
digit_4 = reshape(test_sample(5,:),16,16);
digit_5 = reshape(test_sample(6,:),16,16);
digit_6 = reshape(test_sample(7,:),16,16);
digit_7 = reshape(test_sample(8,:),16,16);
digit_8 = reshape(test_sample(9,:),16,16);
digit_9 = reshape(test_sample(10,:),16,16);
subplot(2,5,1)
imshow(digit_0')
subplot(2,5,2)
imshow(digit_1')
subplot(2,5,3)
imshow(digit_2')
subplot(2,5,4)
imshow(digit_3')
subplot(2,5,5)
imshow(digit_4')
subplot(2,5,6)
imshow(digit_5')
subplot(2,5,7)
imshow(digit_6')
subplot(2,5,8)
imshow(digit_7')
subplot(2,5,9)
imshow(digit_8')
subplot(2,5,10)
imshow(digit_9')
% inference part
Y=ReLU(test_sample*W10)*parameters.W21;
M=max(Y');
for i=1:10
    for j=1:10
        if(Y(i,j)==M(i))
            Y(i,j)=1;
        else
            Y(i,j)=0;
        end
    end
end

%% output to numbers
for i=1:10
    disp('Predicted digit is : ')
    disp(arr2num(Y(i,:)))
end