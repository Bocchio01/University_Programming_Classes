function [mat] = Crea_Matrice (h, l, d)
% Crea una matrice di zeri (0).
%    M = Crea_Matrice(Y,X,Z) ritorna una matrice M con Y-righe, X-colonne,
%    e Z-dimensioni, inizializzata = 0

    h = floor(h);
    l = floor(l);
    mat = zeros(h,l,d);
    
end