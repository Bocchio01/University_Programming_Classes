clc
clear variables
close all

%% Section 1
% function gradiente


%% Section 2

N = 50;

A = zeros(N) + ...
    diag(4 * ones(N, 1), 0) + ...
    diag(-1 * ones(N-1, 1), 1) + diag(-1 * ones(N-2, 1), 2) + ...
    diag(-1 * ones(N-1, 1), -1) + diag(-1 * ones(N-2, 1), -2);

b = 0.2 * ones(N, 1);
x0 = ones(N, 1);
x_ex = A \ b;

TOLL = 1e-5;


nexttile

NMAX = 1:500
for nmax = NMAX

    P = eye(N);
    [X, iter] = gradiente(A, b, P, x0, TOLL, nmax);
    err_rel(nmax) = norm(X - x_ex) / norm(x_ex);
    res_norm(nmax) = norm(b - A*X) / norm(b);

end

semilogy(NMAX, err_rel, NMAX, res_norm)
hold on
grid on
legend('Relative error', 'Residual normalized')