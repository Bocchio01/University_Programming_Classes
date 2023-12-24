clc
clear variables
close all

%% Section 1

f = @(x) x/(2*pi) .* sin(x);

a = 0;
b = 2*pi;

x = linspace(a, b, 1000);
y = f(x);

nexttile
hold on
grid on
title('Integrand function')
plot(x, y, "-r", "LineWidth",2)
legend('$\frac{x}{2 \pi} \sin x$','Interpreter','latex', 'FontSize', 15)

xticks(x * pi);
xticklabels( string(x) + "\pi" )

%% Section 2

Iex = -1;
N = 1:20;

Ipm = [];
It = [];
Is = [];

nexttile
hold on
grid on
title('Integral approximation formulas comparison')
yline(Iex,'-');

for n = N
    Ipm = [Ipm pmedcomp(a, b, n, f)];
    It = [It trapcomp(a, b, n, f)];
    Is = [Is simpcomp(a, b, n, f)];


    plot(n, Ipm(end), 'ro', ...
        n, It(end), 'gd', ...
        n, Is(end), 'b*')
end

legend('Exact integral', 'Middle point', 'Trapezoid', 'Simpson formula')

%% Section 3

Iex = -1;
N = 1:20;
H = (b-a)./N;

Epm = abs(Ipm - Iex);
Et = abs(It - Iex);
Es = abs(Is - Iex);

nexttile
hold off
loglog(H, Epm, 'ro', ...
    H, Et, 'gd', ...
    H, Es, 'b*', ...
    H, H.^2, '-', ...
    H, H.^4)
grid on
title('Integral approximation formulas error analysis')
legend('Middle point', 'Trapezoid', 'Simpson formula','H^2', 'H^4')

%% Section 4

TOLL = 10e-5;

d2f = @(x) (2*cos(x)-x.*sin(x))/(2*pi);

% EPM = (b-a)/24 * maxd2f * (b-a/N)^2

N = ceil(sqrt(((b-a)^3 * max(d2f(x)))/(24*TOLL)));

Ipm = pmedcomp(a, b, N, f);

Epm_at_N = abs(Iex - Ipm);

N
Epm_at_N




















