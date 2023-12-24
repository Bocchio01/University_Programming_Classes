clc
clear variables
close all

%% Section 1

N = 50;

A = zeros(N) + ...
    diag(4 * ones(N, 1), 0) + ...
    diag(-1 * ones(N-1, 1), 1) + diag(-1 * ones(N-2, 1), 2) + ...
    diag(-1 * ones(N-1, 1), -1) + diag(-1 * ones(N-2, 1), -2);

b = 0.2 * ones(N, 1);
x0 = zeros(N, 1);


%% Section 2

spy(A' - A)

eigvalue = eig(A);
eigmax = max(eigvalue)
eigmin = min(eigvalue)

K2 = eigmax / eigmin;


%% Section 3
% function richardson


%% Section 4

TOLL = 1e-6;
nmax = 10000;
Alpha = [0.2 0.33 2/(eigmax+eigmin)];

for alpha = Alpha

    P = eye(N);
    B = eye(N) - alpha * (P\A);
    rho = sqrt(max(eig(B' * B)))

    [X, iter] = richardson(A, b, P, x0, TOLL, nmax, alpha);

end


%% Section 5

TOLL = 1e-6;
nmax = 10000;
alpha = 1;

P = diag(diag(A));
B = eye(N) - alpha * (P\A);
rho = sqrt(max(eig(B' * B)))

[X, iter] = richardson(A, b, P, x0, TOLL, nmax, alpha);


%% Section 6

TOLL = 1e-6;
nmax = 10000;
alpha = 1;

P = tril(A);
B = eye(N) - alpha * (P\A);
rho = sqrt(max(eig(B' * B)))

[X, iter] = richardson(A, b, P, x0, TOLL, nmax, alpha);


%% Section 7

P = zeros(N) + ...
    diag(2 * ones(N, 1), 0) + ...
    diag(-1 * ones(N-1, 1), 1) + ...
    diag(-1 * ones(N-1, 1), -1);

spy(P' - P)

eigvalue = eig(P\A);
eigmax = max(eigvalue)
eigmin = min(eigvalue)

K2 = eigmax / eigmin;

alpha_opt = 2/(eigmax+eigmin)


B = eye(N) - alpha_opt * (P\A);
rho = sqrt(max(eig(B' * B)))

[X, iter] = richardson(A, b, P, x0, TOLL, nmax, alpha_opt);






