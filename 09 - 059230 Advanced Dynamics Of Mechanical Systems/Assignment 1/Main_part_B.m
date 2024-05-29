clc
clear variables
close all

%% Data input

data = load('data/Data.mat');

plots.flags = true * [1 1 1];
plots.export_path = 'latex/img/MATLAB/Part_B';

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



%% Plots

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');


% Data visualization (FRFs and coherence)
if (plots.flags(1) == true)

    figure('Name', 'Preliminary analysis');
    tiles = tiledlayout(3, 1);
    
    abs_FRF = nexttile;
    hold on
    grid on
    
    for ii = 1:size(data.frf, 2)
        semilogy(data.freq, abs(data.frf(:, ii)));
    end
    
    set(gca, 'YScale', 'log')
    
    title('FRF module')
    xlabel('f [Hz]')
    ylabel('|G(f)| [(m/s^2)/N]')
    
    angle_FRF = nexttile;
    hold on
    grid on
    
    for ii = 1:size(data.frf, 2)
        plot(data.freq, angle(data.frf(:, ii)));
    end
    
    set(gca, 'YTick', -pi:pi/2:pi) 
    set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})
    
    title('FRF phase')
    xlabel('f [Hz]')
    ylabel('\phi(G(f)) [rad]')
    
    coherence_FRF = nexttile;
    hold on
    grid on
    
    for ii = 1:size(data.frf, 2)
        plot(data.freq, data.cohe(:, ii));
    end
    
    title('Coherence functions input - output_i')
    xlabel('f [Hz]')
    ylabel('\gamma_{xyi}^2 []')
    
    linkaxes([abs_FRF angle_FRF coherence_FRF], 'x')

    export_plot_tile(tiles, 'Experimental_data', plots)

end


% Comparison between experimental and numerical FRF
if (plots.flags(2) == true)

    figure('Name', 'FRF - Experimental vs. Numerical');
    tiles = tiledlayout(2, 1);
    
    xj_idx = 1;
    
    abs_FRF = nexttile;
    hold on
    grid on
    
    semilogy(data.freq, abs(data.frf(:, xj_idx)))
    for ii = 1:length(f_nat_vet)
        semilogy(f_range_vet(ii, :), abs(squeeze(G_num(xj_idx, ii, :))), 'or')
    end
    
    set(gca, 'YScale', 'log')
    
    title(['FRF Module @[xj] = [' num2str(xj_idx) ']'])
    legend('G_{exp}(f)', 'G_{num}(f)')
    xlabel('f [Hz]')
    ylabel('|G(f)| [m/N]')
    
    angle_FRF = nexttile;
    hold on
    grid on
    
    plot(data.freq, angle(data.frf(:, xj_idx)))
    for ii = 1:length(f_nat_vet)
        plot(f_range_vet(ii, :), angle(squeeze(G_num(xj_idx, ii, :))), 'or')
    end
    
    set(gca, 'YTick', -pi:pi/2:pi) 
    set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})
    
    title(['FRF Phase @[xj] = [' num2str(xj_idx) ']'])
    legend('G_{exp}(f)', 'G_{num}(f)')
    xlabel('f [Hz]')
    ylabel('\phi(G(f)) [rad]')
    
    linkaxes([abs_FRF angle_FRF], 'x')

    export_plot_tile(tiles, sprintf('Comparison_FRF_%d', xj_idx), plots)

end

%% Mode shapes visualization
if (plots.flags(3) == true)

    figure('Name', 'Mode shapes - Experimental vs. Numerical');
    tiledlayout(ceil(length(f_nat_vet) / 2), floor(length(f_nat_vet) / 2) + 1);

    d_angle = 15;
    angle_vet = deg2rad(0:d_angle:180-d_angle);
    angle_resized_vet = linspace(min(angle_vet), max(angle_vet), 180);
    base_circle = 6;

    for ii = 1:length(f_nat_vet)
    
        nexttile;
        % hold on
        grid on
    
        mode_shape_points = A_num(:, ii) / max(abs(A_num(:, ii))) + base_circle;
        mode_shape_spline = spline(angle_vet, mode_shape_points, angle_resized_vet);
    
        polarplot(deg2rad(0:360-1), base_circle * ones(1, 360), '--k');
        hold on
        
        polarplot(angle_resized_vet, mode_shape_spline, '-r', 'LineWidth', 2);
        polarplot(deg2rad(360) - angle_resized_vet, mode_shape_spline, '-b', 'LineWidth', 2);
        polarplot(angle_vet, mode_shape_points, 'or');
    
        set(gca, 'ThetaZeroLocation', 'bottom')
        rticks([]);
    
        title(['Mode Shape ' num2str(ii)])
        legend('Un-deformed', 'Identified', 'Symmetrical')

        export_plot_tile(gca, sprintf('ModeShape_%02d', ii), plots)
    
    end

end