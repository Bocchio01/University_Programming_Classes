clc
clear variables
close all

%% Section 1

data = [
    1 0.00 0.00;
    2 0.06 0.08;
    3 0.14 0.14;
    4 0.25 0.20;
    5 0.31 0.23;
    6 0.47 0.25;
    7 0.60 0.28;
    8 0.70 0.29
    ];

sigma = data(:, 2);
eps = data(:, 3);

x = linspace(sigma(1), sigma(end) + 0.10, 1000);

% Langrange
Plagrange =  polyfit(sigma, eps, length(sigma)-1);
Ylagrange = polyval(Plagrange, x);

nexttile
hold on
grid on
title('Lagrange methods comparison')
plot(sigma, eps, 'k*', ...
    x, Ylagrange, ...
    'LineWidth', 1)
legend('Data', 'Lagrange')
xlabel('Strain')
ylabel('Stress')

% Linear interpolation
Ylinear = interp1(sigma, eps, x);

nexttile
hold on
grid on
title('Linear methods comparison')
plot(sigma, eps, 'k*', ...
    x, Ylinear, ...
    'LineWidth', 1)
legend('Data', 'Linear')
xlabel('Strain')
ylabel('Stress')


% Quadratic error minization
N = [1 2 4];

Yquadratic = [];

for n = N

    Pquadratic = polyfit(sigma, eps, n);
    Yquadratic = [Yquadratic; polyval(Pquadratic, x)];

end

nexttile
hold on
grid on
title('Quadratic error minization comparison')
plot(sigma, eps, 'k*', ...
    x, Yquadratic(1, :), ...
    x, Yquadratic(2, :), ...
    x, Yquadratic(3, :), ...
    'LineWidth', 1)
legend('Data', 'Err minimization (grade = 1)', 'Err minimization (grade = 2)', 'Err minimization (grade = 4)')
xlabel('Strain')
ylabel('Stress')

%% Section 2

nexttile
hold on
grid on
title('Interpolation methods comparison')
plot(sigma, eps, 'k*', ...
    x, Ylagrange, ...
    x, Ylinear, ...
    x, Yquadratic(3, :), ...
    'LineWidth', 1)
legend('Data', 'Lagrange', 'Linear', 'Err minimization (grade = 4)')
xlabel('Strain')
ylabel('Stress')

%% Section 3

results = [];
targets = [0.40 0.75];

for target = targets
    results(1, end+1) = polyval(Plagrange, target);
    results(2, end) = interp1(sigma, eps, target);
    results(3, end) = polyval(Pquadratic, target);
end

plot(targets, results(1,:), 's', ...
    targets, results(2,:), '+', ...
    targets, results(3,:), 'v')




