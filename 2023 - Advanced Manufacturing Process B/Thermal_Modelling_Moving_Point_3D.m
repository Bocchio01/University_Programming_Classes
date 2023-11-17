clc
clear variables
close all

%% Problem statement

graph = true;
calibrate_efficiency = true;

eta_guess = 0.49 + (-0.05:0.01:0.05);
resolution = 10;
scale_factor = 1e-6;

% Material properties: Paint coating
material = struct( ...
    'density', 1450, ...
    'specific_heat_capacity', 2500, ...
    'thermal_conductivity', 0.3, ...
    'vaporization_temperature', 300, ...
    'absorption_coefficient', 0.3);

% Material properties: Ductile iron @700°C
% material = struct( ...
%     'density', 7100, ...
%     'specific_heat_capacity', 1000, ...
%     'thermal_conductivity', 32, ...
%     'vaporization_temperature', 300, ...
%     'absorption_coefficient', 0.3);
material.thermal_diffusivity = material.thermal_conductivity / (material.density * material.specific_heat_capacity);

% Process parameters
process = struct( ...
    'power', 1600 * 1e-3, ...
    'wavelength', 445, ...
    'focus_point', 0, ...
    'n_passes', 1, ...
    'feed_rate', 800 * 1e-3 / 60, ...
    'efficiency', 0.3, ...
    'geometrical_correction', 10, ...
    'temperature_ambient', 25);

% Simulation domain
domain = struct( ...
    'eps', scale_factor * (-1000:resolution:50), ...
    'y', scale_factor * (-200:resolution:200), ...
    'z', scale_factor * (0:resolution:20));

% Experimental data
track_widths = table2struct(readtable('Track-Width.xlsx'));
VAP_experimental = mean([track_widths.('Blue')]) * scale_factor;

clear track_widths


%% Model defintion
% Here we suppose unitary efficiency and T_environment = 0°C

r = @(eps, y, z) norm([eps, y, process.geometrical_correction * z]);
T = @(eps, y, z) process.power * material.absorption_coefficient / (2*pi*material.thermal_conductivity*r(eps, y, z)) * ...
    exp(-process.feed_rate / (2*material.thermal_diffusivity) * (eps + r(eps, y, z)));


%% Model solution (not calibrated)

T_field = zeros( ...
    length(domain.eps), ...
    length(domain.y), ...
    length(domain.z));

tic
for eps_idx = 1:length(domain.eps)
    for y_idx = 1:length(domain.y)
        for z_idx = 1:length(domain.z)
            T_field(eps_idx, y_idx, z_idx) = T(domain.eps(eps_idx), domain.y(y_idx), domain.z(z_idx));
        end
    end
end
toc


%% Model calibration

if (isnan(process.efficiency) || calibrate_efficiency)

    VAP_error = zeros(length(eta_guess), 1);
    VAP_simulated = zeros(length(eta_guess), 1);

    for i = 1:length(eta_guess)

        VAP_field = computeVAP(T_field * eta_guess(i) + process.temperature_ambient, ...
            material.vaporization_temperature, ...
            domain);
        VAP_simulated(i) = max(VAP_field(:, 1));
        VAP_error(i) = abs(VAP_experimental - VAP_simulated(i)) / VAP_experimental;

    end

    process.efficiency = eta_guess(find_nearest_index(VAP_error, 0));

end


%% Model solution (calibrated)
% We suppose that material can reach up to vaporization temperature

T_field = min(material.vaporization_temperature, T_field * process.efficiency + process.temperature_ambient);
VAP_field = computeVAP(T_field, ...
    material.vaporization_temperature, ...
    domain);

[VAP_width, VAP_width_x_idx] = max(VAP_field(:, 1));
VAP_depth = domain.z(find(VAP_field(VAP_width_x_idx, :) > 0, 1, 'last'));


%% Output variables

process
output = struct( ...
    'VAP_width', VAP_width, ...
    'VAP_depth', VAP_depth)


%% Solution visualization
% - Temperature distribution
% - Model calibration
% - VAP analysis

