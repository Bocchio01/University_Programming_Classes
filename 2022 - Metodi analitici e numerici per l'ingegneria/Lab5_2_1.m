clc
clear variables
close all

%% Section 1

f = @(x) cosh(x - 1/2);
V = @(x) pi * f(x) .* f(x);
Vex = pi * ((sinh(1) + sinh(3/5))/4 + 2/5);

a = 0;
b = 0.8;

x = linspace(a, b, 1000);
y = f(x);

nexttile
hold on
grid on
title('Integrand function')
plot(x, y, 'LineWidth', 2)
legend('$\cosh(x - \frac{1}{2})$', 'Interpreter', 'latex', 'FontSize', 15)
ylim([0 max(y)+0.5])

% Not mandatory

nexttile
[X,Y,Z] = cylinder(y);
surf(Z, Y, X)
shading interp
axis square

%% Section 2
% pmedcomp()

%% Section 3
% trapcomp()

%% Section 4
% simpcomp()

%% Section 5

N = 1:20;

Ipm = zeros(1, length(N));
It = zeros(1, length(N));
Is = zeros(1, length(N));

for n = N

    Ipm(n) = pmedcomp(a, b, n, V);
    It(n) = trapcomp(a, b, n, V);
    Is(n) = simpcomp(a, b, n, V);

end

nexttile
hold on
grid on
title('Integral approximational functions comparison')
yline(Vex, '-')
plot(N, Ipm, 'ro', ...
    N, It, 'gd', ...
    N, Is, 'b*')
xlabel('N')
legend('Exact integral', 'Middle point','Trapezoid', 'Simpson method')

%% Section 6

H = (b-a)./N;

Epm = abs(Ipm - Vex);
Et = abs(It - Vex);
Es = abs(Is - Vex);

nexttile
hold off
loglog(H, Epm, 'ro', ...
    H, Et, 'gd', ...
    H, Es, 'b*', ...
    H, H.^2, ...
    H, H.^4)
grid on
title('Error analysis')
xlabel('H')
legend('Middle point','Trapezoid', 'Simpson method', '$H^2$', '$H^4$', 'Interpreter', 'latex')

%% Section 7

TOLL = 1e-5;

d2f = @(x) 2*pi*(2*(cosh(x - 0.5)).^2 -1);
d4f = @(x) 8*pi*(2*(cosh(x - 0.5)).^2 -1);

Npm = ceil(sqrt(abs(((b-a)^3 * max(d2f(x)))/(24*TOLL))));
Nt = ceil(sqrt(abs(((b-a)^3 * max(d2f(x)))/(-12*TOLL))));
Ns = ceil((abs(((b-a)^5 * max(d4f(x)))/(2880*TOLL))^(1/4)));

abs(Vex - pmedcomp(a, b, Npm, V))
abs(Vex - trapcomp(a, b, Nt, V))
abs(Vex - simpcomp(a, b, Ns, V))














