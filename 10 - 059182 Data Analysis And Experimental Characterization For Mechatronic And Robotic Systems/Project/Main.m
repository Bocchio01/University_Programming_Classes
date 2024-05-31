% Structural Health Monitoring of tie-rods via MSD and PCA methods
%
% Perform a SHM analysis over experimental datasets, using two different
% approaches and different tuning of them:
%   - Mahalanobis Square Distance (MSD)
%   - Principal Component Analysis (PCA)
%
% Author: Tommaso Bocchietti
% Date: 22/05/2024
%
% Instruction:
% Provide in the 'data' subfolder the following '.mat' files:
%   - temperatures.mat: vector (1 x N_ref) containing the temperature
%   registered during the experimental campaing
%   - frequencies.mat : matrix (N_ref x M) containing the first M computed
%   eigenfrequencies of the structure, sampled during the experimental campaing
%
% Set 'plots' to true for visualization of different plots.
%
% Requires:
%   - Statistics and Machine Learning Toolbox.
%
% Reference course: 059182 (Politecnico di Milano A.Y. 2023/2024)


clc
clear variables
close all

%% Load data

data.temperature_vet = load('data/temperatures.mat').TEMP';
data.frequencies_mat = load('data/frequencies.mat').frequencies;

assert(...
    length(data.temperature_vet) == size(data.frequencies_mat, 1), ...
    'Temperature vector and Frequencies matrix does not agree in size');


%% Compute common anonymus functions and vector

compute_window = @(percentage) round(percentage * size(data.frequencies_mat, 1));

time_vet = 10/60 * 1/24 * (0:length(data.temperature_vet) - 1)';


%% Algorithm parameters for each set of analysis run

parameters = cell(0);
results = cell(0);

parameters{end+1} = compose_struct_MSD(compute_window(20/100), false);
% parameters{end+1} = compose_struct_MSD(compute_window(40/100), true);
% parameters{end+1} = compose_struct_PCA(compute_window(20/100), compute_window(10/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(80/100), compute_window(80/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(40/100), compute_window(0.25 * 40/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(40/100), compute_window(2.00 * 40/100), 1);

% For Baseline analysis
% parameters{end+1} = compose_struct_MSD(compute_window(20/100), false);
% parameters{end+1} = compose_struct_MSD(compute_window(40/100), false);
% parameters{end+1} = compose_struct_PCA(compute_window(20/100), compute_window(20/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(40/100), compute_window(40/100), 1);

% For Window analysis
% parameters{end+1} = compose_struct_PCA(compute_window(20/100), compute_window(10/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(20/100), compute_window(20/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(20/100), compute_window(40/100), 1);
% parameters{end+1} = compose_struct_PCA(compute_window(20/100), compute_window(80/100), 1);


for ii = 1:length(parameters)

    parameter = parameters{ii};

    switch (parameter.method)

        case 'MSD'
            [d_MSD, t_MSD] = analyze_with_MSD(data.frequencies_mat, parameter.b, parameter.F0_contains_damage);

            results{ii} = struct( ...
                'method', parameter.method, ...
                'd_MSD', d_MSD, ...
                't_MSD', t_MSD);

        case 'PCA'
            [d_PCA, t_PCA_lo, t_PCA, t_PCA_up] = analyze_with_PCA(data.frequencies_mat, parameter.b, parameter.n, parameter.p);

            results{ii} = struct( ...
                'method', parameter.method, ...
                'd_PCA', d_PCA, ...
                't_PCA_lo', t_PCA_lo, ...
                't_PCA', t_PCA, ...
                't_PCA_up', t_PCA_up);

        otherwise
            error('The selected approach has not been developed yet');

    end

end

clear ii parameter
clear d_MSD t_MSD
clear d_PCA t_PCA_lo t_PCA t_PCA_up


%% Plots

reset(0);
set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');
% set(0, 'defaultfigureposition', [10 10 550 400])

plot_struct.flags = true * [1 1 1];
plot_struct.export_flag = true;
plot_struct.export_path = 'latex/img/MATLAB';
plot_struct.data = cell(0);

if (plot_struct.flags(1))
    run("figures\fig_01_preliminary_analysis.m");
end

if (plot_struct.flags(2) && numel(results) ~= 0)
    run("figures\fig_02_results_comparison.m");
end

if (plot_struct.flags(3) == true)
    run("figures\fig_03_principal_components.m");
end

pause(1);
if (plot_struct.export_flag)
    for plot_idx = 1:numel(plot_struct.data)
    
        current_plot = plot_struct.data{plot_idx};
        tile = current_plot{1};
        local_path = current_plot{2};

        filename = [plot_struct.export_path local_path '.png'];
        exportgraphics(tile, filename, 'Resolution', 300);
    
    end
end



%% Functions

function struct_MSD = compose_struct_MSD(b, F0_contains_damage)

struct_MSD = struct( ...
    'method', "MSD", ...
    'b', b, ...
    'F0_contains_damage', F0_contains_damage);

end


function struct_MSD = compose_struct_PCA(b, n, p)

struct_MSD = struct( ...
    'method', "PCA", ...
    'b', b, ...
    'n', n, ...
    'p', p);

end


