a=[1,3,5,9,15];
val=input("inserisci un numero:");
k=1;
while (k<=length(a) && a(k)<=val)
    k=k+1;
end

a = [a(1:k-1),val,a(k:end)];
disp(a);
    