function [K, f, xn] = diffusione_Dirichlet(L, h, mu, fun)

Nh = L / h - 1; % Numero dei nodi interni
% Numero di nodi interni + bordo = N + 2;
% L/h = Numero di sottointervalli = nodi interni + 1 = tutti i nodi - 1
% Numero dei soli nodi interni = N = sottointervalli - 1

xn = linspace( 0, L, Nh + 2 );

K = mu / h * ( diag( 2 * ones( Nh, 1 ), 0 ) ...
    + diag( - 1 * ones( Nh - 1, 1 ), 1 ) ...
    + diag( - 1 * ones( Nh - 1, 1 ), -1 ) );

f = h * fun( xn( 2 : end - 1 )' );

end