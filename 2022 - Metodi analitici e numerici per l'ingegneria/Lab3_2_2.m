clc
clear variables
close all

%% Section 1
% function invpower


%% Section 2

A = toeplitz(1:4);
TOLL = 1e-6;
nmax = 100;

% Here x0 is not orthogonal to the eigenvector.
% The method works as expected.
x0 = [1 2 3 4]';
[lambda_1, autovect_1, iter_1] = invpower(A, TOLL, nmax, x0);


% Here x0 is orthogonal to the eigenvector.
% What is founded is not the smallest eigvalue,
% but the second smallest.
x0 = [1 1 1 1]';
[lambda_2, autovect_2, iter_2] = invpower(A, TOLL, nmax, x0);

sprintf('lambda_1 == lambda_2: %d', lambda_1 == lambda_2)


%% Section 3

% Using the invpower_mod, we don't stop by a tolerance, but continue for
% nmax iteration. Into the 'min_eigenvec_comp' is loaded the projection of
% the i-esim eigenvector onto the eigenvector associated to the smallest
% eigenvalue (the target of the function)
[lambda, x, min_eigenvec_comp] = invpower_mod(A, nmax, x0);

nexttile
semilogy(min_eigenvec_comp)
grid on
title('Projection')



