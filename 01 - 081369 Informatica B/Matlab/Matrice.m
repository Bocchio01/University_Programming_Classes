m=[-2,2,3;4,5,6];
avg=mean(m(:));

m(m<avg)=-1;
m(m>avg)=1;
m(m==avg)=avg;
disp(m);
%mr2=reshape(mr2,2,3)