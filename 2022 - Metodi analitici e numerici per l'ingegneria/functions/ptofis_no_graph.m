function [SUCC, it] = ptofis(X0, PHI, nmax, toll)
% [SUCC, it] = ptofis(X0, PHI, nmax, toll)
% Metodo di punto fisso X = PHI(X) 
%
% --------Parametri di ingresso:
% X0      Vettore di partenza (vettore colonna)
% PHI     Funzione di punto fisso (definita inline o anonimous): PHI = PHI(t,y)
% nmax    Numero massimo di iterazioni
% toll    Tolleranza sul test d'arresto (norma dell'incremento)
%
% --------Parametri di uscita:
% SUCC    Matrice contenente tutte le iterate calcolate
%         (l'ultima colonna e' la soluzione)
% it      Iterazioni effettuate

err   = 1 + toll;
it    = 0;
SUCC  = X0;
XV    = X0;

while (it < nmax && err > toll)
   XN    = PHI(XV);
   err   = norm(XN - XV);
   SUCC = [SUCC XN];   
   it    = it + 1;
   XV    = XN;
end

%fprintf(' \n Numero di Iterazioni    : %d \n',it);
%fprintf(' Punto fisso calcolato   : %12.13f \n',SUCC(:,end));
