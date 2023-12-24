clc
clear variables
close all

%% Section 1

f = @(x)  x.^3 - (2+exp(1))*x.^2 + (2*exp(1)+1)*x + (1-exp(1)) - cosh(x-1);
df = @(x) 3*x.^2 - 2*(2+exp(1))*x + (2*exp(1)+1) - sinh(x-1);
d2f = @(x) 6*x - 2*(2+exp(1)) - cosh(x-1);

a = 0.5;
b = 6.5;

x = linspace(a, b, 100);
y = f(x);
dy = df(x);
d2y = d2f(x);

nexttile
hold on
grid on
title('Function & Derivatives')
yline(0, '-k')
plot(x, y, ...
    x, dy, ...
    x, d2y, ...
    'LineWidth', 2)
legend('$y = 0$', ...
    '$f(x)$', ...
    '$\frac{df(x)}{dx}$', ...
    '$\frac{d^2f(x)}{dx^2}$', ...
    'Interpreter', 'latex', ...
    'FontSize', 15)


%% Section 2
% Observing the graph is clear that:
%   @x=1 -> zeros multiplicity m=2
%   @x~3.55 -> zeros multiplicity m=1
%   @x~6.35 -> zeros multiplicity m=1

alpha1 = 1;
if (abs(df(alpha1)) < 5*eps)
    if (abs(d2f(alpha1)) < 5*eps )
        disp('m >= 2')
    else
        disp('m = 2')
    end
else
    disp('m = 1')
end


%% Section 3
% newton function

%% Section 4 & 5

nmax = 100;
TOLL = 1e-6;

x0 = [0.5 0.5 3.5 6.3];
m = [1 2 1 1];

hold off
nexttile

for i = 1:length(x0)

    [X_vect, iter] = newton(x0(i), nmax, TOLL, f, df, m(i));
    stimap(X_vect);

    alpha = X_vect(end);
    err = abs(X_vect - alpha);

    semilogy(1:iter, err)
    hold on

end

grid on
title('Error trend')
ylabel('Error')
xlabel('Iteration')

legend('Alpha = 1 -> m = 1', ...
    'Alpha = 1 -> m = 2', ...
    'Alpha = 3.5 -> m = 1', ...
    'Alpha = 6.3 -> m = 1')

