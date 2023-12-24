clc
clear variables
close all

%% Section 1

f = @(x) 1./(1+x.^2);

a = -5;
b = 5;

x = linspace(a, b, 100);

figure(1)
hold on
grid on
title('Lagrange equispaced nodes distance')

plot(x, f(x), '-k', 'LineWidth', 2)

figure(2)
hold on
grid on
title('Error Lagrange equispaced nodes distance')

N = [5 10];

for n = N
    x_nodes = linspace(a, b, n+1);
    y_nodes = f(x_nodes);
    P = polyfit(x_nodes, y_nodes, length(x_nodes)-1);
    Y = polyval(P, x);

    err = abs(f(x) - Y);

    figure(1)
    plot(x, Y, '-', ...
        'LineWidth', 1)

    figure(2)
    plot(x, err, '--', ...
        'LineWidth', 1)

end

figure(1)
legend('Runge function', 'Lagrange grade 5', 'Lagrange grade 10')

figure(2)
legend('Error grade 5','Error grade 10')


%% Section 2

figure(3)
hold on
grid on
title('Lagrange Chebyshev–Gauss–Lobatto nodes')

plot(x, f(x), '-k', 'LineWidth', 2)

figure(4)
hold on
grid on
title('Errors Lagrange Chebyshev–Gauss–Lobatto nodes')

N = [5 10];

for n = N
    i_vec = [0:n];
    x_nodes = (a+b)/2 + (b-a)/2*(-cos((pi*i_vec)/n));
    y_nodes = f(x_nodes);
    P = polyfit(x_nodes, y_nodes, length(x_nodes)-1);
    Y = polyval(P, x);

    err = abs(f(x) - Y);

    figure(3)
    plot(x, Y, '-', ...
        'LineWidth', 1)

    figure(4)
    plot(x, err, '--', ...
        'LineWidth', 1)

end

figure(3)
legend('Runge function', 'Lagrange grade 5', 'Lagrange grade 10')

figure(4)
legend('Error grade 5','Error grade 10')
