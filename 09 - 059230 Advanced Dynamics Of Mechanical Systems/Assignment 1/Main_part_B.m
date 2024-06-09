clc
clear variables
close all

%% Data input

data = load('data/Data.mat');

N_in_out = size(data.frf, 2);
f_0 = mean(diff(data.freq));


%% Common functions and constant definition

omega = @(frequency) 2 * pi * frequency;


%% Search of natural frequency

% Raw visual estimation of firsts resonance frequencies of the system
f_nat_vet = [667 1625];


%% Modal parameter identification

f_resolution = 90;
f_range_vet = zeros(length(f_nat_vet), f_resolution);

omega_num_nat = zeros(1, length(f_nat_vet));
xi_num = zeros(1, length(f_nat_vet));
A_num  = zeros(N_in_out, length(f_nat_vet));
RL_num = zeros(N_in_out, length(f_nat_vet));
RH_num = zeros(N_in_out, length(f_nat_vet));

G_peaks = zeros(N_in_out, f_resolution);
G_num = zeros(N_in_out, length(f_nat_vet), f_resolution);

for ii = 1:length(f_nat_vet)

    f_windows = 30;
    idxs = find(...
        data.freq >= f_nat_vet(ii) - f_windows/2 & ...
        data.freq <= f_nat_vet(ii) + f_windows/2);
    
    f_range_vet(ii, :) = data.freq(idxs);
    G_peaks = data.frf(idxs, :).';

    [...
        omega_num_nat(ii), ...
        xi_num(ii), ...
        A_num(:, ii), ...
        RL_num(:, ii), ...
        RH_num(:, ii) ...
        ] = identify_modal_parameters(f_range_vet(ii, :), G_peaks);

    for xj_idx = 1:N_in_out

        G_num(xj_idx, ii, :) = ...
            A_num(xj_idx, ii) ./ (-omega(f_range_vet(ii, :)).^2 + 2i*omega_num_nat(ii)*xi_num(ii)*omega(f_range_vet(ii, :)) + omega_num_nat(ii)^2) + ...
            RL_num(xj_idx, ii) ./ omega(f_range_vet(ii, :)) .^ 2 + ...
            RH_num(xj_idx, ii);

    end

end



%% Results

disp('Numerical frequencies: '); omega_num_nat / (2*pi)
disp('Numerical dampings: '); xi_num * 100


%% Plots

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');
% set(0, 'defaultaxesfontsize', 15);
% set(0, 'DefaultLineLineWidth', 2);

plot_struct.flags = true * [1 1 1];
% plot_struct.export_path = 'latex/img/MATLAB/Part_B';
plot_struct.data = cell(0);

if (plot_struct.flags(1))
    run("figures\part_B\fig_01_preliminary_analysis.m");
end

if (plot_struct.flags(2))
    run("figures\part_B\fig_02_FRF_comparison.m");
end

if (plot_struct.flags(3))
    run("figures\part_B\fig_03_mode_shapes.m");
end

pause(1);
if (isfield(plot_struct, 'export_path'))
    for plot_idx = 1:numel(plot_struct.data)
    
        current_plot = plot_struct.data{plot_idx};
        tile = current_plot{1};
        local_path = current_plot{2};

        filename = [plot_struct.export_path local_path '.png'];
        exportgraphics(tile, filename, 'Resolution', 300);
    
    end
end