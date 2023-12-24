clc
clear variables
close all

%% Section 1

f = @(x) cos(2*x).^2 - x.^2;

a = 0;
b = pi/2;

x = linspace(a, b, 1000);
y = f(x);

nexttile
hold on
grid on
title('Starter function')

yline(0, '-k')
plot(x, y, 'LineWidth', 2)
legend('$y = 0$','$\cos^2(2x) - x^2$', 'Interpreter', 'latex')

%% Section 2

% Ostrowski's theorem
% abs(dphi) < 1
% phi(x) = x + A * f(x)
% dphi(x) = 1 + A * df(x)
% dphi(x) = 1 + A * (-4 * cos(2*x) * sin(2*x) - 2*x)
% -1 < dphi < 1
% -2 < A * df(x) < 0

% Because df(alpha) from the graph is negative, then:
%  0 < A < -2 / (-4 * cos(2*x) * sin(2*x) - 2*x)

%% Section 3 && 5

A = 0.1;
x0 = 0.1;
TOLL = 1e-10;
nmax = 1000;

X_vect = plotgraph(x0, @(x) x + A * f(x), A, nmax, TOLL, a, b, 0);
% alpha founded -> check for A limits
alpha = X_vect(end);
A_min = 0;
A_max = -2 / (-4 * cos(2*alpha) * sin(2*alpha) - 2*alpha);



% Test for various values of A and x0
A = [0.1 0.6 0.8 0.8];
x0 = [2 0.1 0.5 0.51493326];

for i = 1:length(A)

    X_vect = plotgraph(x0(i), @(x) x + A(i) * f(x), A(i), 1000, TOLL, a, b, 0);

end


%% Section 4

[x0, X_vect] = bisection(f, 0, b, 10);
A = 0.1;

X_vect = plotgraph(x0, @(x) x + A * f(x), A, nmax, TOLL, a, b, 0);


%% Section 6

% Second order convergence if dphi(alpha) = 0
% dphi(alpha) = 1 + A * df(alpha) = 0


df = @(x) (-4 * cos(2*x) .* sin(2*x) - 2*x);

A = 0.1;
x0 = 0.1;

X_vect = plotgraph(x0, @(x) x + A * f(x), A, nmax, TOLL, a, b, 0);


% alpha founded -> calculate A to have second order convergence
alpha = X_vect(end);

A_second_order = -1 / df(alpha);
x0 = 0.1;

X_vect = plotgraph(x0, @(x) x + A_second_order * f(x), A_second_order, nmax, TOLL, a, b, 1);



%% Section 7

sol_vect = [];
x0_vect = [0.01:0.5:1];

nexttile

for x0 = x0_vect

    [X_vect, iter] = ptofis(x0, @(x) x - f(x)/df(x), 1000, TOLL, a, b);
    sol_vect = [sol_vect X_vect(end)];

end

plot(x0_vect,sol_vect,'o--')
title('PhiNewtow convergence value')
xlabel('x0')
ylabel('alpha founded')


X_vect = plotgraph(0.8, @(x) x - f(x)./df(x), 0, nmax, TOLL, -3, 6, 1);




function X_vect = plotgraph(x0, phi, A, nmax, toll, a, b, boolstimap)

    nexttile
    [X_vect, iter] = ptofis(x0, phi, nmax, toll, a, b);
    grid on

    [order] =  stimap(X_vect);
    legend(sprintf('Convergence: %d', iter ~= nmax), ...
        sprintf('(A=%0.2g | x0=%0.2g)', A, x0), ...
        sprintf('Order of convergece=%0.2g', order))

end












