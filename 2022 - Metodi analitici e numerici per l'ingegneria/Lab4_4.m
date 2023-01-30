clc
clear variables
close all

%% Section 1

f = @(x) atan(7*(x-pi/2)) + sin((x-pi/2).^3);

df = @(x) 7./( 1+49*(x-pi/2).^2 ) + 3*(x-pi/2).^2 .* cos((x-pi/2).^3);

a = -1;
b = 6;

x = linspace(a, b, 100);
y = f(x);
dy = df(x);

nexttile
hold on
grid on
title('Function')
yline(0, '-k')
plot(x, y, '-g', ...
    x, dy, '--b', ...
    'LineWidth', 2)
legend('$y = 0$', ...
    '$\arctan(7*(x-\frac{\pi}{2})) + \sin((x-\frac{\pi}{2})^3)$', ...
    '$\frac{7}{1+49(x-\frac{\pi}{2})^2} + 3(x-\frac{\pi}{2})^2 * \cos((x-\frac{\pi}{2})^3)$', ...
    'Interpreter', 'latex', ...
    'FontSize', 15)

axis([a b min(y), max(y)])


%% Section 2
% Observing the graph, the only zeros is at x=pi/2

alpha = pi/2;

nmax = 1000;
TOLL = 1e-6;

x0 = 1.5;
[X_vect_1, iter_1] = newton(x0, nmax, TOLL, f, df, 1);
err_1 = abs(X_vect_1 - alpha);
stimap(X_vect_1);

x0 = 4;
[X_vect_2, iter_2] = newton(x0, nmax, TOLL, f, df, 1);
err_2 = abs(X_vect_2 - alpha);
stimap(X_vect_2);

hold off
nexttile

semilogy(1:iter_1, err_1, '-b', ...
    1:iter_2, err_2, '-r', ...
    'LineWidth', 2)
grid on
title('Newton method, different x0')
legend('x0 = 1.5', 'x0 = 4')
xlabel('Iterations')
ylabel('Error')



