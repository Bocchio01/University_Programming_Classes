N = input("Quanti numeri vuoi inserire?");

for x=[1:N]
    a(x)=input("fprintf('Inserisci il numero %d',x)");
end

val=input("Inserici valore confronti: ");


if (min(a)>val)
    disp('Tutti maggiori');
elseif (max(a)<val)
    disp('Tutti minori');
elseif (max(a)==min(a)==val)
    disp('Tutti uguali');
else
    disp('Nulla');
end

    
    
         