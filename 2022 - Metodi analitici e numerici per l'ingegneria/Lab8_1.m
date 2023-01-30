clc
clear variables
close all

%% Section 1
% theta_method function


%% Section 2

y0 = [1  1]';
t0 = 0;
tf = 5;

A = [0 1;
    -100 -101];
F = @(t, y) A * y;
y_ex = @(t) [exp(-t);
    2*exp(-100*t) - exp(-t)];

t = linspace(t0, tf, 1000);
y = y_ex(t);

theta = 0;
h = 1e-4;

[t_h, u_h] = theta_method(F, tf, y0, h, theta);

nexttile
hold on
grid on
plot(t_h, u_h(1, :), 'r', ...
    t_h, u_h(2, :), 'g', ...
    t, y(1, :), 'k', ...
    t, y(2, :), 'k', ...
    'LineWidth', 2)
title('Discrete solution with theta=0')
legend('y_1', 'y_2')


%% Section 3
% Knowing the condition of absolute stabilty for the
% Eulerian_Forword_Method, is possible to validate the max h that prove the
% condition: |1 + lambda_i * h| < 1

lambda = eig(A);
h_lim = abs(max(2 ./ lambda));

for h = h_lim + [0.001 -0.001]

    nexttile
    hold on
    grid on
    [t_h, u_h] = theta_method(F, tf, y0, h, theta);

    plot(t_h, u_h(1, :), 'r', ...
        t_h, u_h(2, :), 'g', ...
        'LineWidth', 2)
    title(sprintf('Discrete solution with h=%0.3f', h))
    legend('y_1', 'y_2')

end


%% Section 4

[t_h, u_h] = ode45(F, [t0, tf], y0);

nexttile
hold on
grid on

plot(t_h, u_h(:, 1), 'r', ...
    t_h, u_h(:, 2), 'g', ...
    'LineWidth', 2)
title('Discrete solution using ODE45');
legend('y_1', 'y_2')

nexttile
hold on
grid on
plot(t_h(1:end-1), diff(t_h), '.-k')
title('Adaptive h from ODE 45 reslution')
legend('delta_h')


%% Section 5

theta = 0.5;
h = 1e-4;

[t_h, u_h] = theta_method(F, tf, y0, h, theta);

nexttile
hold on
grid on
plot(t_h, u_h(1, :), 'r', ...
    t_h, u_h(2, :), 'g', ...
    t, y(1, :), 'k', ...
    t, y(2, :), 'k', ...
    'LineWidth', 2)
title('Discrete solution with theta=0.5')
legend('y_1', 'y_2')


lambda = eig(A);
h_lim = abs(max(2 ./ lambda));

for h = abs(h_lim + [0.1 1])

    nexttile
    hold on
    grid on
    [t_h, u_h] = theta_method_cc(A, @(t) 0, tf, y0, h, theta);

    plot(t_h, u_h(1, :), 'r', ...
        t_h, u_h(2, :), 'g', ...
        'LineWidth', 2)
    title(sprintf('Discrete solution with h=%0.3f', h))
    legend('y_1', 'y_2')

end








