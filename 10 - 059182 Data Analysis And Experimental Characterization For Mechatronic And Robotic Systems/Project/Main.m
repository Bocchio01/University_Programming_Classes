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

data.plot.flags = true * [1 1 1];
% data.plot.export_path = 'latex/img/MATLAB';

assert(...
    length(data.temperature_vet) == size(data.frequencies_mat, 1), ...
    'Temperature vector and Frequencies matrix does not agree in size');


%% Compute common anonymus functions and vector

compute_window = @(percentage) round(percentage * size(data.frequencies_mat, 1));

time_vet = 10/60 * 1/24 * (0:length(data.temperature_vet) - 1)';


%% Algorithm parameters for each set of analysis run

parameters = cell(0);
results = cell(0);

% parameters{end+1} = compose_struct_MSD(compute_window(20/100), false);
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

% Preliminary analysis
if (data.plot.flags(1) == true)

    figure('Name', 'Preliminary analysis');
    tiles = tiledlayout(2, 1);

    % Temperature over time
    nexttile
    hold on
    grid on

    plot(time_vet, data.temperature_vet, '-b');

    title('Registered temperature over time')
    xlabel('Time [h]')
    ylabel('Temperature [°C]')
    legend('T(t) [°C]')

    % Structure eigenfrequencies over time
    nexttile
    hold on
    grid on

    legend_entries = cell(1, size(data.frequencies_mat, 2));

    for ii = 1:size(data.frequencies_mat, 2)

        plot(time_vet, data.frequencies_mat(:, ii), '-');
        legend_entries{ii} = ['f_' num2str(ii) ' [Hz]'];

    end

    title('Registered eigenfrequency over time')
    xlabel('Time [Day]')
    ylabel('Natural frequency_i []')
    legend(legend_entries)

    export_plot_tile(tiles, 'Preliminary_analysis', data.plot);

    clear ii tiles legend_entries

end


% Results comparison
if (data.plot.flags(2) == true && numel(results) ~= 0)

    tabgroup = uitabgroup(figure('Name', 'Results comparison'), 'Position', [0 0 1 1]);
    
    for ii = 1:length(results)

        tab = uitab(tabgroup);
        axes('parent', tab)

        parameter = parameters{ii};
        result = results{ii};

        nexttile
        hold on
        grid on
        colororder({'k','b'})

        yyaxis right
        plot(time_vet, data.temperature_vet - mean(data.temperature_vet), '-b');

        yyaxis left
        switch (result.method)

            case 'MSD'
                b = parameter.b;
                
                d_MSD = result.d_MSD;
                t_MSD = result.t_MSD;

                plot(time_vet(1:b), d_MSD(1:b) / t_MSD, 'xk')
                plot(time_vet(b+1:end), d_MSD(b+1:end) / t_MSD, '^r')
                yline(t_MSD / t_MSD, '--k', 'Label', 't_{threshold}', 'LineWidth', 2)
                xline(time_vet(b), '-.k', 'Label', 'baseline')

                legend('(MSD) Baseline data', '(MSD) Observation data')

                title_string = sprintf('MSD @ [b, contains-damage-flag] = [%d, %d]', b, parameter.F0_contains_damage);

            case 'PCA'
                b = parameter.b;
                n = parameter.n;
                p = parameter.p;
                
                d_PCA = result.d_PCA;
                t_PCA_lo = result.t_PCA_lo;
                t_PCA = result.t_PCA;
                t_PCA_up = result.t_PCA_up;

                plot(time_vet(b+1:end), d_PCA(b+1:end) / t_PCA, '^r')
                yline(t_PCA_up / t_PCA, '--k', 'Label', 't_{up}', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
                yline(t_PCA / t_PCA, '-.k', 'Label', 't_{threshold}', 'LabelHorizontalAlignment', 'left');
                yline(t_PCA_lo / t_PCA, '--k', 'Label', 't_{lo}', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
                xline(time_vet(b), '-.k', 'Label', 'baseline')

                legend('(PCA) Observation data')

                title_string = sprintf('PCA @ [b, n, p] = [%d, %d, %d]', b, n, p);

        end
   
        xlim('tight')

        tab.Title = title_string;
        title(title_string)
        yyaxis left
        ylabel('Normalized index []')
    
        yyaxis right
        ylabel('Temperature oscillation [°C]')
    
        xlabel('Time [Day]')

        export_plot_tile(tab, sprintf('Run_%02d', ii), data.plot);

    end

    clear ii tabgroup tab title_string
    clear parameter b n p
    clear result d_MSD t_MSD d_PCA t_PCA_lo t_PCA t_PCA_up

end


% Principal components visualization
if (data.plot.flags(3) == true)

    PC_parameters = cell(0);
    PC_parameters{end+1} = struct('b', compute_window(20/100), 'start_idx', compute_window(0/100));
    PC_parameters{end+1} = struct('b', compute_window(40/100), 'start_idx', compute_window(50/100));

    tabgroup = uitabgroup(figure('Name', 'Principal components analysis'), 'Position', [0 0 1 1]);
    
    for ii = 1:length(PC_parameters)

        PC_parameter = PC_parameters{ii};
        b = PC_parameter.b;
        start_idx = PC_parameter.start_idx;

        PCs = apply_PCA(data.frequencies_mat(start_idx + (1:b), :), 0);
    
        tab = uitab(tabgroup);
        axes('parent', tab);
        tiles = tiledlayout(size(PCs, 2), 1);
    
        for PC_idx = 1:size(PCs, 2)

            nexttile(tiles)
            hold on
            grid on

            plot(time_vet(start_idx + (1:b)), PCs(:, PC_idx))
                
        end

        title_string = sprintf('PCs @ [b, start_{idx}] = [%d, %d]', b, start_idx);

        tab.Title = title_string;
        tiles.Title.String = title_string;

        tiles.XLabel.String = 'Time [Day]';
        tiles.YLabel.String = 'Scores []';

        export_plot_tile(tiles, sprintf('PCs_%02d', ii), data.plot);

    end

    clear ii PC_idx tabgroup tab tiles title_string
    clear PCs PC_parameter b start_idx

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


function export_plot_tile(tile, title, plot_struct)

if (isfield(plot_struct, 'export_path'))

    pause(1);
    filename = [plot_struct.export_path '\' title '.png'];
    exportgraphics(tile, filename, 'Resolution', 300);

end

end


