mat=[1,2,3,4; 5,6,7,8;]
%rot90(mat)
N=4;
for x=[1:1:N]
    for y=[1:1:N]
        MAT(N-y+1,x) =mat(x,y);
    end
end
disp(MAT)