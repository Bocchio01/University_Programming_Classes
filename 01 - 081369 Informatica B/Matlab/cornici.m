function [M] = cornici(N,P);
M = P * ones(N);
k=1;
while k<N/2
    M(k+1:N-k, k+1:N-k) = P+k;
    k=k+1
end
end