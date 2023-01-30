clc
clear variables
close all

%% Section 1

f = @(x) x/2 .* cos(x);

a = -2;
b = 6;

x = linspace(a, b, 1000);
y = f(x);

nexttile
hold on
grid on
title('Starter function')
plot(x, y, 'LineWidth', 2)
legend('$\frac{x}{2} \cos(x)$', 'Interpreter', 'latex')

%% Section 2

N = [2 4 6];

Y = [];

nexttile
hold on
grid on
title('Lagrange polynomials')
plot(x, y, '--b', 'LineWidth', 2)

for n = N

    x_nodes = linspace(a, b, n+1);
    y_nodes = f(x_nodes);

    P = polyfit(x_nodes, y_nodes, length(x_nodes)-1);
    Y = [Y; polyval(P, x)];

    plot(x, Y(end, :), 'LineWidth', 2)

end

legend('Target function', 'Lagrange grade 2', 'Lagrange grade 4', 'Lagrange grade 6')


%% Section 3

err = [];
err_max = [];

nexttile
hold on
grid on
title('Lagrange polynomials error')

for i = [1:length(N)]

    err(i, :) = abs(y - Y(i, :));
    err_max(i) = max(err(i, :));
    plot(x, err(i, :), 'LineWidth', 2)

end

legend('Lagrange grade 2', 'Lagrange grade 4', 'Lagrange grade 6')


nexttile
hold on
grid on
title('Lagrange polynomials error trend')

for i = [1:length(N)]

    plot(N(i), err_max(i), '*', 'LineWidth', 2)

end

legend('Lagrange grade 2', 'Lagrange grade 4', 'Lagrange grade 6')


%% Section 4

N = 2.^[2:6];
Y = [];
err_max = [];
H = [];

nexttile
hold on
grid on
title('Linear Interpolation polynomials')

for n = N

    H = [H (b-a)/n];
    x_nodes = [a:H(end):b];
    y_nodes = f(x_nodes);
    Y = interp1(x_nodes, y_nodes, x);

    err_max = [err_max max(abs(y - Y))];

    plot(x, Y, 'LineWidth', 2)

end

legend('Nodes = 4', ...
    'Nodes = 8', ...
    'Nodes = 16', ...
    'Nodes = 32', ...
    'Nodes = 64')


%% Section 5

d2f = @(x) 0.5 * (2*sin(x) - cos(x));

nexttile
loglog(H, err_max, '-*', ...
    H, H, '--k', ...
    H, H.^2, '-k', ...
    'LineWidth', 2)

grid on
xlabel('H')
title('Lagrange polynomials error trend')
legend('Max error calculated', 'H', 'H^2')


%% Section 6

n = 8;
H = (b-a)/n;
x_nodes =[a:H:b];
y_nodes = f(x_nodes);

Y = spline(x_nodes, y_nodes, x);

nexttile
hold on
grid on
title('Spline interpolation')
plot(x, y, x, Y, 'linewidth',2)
legend('Target function', 'Spline function')

%% Section 7

n = 4;
m = 2;
H = (b-a)/n;
x_nodes = [a:H:b];
y_nodes= f(x_nodes);
P = polyfit(x_nodes, y_nodes, m);
Y = polyval(P, x);

nexttile
hold on
grid on
title('Minimun errors quadratic interpolation')
plot(x, y, x, Y, 'linewidth',2)
legend('Target function', 'Minimun errors quadratic')









