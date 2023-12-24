function [K, M, f, xn] = diffusionetrasporto_DirichletNeumann(L, h, mu, sigma, fun)

N = L / h - 1;
% numero di nodi interni

Nh = N + 1; % nodi interni + 1 = nodi interni + nodo di bordo a destra
K = mu/h * ( diag(2*ones(Nh, 1)) + diag(-1*ones(Nh - 1, 1), +1) + diag(-1*ones(Nh - 1, 1), -1) );
K(end, end) = mu/h;

M = sigma*h* ( 2/3*diag(ones(Nh, 1)) + 1/6*diag(ones(Nh - 1, 1), +1) + 1/6*diag(ones(Nh - 1, 1), -1) );
M(end, end) = 1/3*sigma*h;

xn = linspace(0, L, N + 2)';
xinterni = xn(2:end-1);
f = [h*fun(xinterni); h/2*fun(xn(end))];

end