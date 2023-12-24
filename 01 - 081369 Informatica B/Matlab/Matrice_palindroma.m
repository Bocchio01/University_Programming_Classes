M = [1,2,3;3,4,5;1,2,3];

sim=1;
for k=[1:floor(size(M,1)/2)]
    if any(M(k,:)~=M(end-k+1,:))
        sim=0;
    end
end

if(sim)
    disp('é simmetrica!');
else
    disp ('non è simmetrica!');
end
