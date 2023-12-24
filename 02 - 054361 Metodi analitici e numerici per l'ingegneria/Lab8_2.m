clc
clear variables
close all

% SEIR model
% Suscettibili
% Esposti (in incubazione, non ancora infettivi)
% Infetti
% Rimossi (deceduti, vaccinati, etc..)

%% Section 1

t0 = 0;
tf = 300; % days

N = 1e7;
E0 = 100;
I0 = 30;
R = 0;
S0 = N -E0 - I0 - R;

h = 0.25;
theta = 0.5;
y0 = [S0, E0, I0]';


% beta = 0.7586; % 1/days
alpha = 1 / 5.2; % 1/days
gamma = 1 / 2.9; % 1/days

% We study the model changing the beta coefficient in order to vary also
% r0 = beta / gamma = base reproduction number
for beta = [0.5 0.7586 gamma 2*gamma]

    F = @(t, y) [
        -beta/N * (y(1) .* y(3));
        beta/N * (y(1) .* y(3)) - alpha * y(2);
        alpha * y(2) - gamma * y(3);
        ];


    [t_h, u_h] = theta_method(F, tf, y0, h, theta);

    nexttile
    hold on
    grid on
    plot(t_h, u_h(1, :), 'r', ...
        t_h, u_h(2, :), 'g', ...
        t_h, u_h(3, :), 'b', ...
        t_h, N - (u_h(1, :) + u_h(2, :) + u_h(3, :)), 'k', ...
        'LineWidth', 2);
    title(sprintf('SEIR model, r0 = %0.3f', beta/gamma))
    legend('S', 'E', 'I', 'R')

end


%% Section 2

beta = @(t) 0.7586 * (t < 80) + ...
    0.25 * (t >= 80) .* (t < 120) + ...
    0.65 * (t >= 120);

F = @(t, y) [
    -beta(t)/N * (y(1) .* y(3));
    beta(t)/N * (y(1) .* y(3)) - alpha * y(2);
    alpha * y(2) - gamma * y(3);
    ];


[t_h, u_h] = theta_method(F, tf, y0, h, theta);

nexttile
hold on
grid on
plot(t_h, u_h(1, :), 'r', ...
    t_h, u_h(2, :), 'g', ...
    t_h, u_h(3, :), 'b', ...
    t_h, N - (u_h(1, :) + u_h(2, :) + u_h(3, :)), 'k', ...
    'LineWidth', 2);
title('SEIR model, beta variable over time (@t=[80 120])')
legend('S', 'E', 'I', 'R')








