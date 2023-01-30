clc
clear variables
close all

%% Section 1 & 2 & 3

TOLL = 1e-6;
iterN_v = [];
iterJ_v = [];

N = 10:10:100;
for n = N

    A = gallery('wathen', n, n);
    b = ones(size(A, 1), 1);

    [x, f, r, iterN] = pcg(A, b, TOLL, length(b));

    Jacobi = diag(diag(A));
    [x, f, r, iterJ] = pcg(A, b, TOLL, length(b), Jacobi);

    iterN_v = [iterN_v, iterN];
    iterJ_v = [iterJ_v, iterJ];

end


nexttile
plot(N, iterN_v, '-*b', ...
    N, iterJ_v, '-*r', ...
    'LineWidth', 2)
grid on
xlabel('Matrix size')
ylabel('Iterations')
legend('No precondition', 'Jacobi precondition')


