clc
clear variables
close all

%% Data input

data = struct( ...
    'L', 1200e-3, ...
    'h', 8e-3, ...
    'b', 40e-3, ...
    'rho', 2700, ...
    'E', 68e9);

data.J = 1/12 * data.b * data.h^3;
data.m = data.rho * data.b * data.h;


%% Common functions and constant definition

% H is relative to the problem at hand. The following formulation is valid
% only for a bending slender beam with null axial load.
H = @(gamma, L) [
    1 0 1 0;
    0 1 0 1;
    -cos(gamma * L) -sin(gamma * L) +cosh(gamma * L) +sinh(gamma * L);
    +sin(gamma * L) -cos(gamma * L) +sinh(gamma * L) +cosh(gamma * L)
    ];

omega = @(frequency) 2 * pi * frequency;
gamma = @(omega)     nthroot((data.m*omega.^2) / (data.E*data.J), 4);

f_vet = linspace(0, 200, 10*1200);
omega_vet = omega(f_vet);
gamma_vet = gamma(omega_vet);

x_vet = linspace(0, data.L, 120);


%% Search of natural frequency as zeros of det(H(f))

H_mats = zeros(size(H(0, 0), 1), size(H(0, 0), 2), length(f_vet));
H_det_vet = zeros(length(f_vet), 1);
f_nat_vet = NaN;

for ii = 1:length(gamma_vet)

    H_ii = H(gamma_vet(ii), data.L);

    H_mats(:, :, ii) = H_ii;
    H_det_vet(ii) = abs(det(H_ii));

    if (H_det_vet(ii) < H_det_vet(max(ii-1, 1)))
        f_nat_vet(end) = f_vet(ii);
    elseif (~isnan(f_nat_vet(end)))
        f_nat_vet(end+1) = NaN;
    end

end

f_nat_vet(end) = [];

clear ii H_ii


%% Computation of mode shapes phi_i(x)

C_mat = zeros(size(H(0, 0), 1), length(f_nat_vet));
mode_shape = zeros(length(x_vet), length(f_nat_vet));

% Iterations for each natural frequency
for ii = 1:length(f_nat_vet)

    gamma_ii = gamma(omega(f_nat_vet(ii)));
    H_ii = H(gamma_ii, data.L);
    C_mat(:, ii) = [1; -H_ii(2:end, 2:end) \ H_ii(2:end, 1)];

    mode = @(x) [cos(gamma_ii*x)' sin(gamma_ii*x)' cosh(gamma_ii*x)' sinh(gamma_ii*x)'] * C_mat(:, ii);
    mode_shape(:, ii) = mode(x_vet) / max(abs(mode(x_vet)));

end

clear ii C_mat H_ii gamma_ii phi mode

%% Frequency Response Function (FRF)

xk_input  = [0.1 0.3 0.5 0.7 0.9 1.2];
xj_output = [0.2 0.4 0.6 0.8 1.0 1.2];

G_exp = zeros(length(xj_output) * length(xk_input), length(f_vet));

for idx = 1:length(xk_input) * length(xj_output)

    [xj_idx, xk_idx] = ind2sub([length(xj_output), length(xk_input)], idx);

    G_exp(idx, :) = compute_G_exp( ...
        xk_input(xk_idx), ...
        xj_output(xj_idx), ...
        omega(f_vet), ...
        x_vet, ...
        data.m, ...
        f_nat_vet, ...
        mode_shape);
end

clear idx xk_idx xj_idx


%% Modal parameter identification

f_resolution = 400;
f_range_vet = zeros(length(f_nat_vet), f_resolution);

omega_num_nat = zeros(1, length(f_nat_vet));
xi_num = zeros(1, length(f_nat_vet));
A_num = zeros(length(xj_output) * length(xk_input), length(f_nat_vet));
RL_num = zeros(length(xj_output) * length(xk_input), length(f_nat_vet));
RH_num = zeros(length(xj_output) * length(xk_input), length(f_nat_vet));

G_num = zeros(length(xj_output) * length(xk_input), length(f_nat_vet), f_resolution);

for ii = 1:length(f_nat_vet)

    f_range_vet(ii, :) = linspace(max(0, f_nat_vet(ii)) - 1.5, f_nat_vet(ii) + 1.5, f_resolution);
    G_exp_peaks = zeros(length(xj_output) * length(xk_input), f_resolution);

    % Here we recompute with an higher frequecy resolution the FRFs coming
    % from the theoretical model.
    for idx = 1:length(xk_input) * length(xj_output)

        [xj_idx, xk_idx] = ind2sub([length(xj_output), length(xk_input)], idx);

        G_exp_peaks(idx, :) = compute_G_exp( ...
            xk_input(xk_idx), ...
            xj_output(xj_idx), ...
            omega(f_range_vet(ii, :)), ...
            x_vet, ...
            data.m, ...
            f_nat_vet, ...
            mode_shape);

    end

    % Here we call the parameters identification algorithm and store all
    % the identified parameters in proper data structures.
    [...
        omega_num_nat(ii), ...
        xi_num(ii), ...
        A_num(:, ii), ...
        RL_num(:, ii), ...
        RH_num(:, ii)] = identify_modal_parameters(f_range_vet(ii, :), G_exp_peaks);

    % Finally, based on the previously identified parameters, we assemble
    % our identified FRF around the resonance peaks (OMA results).
    for idx = 1:length(xk_input) * length(xj_output)

        G_num(idx, ii, :) = ...
            A_num(idx, ii) ./ (-omega(f_range_vet(ii, :)).^2 + 2i*omega_num_nat(ii)*xi_num(ii)*omega(f_range_vet(ii, :)) + omega_num_nat(ii)^2) + ...
            RL_num(idx, ii) ./ omega(f_range_vet(ii, :)) .^ 2 + ...
            RH_num(idx, ii);

    end

end



%% Results

disp('Experimental frequencies: '); omega(f_nat_vet)
disp('Numerical frequencies: '); omega_num_nat
disp('Relative errors: '); (omega(f_nat_vet) - omega_num_nat)./omega(f_nat_vet) * 100


%% Plots

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');
% set(0, 'defaultaxesfontsize', 15);
% set(0, 'DefaultLineLineWidth', 2);

plot_struct.flags = true * [1 1 1 1];
% plot_struct.export_path = 'latex/img/MATLAB/Part_A';
plot_struct.data = cell(0);

if (plot_struct.flags(1))
    run("figures\part_A\fig_01_preliminary_analysis.m");
end

if (plot_struct.flags(2))
    run("figures\part_A\fig_02_FRF_experimental.m");
end

if (plot_struct.flags(3))
    run("figures\part_A\fig_03_FRF_comparison.m");
end

if (plot_struct.flags(4))
    run("figures\part_A\fig_04_mode_shapes.m");
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
