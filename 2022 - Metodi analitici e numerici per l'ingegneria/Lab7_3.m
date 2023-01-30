clc
clear variables
close all

%% Section 1
y0 = 0;
t_max = 10;
t = linspace(0, t_max, 100);
h = 0.2;

y_ex = @(t, y) sin(t) .* exp(-t./2);
f = @(t, y) cos(t) .* exp(-t./2) - 0.5 * y;
% df = @(t,y) -0.5;


t_h = 0:h:t_max;
u_h_EI = zeros(1, length(t_h));
u_h_CN = zeros(1, length(t_h));

for n = 1:length(t_h)-1
    u_h_EI(n+1) = (u_h_EI(n) + h*cos(t_h(n+1))*exp(-t_h(n+1)/2))/(1+h/2);
    u_h_CN(n+1) = (u_h_CN(n) + h/2*(cos(t_h(n))*exp(-t_h(n)/2) - 1/2*u_h_CN(n) + cos(t_h(n+1))*exp(-t_h(n+1)/2)))/(1+h/4);
end

nexttile
hold on
grid on
plot(t, y_ex(t), 'k', ...
    t_h, u_h_EI, 'ro-', ...
    t_h, u_h_CN, 'go-', ...
    'LineWidth', 2);
title('From implicit to explicit method using linearity of f(t, y)')
legend('y_ex', 'EI', 'CN')
