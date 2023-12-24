clc
clear variables
close all

%% Section 1

y0 = 0;
yex = @(t) 1/2 * asin((exp(4*t) - 1) ./ (exp(4*t) + 1));
f = @(t, y) cos(2*y);
df = @(t, y) -2*sin(2*y);

Tmax = 6;
t = linspace(0, Tmax, 100);

nexttile
hold on
plot(t, yex(t), 'k', 'LineWidth', 2);
grid on
title('Exact solution')
legend('y_{ex}')


%% Not mandatory
% Just to observe how the function evolves in space changing the Cauchy
% condition (or initial condition @t=0)
nexttile
hold on
grid on

for ystart = [2:0.05:6]

    [t_h, u_h] = eulero_avanti(f, Tmax, ystart, 0.01);

    plot(t_h, u_h, 'k', 'LineWidth', 1);
    
    title('Exact solution')
end

%% Section 2
% EE, EI, CN, Heun functions


%% Section 3 & 4

err_EE = [];
err_EI = [];
err_CN = [];
err_HN = [];

iter_EI = [];
iter_CN = [];

H = 0.4 ./ 2.^[0:5];

for h = H

    [t_h_EE, u_h_EE] = eulero_avanti(f, Tmax, y0, h);
    [t_h_EI, u_h_EI, iter_nwt_EI] = eulero_indietro(f, df, Tmax, y0, h);
    [t_h_CN, u_h_CN, iter_nwt_CN] = crank_nicolson(f, df, Tmax, y0, h);
    [t_h_HN, u_h_HN] = heun(f, Tmax, y0, h);

    err_EE = [err_EE max(u_h_EE - yex(t_h_EE))];
    err_EI = [err_EI max(u_h_EI - yex(t_h_EI))];
    err_CN = [err_CN max(u_h_CN - yex(t_h_CN))];
    err_HN = [err_HN max(u_h_HN - yex(t_h_HN))];

    iter_EI = [iter_EI max(iter_nwt_EI)];
    iter_CN = [iter_CN max(iter_nwt_CN)];

    nexttile
    hold on
    grid on
    plot(t_h_EE, u_h_EE, 'r', ...
        t_h_EI, u_h_EI, 'g', ...
        t_h_CN, u_h_CN, 'b', ...
        t_h_HN, u_h_HN, 'y', ...
        'LineWidth', 2);
    title(sprintf('Cauchy resolution method comparison %0.2f', h))
    legend('EE', 'EI', 'CN', 'HN')

end


%% Section 5

nexttile
hold off
loglog(H, err_EE, 'r', ...
    H, err_EI, 'g', ...
    H, err_CN, 'b', ...
    H, err_HN, 'y', ...
    H, H, '--k', ...
    H, H.^2, '-k', ...
    'LineWidth', 2);
grid on
title('Cauchy resolution method error comparison')
legend('EE', 'EI', 'CN', 'HN', 'H', 'H^2')

nexttile
hold on
plot(H, iter_EI, 'gx', ...
    H, iter_CN, 'bo', ...
    'LineWidth', 2);
grid on
title('Implicit methods n_iterations')
legend('iter_EI', 'iter_CN')

%% Section 6
% eulero_indietro_ptofis, crank_nicolson_ptofis functions


%% Section 7

err_EI = [];
err_CN = [];

h = 0.5;

[t_h_EI, u_h_EI, iter_ptofis] = eulero_indietro_ptofis(f, Tmax, y0, h);
[t_h_CN, u_h_CN, iter_ptofis] = crank_nicolson_ptofis(f, Tmax, y0, h);

err_EI = [err_EI max(u_h_EI - yex(t_h_EI))];
err_CN = [err_CN max(u_h_CN - yex(t_h_CN))];

nexttile
hold on
grid on
plot(t_h_EI, u_h_EI, 'g', ...
    t_h_CN, u_h_CN, 'b', ...
    'LineWidth', 2);
title(sprintf('Cauchy resolution method comparison %0.2f', h))
legend('EI_ptofis', 'CN_ptofis')


%% Section 8

[t_h_ODE23, u_h_ODE23] = ode23(f, [0 Tmax], y0);

nexttile
hold on
grid on
plot(t_h_ODE23, u_h_ODE23, 'k', 'LineWidth', 2)
title('Solution using ODE23, similar to Runge-Kutta')
legend('ODE23')


