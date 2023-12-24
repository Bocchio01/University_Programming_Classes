function [t_h,u_h] = theta_method(fun,t_max,y_0,h,theta)
%[t_h,u_h]=theta_method(fun,t_max,y_0,h,theta)
% Risolve il problema di Cauchy vettoriale di dimensione m>=1
%
% y'=f(y,t)  per t \in I=(0,t_max), 
% y(0)=y_0
%
% utilizzando il metodo di theta-metodo.
% Per ciascun istante temporale si calcola u_(n+1)
% trovando lo zero dell'equazione (a priori non lineare)
% F(u) = u - u_n - h * ( (1-theta) * f(t_{n},u_n) + theta * f(t_{n+1},u) )
% con il metodo delle iterazioni di punto fisso tramite le funzione di
% iterazione:
% phi(u) = u_n + h * ( (1-theta) * f(t_{n},u_n) + theta * f(t_{n+1},u) )
%
% Input:
% -> f: function che descrive il problema di Cauchy
%       (dichiarata come anonymous function)
%       deve ricevere in ingresso due argomenti: 
%       f = @(t,y) : (0,T) x R^m -> R^m, m >=1
% -> t_max: l'istante finale dell' intervallo temporale di soluzione
%                 (l'istante iniziale e' t_0=0)
% -> y_0: il dato iniziale del problema di Cauchy, un vettore di R^m
% -> h: l'ampiezza del passo di discretizzazione temporale
% -> theta: parametro del theta-metodo, theta \in [0,1]
%
% Output:
% -> t_h: vettore degli istanti in cui si calcola la soluzione discreta
% -> u_h: la soluzione discreta calcolata nei nodi temporali t_h, una
%         matrice con m righe e N colonne

t0 = 0;
t_h = t0:h:t_max;

nmax = 1000;
toll = 1e-12;

% inizializzo la matrice che conterra' la soluzione discreta
N = length(t_h);
m = length(y_0);
u_h = zeros(m,N);

u_h(:,1) = y_0;

for n = 1:length(t_h)-1
    % calcolo uh(:,n+1)
    W0 = u_h(:,n); % u_old, n è l'indice dell'istante corrente
    
    PHI = @(W) u_h(:,n) + ...
        h*( (1-theta)*fun(t_h(n),u_h(:,n)) + theta*fun(t_h(n+1),W) );
    
    [SUCC, ~] = ptofis_no_graph(W0, PHI, nmax, toll);
    u_h(:,n+1) = SUCC(:,end);
    
end
  
end