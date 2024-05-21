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

f_vet = linspace(0, 200, 1000);
omega_vet = omega(f_vet);
gamma_vet = gamma(omega_vet);

x_vet = linspace(0, data.L, 120);


%% Search of natural frequency as zeros of det(H(f))

H_mats = zeros(size(H(0, 0), 1), size(H(0, 0), 2), length(f_vet));
H_det_vet = zeros(length(f_vet));
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

    [...
        omega_num_nat(ii), ...
        xi_num(ii), ...
        A_num(:, ii), ...
        RL_num(:, ii), ...
        RH_num(:, ii) ...
        ] = identify_modal_parameters(f_range_vet(ii, :), G_exp_peaks);

    for idx = 1:length(xk_input) * length(xj_output)

        G_num(idx, ii, :) = ...
            A_num(idx, ii) ./ (-omega(f_range_vet(ii, :)).^2 + 2i*omega_num_nat(ii)*xi_num(ii)*omega(f_range_vet(ii, :)) + omega_num_nat(ii)^2) + ...
            RL_num(idx, ii) ./ omega(f_range_vet(ii, :)) .^ 2 + ...
            RH_num(idx, ii);

    end

end



%% Plots

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

figure_frequencies_mode_shapes = figure('Name', 'Frequencies and mode shapes');
tiledlayout(3, 4);

nexttile([1 4]);
hold on
grid on

semilogy(f_vet, H_det_vet, '-b');
semilogy(f_nat_vet, H_det_vet(find(ismember(f_vet, f_nat_vet))), 'or');

set(gca, 'YScale', 'log')

title('Natural frequencies search')
xlabel('f [Hz]')
ylabel('|H(f)|')

legend('Module of H(f)', 'Natural frequecies')

nexttile(7, [2 2])
hold on
grid on

plot(x_vet, mode_shape(:, :));

title('Modes Shape')
xlabel('Length [m]')
ylabel('Normalized displachment [m]')

for ii = 1:length(f_nat_vet)

    nexttile
    hold on
    grid on

    plot(x_vet, mode_shape(:, ii));

    title(['Mode Shape ' num2str(ii)])
    legend(['f' num2str(ii) ' = ' num2str(f_nat_vet(ii)) ' [Hz]'])

    xlabel('Length [m]')
    ylabel('Normalized displachment [m]')

end


figure_frequency_response_functions = figure('Name', 'Frequency Response Functions (FRFs)');
tiledlayout(2, 1);

abs_FRF = nexttile;
hold on
grid on

for idx = 1:length(xk_input) * length(xj_output)
    semilogy(f_vet, abs(G_exp(idx, :)))
end

set(gca, 'YScale', 'log')

title('|G_{exp}(f)| for every couple of input and output')
xlabel('f [Hz]')
ylabel('|G(f)| [m/N]')

angle_FRF = nexttile;
hold on
grid on

for idx = 1:length(xk_input) * length(xj_output)
    plot(f_vet, angle(G_exp(idx, :)))
end

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('\phi(G_{exp}(f)) for every couple of input and output')
xlabel('f [Hz]')
ylabel('\phi(G(f)) [rad]')

linkaxes([abs_FRF angle_FRF], 'x')


% Comparison between experimental and numerical results
figure_exp_vs_num = figure('Name', 'Experimental vs. Numerical (FRF and mode shapes)');
tiledlayout(2, 4)

xj_idx = 1;
xk_idx = 6;
idx = sub2ind([length(xk_input) length(xj_output)], xj_idx, xk_idx);

abs_FRF = nexttile(1, [1, 2]);
hold on
grid on

semilogy(f_vet, abs(G_exp(idx, :)))
for ii = 1:length(f_nat_vet)
    semilogy(f_range_vet(ii, :), abs(squeeze(G_num(idx, ii, :))), 'or')
end

set(gca, 'YScale', 'log')

title(['FRF Module @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
legend('G_{exp}(f)', 'G_{num}(f)')
xlabel('f [Hz]')
ylabel('|G(f)| [m/N]')

angle_FRF = nexttile(5, [1, 2]);
hold on
grid on

plot(f_vet, angle(G_exp(idx, :)))
for ii = 1:length(f_nat_vet)
    plot(f_range_vet(ii, :), angle(squeeze(G_num(idx, ii, :))), 'or')
end

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title(['FRF Phase @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
legend('G_{exp}(f)', 'G_{num}(f)')
xlabel('f [Hz]')
ylabel('\phi(G(f)) [rad]')

linkaxes([abs_FRF angle_FRF], 'x')

for ii = 1:length(f_nat_vet)

    nexttile
    hold on
    grid on
    
    plot(x_vet, mode_shape(:, ii), 'LineWidth', 1)
    plot(xj_output, A_num(1:6, ii) / max(abs(A_num(1:6, ii))), 'or')

    title(['Mode Shape ' num2str(ii)])
    legend('Model', 'Identified')

    xlabel('Length [m]')
    ylabel('Normalized displachment [m]')

end