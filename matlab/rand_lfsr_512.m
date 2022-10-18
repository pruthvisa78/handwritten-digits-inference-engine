function [rand] = rand_lfsr_512()
%LFSR 16 bit maximal length of 65535 combinations
Seed=14472;
Seed=de2bi(Seed,16);
Seed_temp=[];
S(1,:)=Seed;
for i=2:65536
    for j=1:15
        Seed_temp(j+1)=Seed(j);
    end
    Seed_temp(1)=xor(Seed(16),xor(Seed(5),xor(Seed(3),Seed(2))));
    Seed=Seed_temp;
    S(i,:)=Seed;
end
%  deriving 8-bit numbers from lfsr values taking 8 from one 16-bit
for j=1:2:65536*2
    for k=1:2
    rand_8b(j+k-1,:) = S(((j+3)/2)-1,2*k+3:2*k+10);
    end
end
% binary to decimal of signed 
for p=1:65536*2
    if(rand_8b(p,1)==1)
        randt(p)=-(bi2de(~rand_8b(p,2:8),'left-msb')+1);
    else 
        randt(p)= bi2de(rand_8b(p,2:8),'left-msb');
    end
end
% normalizing to (-1,1)
randt = randt*(2^-7); % 7 bit prescison

% mapping into 256x2048 matrix
for s=1:256
    for t=1:512
        rand(s,t)=randt(512*(s-1)+t);
    end
end

end