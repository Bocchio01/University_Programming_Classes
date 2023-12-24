function [t_h,u_h]=theta_metodo_cc(A,g,t_max,y_0,h, theta)

%[t_h,u_h]=theta_metodo_cc(A,t_max,y_0,h, theta)
% Risolve il problema di Cauchy vettoriale di dimensione m>=1 con 
% f(t,y) = A y + g(t), ovvero un sistema in forma non omogena a
% coefficienti constanti
%
% y'=f(y,t)  per t \in I=(0,t_max), 
% y(0)=y_0
%
% utilizzando il metodo di theta-metodo. Il problema si riconduce a
% risolvere un sistema lineare ad ogni passo:
% ( I - h \theta A ) u_{n+1} = ( I - h ( 1 - \theta ) A ) u_{n} + ...
%                           h [ ( 1 - \theta ) g(t_n) + \theta g(t_{n+1}) ] 
%                            per n=0,1,\ldots
% 
%
% Input:
% -> A: matrice A tale che f(t,y) = A y + g(t)
% -> g: funzione di t tale che f(t,y) = A y + g(t)
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

% inizializzo il vettore che conterra' la soluzione discreta
N   = length(t_h);
m = length(y_0);
u_h = zeros(m,N);
u_h(:,1) = y_0;

A1 = eye( m, m ) - h * theta * A;
A2 = eye( m, m ) + h * ( 1 - theta ) * A;

for it=2:N
    u_h( :, it ) = A1 \ ( A2 * u_h( :, it - 1 ) ...
                             + h * ( ( 1 - theta ) * g( t_h( it - 1 ) ) ...
                                              + theta * g( t_h( it ) ) ) );
end