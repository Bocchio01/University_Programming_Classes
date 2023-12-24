clc
clear variables
close all

%% Section 1 & 2

y0 = 1;
lambda = -2;
t_max = 10;

y_ex = @(t) y0 * exp(lambda * t);
f = @(t, y) lambda * y;
df = @(t, y) lambda;

t = linspace(0, 10, 100);

for h = [0.1 0.9 1.1]

    [t_h_EE, u_h_EE] = eulero_avanti(f, t_max, y0, h);
    [t_h_EI, u_h_EI] = eulero_indietro(f, df, t_max, y0, h);

    nexttile
    hold on
    grid on
    plot(t, y_ex(t), 'r', ...
        t_h_EE, u_h_EE, 'g', ...
        t_h_EI, u_h_EI, 'b', ...
        'LineWidth', 2)
    title(sprintf('Case with lambda=%0.2f & h=%0.2f', lambda, h))
    legend('y_ex', 'EE', 'EI')

end