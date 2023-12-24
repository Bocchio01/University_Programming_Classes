function [plotter_campito] = Riempi_Profilo(plot, c_int, c_pro, stampa)
% "Colora" i campi racchiusi da una linea chiusa in una matrice
%   Data P una matrice contenente tutti campi = 0 tranne che in
%   corrispondenza delle linee di profilo dell'immagine finale, la funzione:
%   M = Riempi_Profilo(P,Ci,Cp,S) ritorna una matrice M di dimensioni pari
%   a P, avente tutti i campi racchiusi tra le linee di P inizializzati = Ci.
%
%   Per esempio:
%   P = 0 1 1 1 0    Ci = 0.2    Cp = 1     S = 0
%       0 1 0 0 1
%       0 1 0 0 1
%       0 0 1 1 0
%
%   Ritorna:
%   M = 0 1  1   1  0
%       0 1 0.2 0.2 1
%       0 1 0.2 0.2 1
%       0 0  1   1  0
%
%   Se S = 1, stampa a video la matrice M dopo aver aggiornato una riga.

    plotter_campito = Crea_Matrice (length(plot(:,1)), length(plot(1,:)), 2);
    k = -1;
    livello = 1;

    for y = [2:length(plot(:,1)) length(plot(:,1))-1:-1:1]
        
        x_col=find(plot(y,:)==c_pro);
        
        for x = 1:length(x_col)-1
            if (x_col(x+1)~=x_col(x)+1)
                if(plot(y+k,x_col(x)+1:-1+x_col(x+1))==c_pro | plotter_campito(y+k,x_col(x)+1:-1+x_col(x+1),livello)==c_int)
                    plotter_campito(y,x_col(x)+1:-1+x_col(x+1),livello) = c_int;
                end
            end
        end

        if (stampa)
            imshow(plotter_campito(:,:,livello));
        end

        if (y==length(plot(:,1)))
            k = +1;
            livello = 2;
        end
        
    end

    plotter_campito = (plotter_campito (:,:,1) & plotter_campito (:,:,2))*c_int+plot;
    
    if (stampa)
        imshow(plotter_campito);
        pause(2);
    end
    
end