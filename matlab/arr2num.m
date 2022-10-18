function [num] = arr2num(Y)
for i=1:length(Y)
    if(Y(i)==1)
        num=i-1;
    end
end
end