if graph

    % Temperature distribution, T(space, depth)
    figure_depth_comparison = figure('Name', 'Temperature distribution', 'NumberTitle', 'off');
    for z = linspace(min(domain.z), max(domain.z), 3)
        nexttile
        hold on
        grid on
        surf(domain.eps' / scale_factor, domain.y' / scale_factor, T_field(:, :, find_nearest_index(domain.z, z))')
        cbar = colorbar;
        cbar.Label.String = 'Temperature [°C]';
        axis tight
        view(3);
        title({['Temperature distribution, depth=', num2str(z / scale_factor), ' [\mum]']})
        xlabel('X [\mum]');
        ylabel('Y [\mum]');
        zlabel('T [°C]');
    end

    for z = linspace(min(domain.z), max(domain.z), 3)
        nexttile
        hold on
        grid on
        imagesc(squeeze(T_field(:, :, find_nearest_index(domain.z, z))'));
        cbar = colorbar;
        cbar.Label.String = 'Temperature [°C]';
        axis equal tight
        title({['Temperature distribution, depth=', num2str(z / scale_factor), ' [\mum]']})
        xlabel('X [\mum]');
        ylabel('Y [\mum]');
    end

    for z = linspace(min(domain.z), max(domain.z), 3)
        nexttile
        hold on
        grid on
        contour(domain.eps' / scale_factor, domain.y' / scale_factor, T_field(:, :, find_nearest_index(domain.z, z))', ...
            'ShowText', 'on');
        axis equal
        title({['Iso-temperature lines, depth=', num2str(z / scale_factor), ' [\mum]']})
        xlabel('X [\mum]');
        ylabel('Y [\mum]');
    end

    % Model calibration, eta
    figure_calibration = figure('Name', 'Model calibration', 'NumberTitle', 'off');
    if (exist('VAP_error', 'var') && exist('VAP_simulated', 'var') && exist('eta_guess', 'var'))
        nexttile
        hold on
        grid on

        yyaxis left;
        plot(eta_guess, VAP_error, 'b', ...
            'LineWidth', 2);
        ylabel('Error [%]');

        yyaxis right;
        plot(eta_guess, VAP_simulated, 'r', ...
            'LineWidth', 2);
        plot(eta_guess, VAP_experimental * eta_guess./eta_guess, '--k', ...
            'LineWidth', 1);
        ylabel('VAP [\mum]');

        title('VAP error for different \eta')
        xlabel('\eta []');
        legend('Error [%]', 'VAP simulated [\mum]', 'VAP experimental [\mum]')
    end

    % VAP analysis, melted region + VAP(x, depth)
    deltaT = 5;
    figure_melted_region = figure('Name', 'VAP analysis', 'NumberTitle', 'off');
    nexttile
    hold on
    grid on
    [X, Y, Z] = meshgrid(domain.y' / scale_factor, ...
        domain.eps' / scale_factor, ...
        -domain.z' / scale_factor);
    fv = isosurface(X, Y, Z, ...
        T_field, ...
        material.vaporization_temperature - deltaT);
    p = patch(fv);
    set(p, ...
        'FaceColor', 'red', ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.3);
    view(3);
    axis equal
    camlight;
    lighting gouraud;
    title({['Melted region @T=T_{vaporization} - \DeltaT=', ...
        num2str(material.vaporization_temperature), '-', num2str(deltaT), '=', ...
        num2str(material.vaporization_temperature - deltaT), ' [°C]']})
    xlabel('X [\mum]');
    ylabel('Y [\mum]');
    zlabel('Z [\mum]');

    nexttile
    hold on
    grid on
    set(gca, 'YDir', 'reverse');
    imagesc(squeeze(VAP_field' / scale_factor));
    % colormap('hot');
    cbar = colorbar;
    cbar.Label.String = 'VAP track width [\mum]';
    axis equal tight
    title('VAP analysis')
    xlabel('X [\mum]');
    ylabel('Z [\mum]');

    hold off
    nexttile
    hold on
    grid on
    set(gca, 'YDir', 'reverse');
    imagesc(squeeze(reshape(T_field(VAP_width_x_idx, :, :), size(T_field, [2, 3]))'));
    % colormap('parula');
    cbar = colorbar;
    cbar.Label.String = 'Temperature [°C]';
    axis equal tight
    title({['Max VAP section @x=', num2str(VAP_width / scale_factor), ' [\mum]']})
    xlabel('X [\mum]');
    ylabel('Z [\mum]');
end



%% Functions

function VAP = computeVAP(T_field, temperature, domain)

VAP = zeros( ...
    length(domain.eps), ...
    length(domain.z));

[x_idx, y_idx, z_idx] = ind2sub(size(T_field), find(T_field >= temperature));

for i = 1:length(x_idx)
    VAP(x_idx(i), z_idx(i)) = max(VAP(x_idx(i), z_idx(i)), 2 * abs(domain.y(y_idx(i))));
end

end

function idx = find_nearest_index(vector, target)

[~, idx] = min(abs(vector - target));

end

