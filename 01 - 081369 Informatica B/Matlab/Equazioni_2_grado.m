%Equazione di secondo grado
%17/11/2020
%Tommaso Bocchietti

a=input('Inserisci a: ');
b=input('Inserisci b: ');
c=input('Inserisci c: ');

if (a==0)
    if(b~=0)
        x=-c/b
    end
else
    delta = (b^2)-4*a*c;
    if (delta==0)
        x=-b/2*a
    elseif (delta>0)
        x1=(-b+sqrt(delta))/2*a
        x2=(-b-sqrt(delta))/2*a
    elseif (delta<0)
        disp('Nessuna radice reale');
    end
end
        