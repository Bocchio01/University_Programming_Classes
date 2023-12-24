N=3;
ii=1;
jj=1;
l=1;
while (ii<=N)
    jj=ii;
    while(jj<=N)
        matrice(ii,jj)= input('Inserisci il valore: ');
        vettore(l)=matrice(ii,jj);
        l=l+1;
        jj=jj+1;
    end
    ii=ii+1;
end

matrice
vettore