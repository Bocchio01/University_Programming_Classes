function [bandT] = Livelli_Colore(plotter_campito, grad, neg)
% Assegna una matrice(x*y) ad uno o pù z di una matrice(x*y*z).
%   M = Livelli_Colore(P,C,N) ritorna una matrice M di dimensioni pari a
%   P(:,:,1), colorata secondo il colore C e le regole di pixel 'RGB'.
%
%   Per esempio:
%   P = 1 1 1   C = 'Rosso'     N = 0
%       0 0 0
%       1 1 1
%
%   Ritorna:
%   Una matrice tridimensionale M, avente la prima e l'ultima fila di pixel
%   rosse e quella centrale bianca.
%
%   Con N = 1, ritorna M ma con i colori in "negativo" (Esempio: il
%   negativo del rosso è il ciano, quello del giallo il blu,...).
% 
%   C può assumere valori: 'Nero';
%                          'Bianco';
%                          'Rosso';
%                          'Verde';
%                          'Blu';
%                          'Giallo';
%                          'Magenta';
%                          'Ciano'.

    bandT = Crea_Matrice (length(plotter_campito(:,1)), length(plotter_campito(1,:)), 3);

    switch(grad)
        case('Nero')
            bandT(:,:,1) = plotter_campito;
            bandT(:,:,2) = plotter_campito;
            bandT(:,:,3) = plotter_campito;
        case('Bianco')
            bandT(:,:,1) = 1-plotter_campito;
            bandT(:,:,2) = 1-plotter_campito;
            bandT(:,:,3) = 1-plotter_campito;
        case('Rosso')
            bandT(:,:,2) = plotter_campito;
            bandT(:,:,3) = plotter_campito;
        case('Verde')
            bandT(:,:,1) = plotter_campito;
            bandT(:,:,3) = plotter_campito;
        case('Blu')
            bandT(:,:,1) = plotter_campito;
            bandT(:,:,2) = plotter_campito;
        case('Giallo')
            bandT(:,:,3) = plotter_campito;
        case('Magenta')
            bandT(:,:,2) = plotter_campito;
        case('Ciano')
            bandT(:,:,1) = plotter_campito;
    end

    if (neg==0)
        bandT = 1-bandT;
    end

end