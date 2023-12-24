function [plotter_profilo] = Disegna_Profilo(dati_profilo, h, l, colore, stampa)
% Crea una matrice raffigurante linee spezzate monocolore.
%   Data P una matrice n*2, avente P(n,1) = le coordinate y di un punto
%   'n', e P(n,2) = le coordinate x di un punto 'n', la funzione
%   M = Disegna_Profilo(P,Y,X,C,S) ritorna una matrice monodimensionale M
%   di dimensioni Y*X, avente i campi toccati dalle rette che idealmente 
%   congiungono due punti 'n' e 'n+1' = C, e i restanti = 0.
%
%   Per esempio:
%   P = 1 1     X = 5     Y = 4     C = 255/255     S = 0
%       1 4
%       3 5
%       0 0
%       3 1
%       4 2
%
%   Ritorna:
%   M = 1 1 1 1 0
%       0 0 0 1 1
%       1 0 0 0 1
%       0 1 0 0 0
%
%   Con P(n,1:2) == 0, indichiamo che il tratto da 'n-1' a 'n+1' debba
%   rimanere invariato.
%
%   Inoltre se S = 1, finito il segmento che congiunge 'n' e 'n+1', stampa 
%   a video la matrice.

    py = floor(dati_profilo(:,1)*h/500);
    px = floor(dati_profilo(:,2)*l/1000);
    n_pezzi = sum(dati_profilo(:,1)==0)+1;

    py(py==0 | dati_profilo(:,1)==1) = 1;
    px(px==0 | dati_profilo(:,2)==1) = 1;
    plotter_profilo = Crea_Matrice (h, l/2, 1);
    
    for n_tratto=1:length(px)-n_pezzi

        if (dati_profilo(n_tratto+1)==0)
            plotter_profilo (py(n_tratto), px(n_tratto)) = colore;
            dati_profilo (n_tratto+1, :) = [];
            px(n_tratto+1) = [];
            py(n_tratto+1) = [];
        else
            plotter_provvisorio = Crea_Matrice(h+2, l/2+2, 1);

            ang = -(py(n_tratto+1)-py(n_tratto))/(px(n_tratto+1)-px(n_tratto));
            
            if(~isnan(ang))
                
                if (abs(ang)==Inf)
                    passox = 0;   %Se la linea è verticale
                elseif (px(n_tratto)>px(n_tratto+1))
                    passox = -1;  %Se si sviluppa verso sinistra
                else
                    passox = 1;   %Se si sviluppa verso destra
                end

                if (py(n_tratto)>py(n_tratto+1))
                    passoy = -1;  %Se si sviluppa verso l'alto
                else
                    passoy = 1;   %Se si sviluppa verso il basso
                end

                k = 0;
                
                if(passox~=0)   %ovvero la linea si sviluppa obliquamente/orizzontalmente
                    t = 1;
                    %Cicla finchè il bit affianco (qualsiasi direzione) alle coordinate
                    %del punto 'n+1' è ~= 0
                    while (plotter_provvisorio(py(n_tratto+1)-t+1:py(n_tratto+1)+t+1,px(n_tratto+1)-t+1:px(n_tratto+1)+t+1)==0)
                        plotter_provvisorio(floor(py(n_tratto)-k*ang*passox)+1:passoy:floor(py(n_tratto)-(k+1)*ang*passox)+1, px(n_tratto)+(k*passox)+1) = colore;
                        k = k+1;
                    end
                else            %ovvero la linea si sviluppa verticalmente
                    plotter_provvisorio(py(n_tratto)+1:passoy:py(n_tratto+1)+1, px(n_tratto)+1) = colore;
                end
                
                plotter_provvisorio = plotter_provvisorio(2:end-1,2:end-1);
                plotter_profilo = plotter_profilo+plotter_provvisorio;
            
            end
        end

        if (stampa)
            figure
            imshow([plotter_profilo fliplr(plotter_profilo)]);
            pause(0.2);
        end
        
    end
    
    plotter_profilo(plotter_profilo>colore) = colore;
    plotter_profilo = [plotter_profilo fliplr(plotter_profilo)];
    
end