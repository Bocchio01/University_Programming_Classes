clc
clear variables
close all

%% Section 1

t0 = 0;
tf = 1 * 365 * 24 * 60 * 60;

GM = 398600; % km/s^2
y0 = [405500 0 0 0.964]';

F = @(t, y) [
    y(3);
    y(4);
    -GM * (y(1) / (y(2)^2 + y(1)^2)^(3/2));
    -GM * (y(2) / (y(2)^2 + y(1)^2)^(3/2));
    ];

[t_h, u_h] = ode45(F, [t0, tf], y0);

plotGraphs(t_h, u_h);


%% Section 2
% We change the default value of tolerance in the built-in function ODE45
% We obsereve that now the trajectory is close upon the satellite (he
% doesn't get closer to Earth over time)

options = odeset('reltol',1e-6);
[t_h, u_h] = ode45(F, [t0, tf], y0, options);

plotGraphs(t_h, u_h);


%% Section 3

t0 = 0;
tf = 30 * 24 * 60 * 60;

GM = 398600; % km/s^2
y0 = [405500 0 0 0.964]';
C = 1e-6;
RT = 6360;
RL = 1737;

F = @(t, y) [
    y(3);
    y(4);
    -GM * (y(1) / (y(2)^2 + y(1)^2)^(3/2)) - C * y(3);
    -GM * (y(2) / (y(2)^2 + y(1)^2)^(3/2)) - C * y(4);
    ];

options = odeset('reltol',1e-6);
[t_h, u_h] = ode45(F, [t0, tf], y0, options);

plotGraphs(t_h, u_h);


t_impact = find( sqrt(u_h(:, 1).^2 + u_h(:, 2).^2) < RT + RL, 1 );
days_before_impact = t_h(t_impact) / (60 *60 *24);
velocity_at_impact = sqrt(u_h(t_impact, 3).^2 + u_h(t_impact, 4).^2);

sprintf('Expected impact at day = %0.2f, with velocity = %0.2f Km/s', days_before_impact, velocity_at_impact)

%% Utils

function plotGraphs(t_h, u_h)
nexttile
hold on
grid on
plot(u_h(:, 1), u_h(:, 2), 'k', ...
    0, 0, '-or')
title('Satellite orbits over Earth, tf = 1 [year]');
legend('Satellite trajectory', 'Earth position')
ylabel('y')
xlabel('x')

nexttile
hold on
grid on
plot(t_h, sqrt(u_h(:, 1).^2 + u_h(:, 2).^2), '-k', ...
    'LineWidth', 2)
title('Distance Satellite-Earth over time')
legend('distance(t)')
ylabel('distance')
xlabel('t')

nexttile
hold on
grid on
plot(t_h(1:end-1), diff(t_h), '.-k')
title('Adaptive h step')
legend('h value')
ylabel('h')
xlabel('t')

sprintf('Min distance = %0.2f Km', min(sqrt(u_h(:, 1).^2 + u_h(:, 2).^2)))

end






























