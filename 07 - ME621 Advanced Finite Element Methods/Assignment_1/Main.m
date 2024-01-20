clc
clear variables
close all

addpath('Assignment_1\models')

%% Problem datas

modified_NR = false;

geometry = struct( ...
    'L', [3 0.5], ...
    'A', 1e-3 * [1 1], ...
    'E', 70e+9 * [1 1]);

N_steps = 1000;
tolerance = 1e-5;

U = [0 0]';
P = [0 0]';
delta_P = 5 * [1 1]';

assert(isequal(size(geometry.L), size(geometry.A), size(geometry.E)), 'Inconsistent input geometry data');


%% Relationships Forces = f(Displacements)
% Obtained using Mathematica.
% For our purpose, we just need the formulation of Kt and Fint.
% Diifferent model have been computed and they are stored in appropriate
% functions listed below. In particular, we have:
% - model_exact: Exact model with no geometrical approximations
% - model_taylor_1: 1° order taylor series of the exact model
% - model_taylor_2: 2° order taylor series of the exact model
% - model_taylor_3: 3° order taylor series of the exact model
% - model_approximation: Hand-made approximation of the exact model.
%   Assumptions:    small displachment of node B
%                   cos(alpha)->1
%                   sin(alpha)->0
%                   cos(beta)->1
%                   sin(beta)->0

models = {
    @(U, geometry) model_exact(U, geometry), ...
    @(U, geometry) model_taylor_1(U, geometry), ...
    @(U, geometry) model_taylor_2(U, geometry), ...
    @(U, geometry) model_taylor_3(U, geometry), ...
    % @(U, geometry) model_approximated(U, geometry),...
    };

results = cell(size(models));
for i = 1:length(models)
    results{i} = createResultStruct(size(U, 1), N_steps);
end


%% Models solution

inverse = @(A) A \ eye(size(A));
residual = @(P, Fi) Fi - P;

for model_idx = 1:length(models)
    for step = 1:N_steps
        P = P + delta_P;

        [Kt, Fi] = models{model_idx}(U, geometry);

        Kt0_inv = inverse(Kt);
        U = method_euler(U, delta_P, Kt0_inv);

        tic;
        iteractions = 0;
        while(norm(residual(P, Fi), 1) > tolerance)

            iteractions = iteractions + 1;

            [Kt, Fi] = models{model_idx}(U, geometry);

            Kt_inv = ~modified_NR * inverse(Kt) + modified_NR * Kt0_inv;
            U = method_newton_raphson(U, residual(P, Fi), Kt_inv);

        end
        time = toc;

        % Saving result in the results data structure
        results{model_idx}.U(step, :) = U;
        results{model_idx}.iteractions(step) = iteractions + 1;
        results{model_idx}.time(step) = time;

    end
end


%% Plots

nexttile
hold on
grid on

A = [0, 0.5];
B = [3, 0.5];
C = [3, 0];

draw_problem(A, B, C);

scale_factor = 1e3;
for model_idx = 1:length(models)
    Bf = (scale_factor * results{model_idx}.U(end,:) + [3 0.5]);

    h = plot([A(1), Bf(1)], [A(2), Bf(2)], '--', 'DisplayName', func2str(models{model_idx}));
    plot([C(1), Bf(1)], [C(2), Bf(2)], '--', 'Color', get(h, 'Color'));
end

lineHandles = [];
legendNames = cell(1, length(models));

for model_idx = 1:length(models)
    Bf = (scale_factor * results{model_idx}.U(end,:) + [3 0.5]);

    h1 = plot([A(1), Bf(1)], [A(2), Bf(2)], '--');
    h2 = plot([C(1), Bf(1)], [C(2), Bf(2)], '--', 'Color', get(h1, 'Color'));

    lineHandles(model_idx) = h1;
    legendNames{model_idx} = func2str(models{model_idx});
end

legend(lineHandles, legendNames, 'Location', 'Best', 'Interpreter', 'none');


%% Functions

function [] = draw_problem(A, B, C)

% Plot initial position
plot([A(1), B(1)], [A(2), B(2)], '-b', 'LineWidth', 2);
plot([C(1), B(1)], [C(2), B(2)], '-b', 'LineWidth', 2);

% Set axis properties
axis equal;
xlim([-0.5, 4]);
ylim([-0.1, 1]);

end

function resultStruct = createResultStruct(U_size, N_steps)

resultStruct = struct( ...
    'U', zeros(N_steps, U_size), ...
    'iterations', zeros(N_steps, 1), ...
    'time', zeros(N_steps, 1));

end






