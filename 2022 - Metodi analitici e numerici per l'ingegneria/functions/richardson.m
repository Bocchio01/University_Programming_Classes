function [ x, k ] = richardson( A, b, P, x0, tol, nmax, alpha)
%
% Metodo di Richardson stazionario precondizionato
%
% Parametri di ingresso:
%
% A: matrice di sistema
% b: vettore termine noto
% P: precondizionatore
% x: guess iniziale
% tol:  tolleranza criterio d'arresto
% nmax: numero massimo di iterazioni ammesse
% alpha: parametro di accelerazione
%
% Parametri di uscita:
%
% x: soluzione
% k: numero di iterazioni
%

n = length(b);
if ((size(A,1) ~= n) || (size(A,2) ~= n) || (length(x0) ~= n))
  error('Dimensioni incompatibili')
end

x = x0;
k = 0;
r = b - A * x;
res_normalizzato  = norm(r) / norm(b);

while ((res_normalizzato > tol) && (k < nmax))
     z = P \ r; % risolve il sistema lineare con un metodo diretto
     x = x + alpha * z; % xnew = xold + alpha*z => xnew - xold = alpha*z
     r = r - alpha * A * z; % equivalente a: r = b - A * x; 
     res_normalizzato  = norm(r) / norm(b);
     k = k + 1;
end

if (res_normalizzato < tol)
     fprintf('Richardson converge in %d iterazioni \n', k);
else
     fprintf('Richardson non converge in %d iterazioni. \n', k)
end
