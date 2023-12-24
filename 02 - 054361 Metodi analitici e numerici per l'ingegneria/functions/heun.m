function [t_h,u_h]=heun(f,t_max,y_0,h)

% [t_h,u_h]=heun(f,t_max,y_0,h)
%
% Risolve il problema di Cauchy 
%
% y'=f(y,t)
% y(0)=y_0
%
% utilizzando il metodo di Heun:
% u^(n+1)=u^n+h/2*(f^n+f(t^(n+1),u^n+h*f^n)) 
%
% Input:
% -> f: function che descrive il problema di Cauchy 
%       (dichiarata ad esempio tramite inline o @). 
%       Deve ricevere in ingresso due argomenti: f=f(t,y)
% -> t_max: l'istante finale dell' intervallo temporale di soluzione 
%                 (l'istante iniziale e' t_0=0)
% -> y_0: il dato iniziale del problema di Cauchy
% -> h: l'ampiezza del passo di discretizzazione temporale.
%
% Output:
% -> t_h: vettore degli istanti in cui si calcola la soluzione discreta
% -> u_h: la soluzione discreta calcolata nei nodi temporali t_h

% vettore degli istanti in cui risolvo la edo
t0 = 0 ;
t_h = t0:h:t_max;
% inizializzo il vettore che conterra' la soluzione discreta
N = length(t_h);
u_h = zeros(1,N);
u_h(1) = y_0;

% ciclo for 
for it = 2:N
    u_old = u_h(it-1);
    u_star = u_old + h * f(t_h(it-1), u_old);
    u_h(it) = u_old + h/2 * ( f(t_h(it-1), u_old) + f(t_h(it), u_star) );
end