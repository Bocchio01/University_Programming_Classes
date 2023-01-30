function [t_h,u_h,iter_ptofis]=crank_nicolson_ptofis(f,t_max,y_0,h)

%[t_h,u_h,iter_nwt]=crank_nicolson(f,df,t_max,y_0,h)
% Risolve il problema di Cauchy
%
% y'=f(y,t)
% y(0)=y_0
%
% utilizzando il metodo di Crank-Nicolson.
% Per ciascun istante temporale si calcola u_(n+1)
% trovando lo zero dell'equazione (a priori non lineare)
% F(u) = u - u_n - h/2*( f(t_{n},u_n) + f(t_{n+1},u) )
% con il metodo delle iterazioni di punto fisso tramite le funzione di
% iterazione:
% phi(u) = u_n + h/2*( f(t_{n},u_n) + f(t_{n+1},u) )
%
% Input:
% -> f: function che descrive il problema di Cauchy
%       (dichiarata come anonymous function)
%       deve ricevere in ingresso due argomenti: f = @(t,y)
% -> t_max: l'istante finale dell' intervallo temporale di soluzione
%                 (l'istante iniziale e' t_0=0)
% -> y_0: il dato iniziale del problema di Cauchy
% -> h: l'ampiezza del passo di discretizzazione temporale.
%
% Output:
% -> t_h: vettore degli istanti in cui si calcola la soluzione discreta
% -> u_h: la soluzione discreta calcolata nei nodi temporali t_h
% -> iter_ptofis: vettore che contiene il numero di iterazioni
%                 del metodo di delle iterazioni di punto fisso 
%                 necessarie a risolvere l'equazione
%                 non lineare ad ogni istante temporale.

t0 = 0;
t_h = t0:h:t_max;
% inizializzo il vettore che conterra' la soluzione discreta
N   = length(t_h);
u_h = zeros(1,N);
u_h(1) = y_0;
% parametri per il metodo delle iterazioni di punto fisso
nmax = 100;
toll = 1e-12;
iter_ptofis=zeros(1,N-1);
for it=2:N
    t_old = t_h(it-1);
    u_old = u_h(it-1);
    t_new = t_h(it);
    
    % Funzione di iterazione
    phi  = @(w) u_old + (h/2)*( f(t_old,u_old) + f(t_new, w) );
    % Sottoiterazioni del metodo delle iterazioni di punto fisso
    [succ, k] = ptofis_no_graph(u_old, phi, nmax, toll);
    
    u_h(it) = succ(end);
    iter_ptofis(it-1) = k;
end