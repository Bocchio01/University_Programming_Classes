[r c]=size(m)
if r~=c
    risulato=-1;
else
    %diag prende tutti i vlori della diagonale
    d=abs(diag(m))
    %mett 1 sulla digolane e 0 tutti gli altri
    %prendo m, e dove e diagonale(=1) pongo zero
    %eye crea una matrice di 1 sulla diagonale
    m(logical(eye(size(m))))=0
    %m' trasposta = rida diventa colonna e viceversa
    sum_rows=sum(abs(m'))
    risultato=all(sum_rows<d')
end
