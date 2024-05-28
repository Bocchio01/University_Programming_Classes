clc
clear variables
close all

%% Load data

data = load('02 - Order Tracking\Data.mat');

data.proxi_async = data.proxi_async / data.sens;

N_sampling = length(data.proxi_async);
dt = 1 / data.fsamp;
t_vet = 0:dt:(N_sampling-1)*dt;


%% Angular speed reconstruction

[peaks_magnitude, peaks_idx] = findpeaks(data.ref, 'MinPeakHeight', 0.1);

angular_speed = 2 * pi ./ diff(t_vet(peaks_idx));


%% Averaging technique to reconstruct the displacement profile (order tracking)

revolutions = struct( ...
    'N', length(peaks_idx) - 1, ...
    't_interpolation_vet', 2*pi / 360 * (0:1:360-1));

revolutions.f_0 = zeros(revolutions.N, 1);
revolutions.signal = zeros(revolutions.N, length(revolutions.t_interpolation_vet));
revolutions.t_original = cell(revolutions.N, 1);
revolutions.signal_filtered = cell(revolutions.N, 1);

for revolution_idx = 1:revolutions.N

    signal_original = data.proxi_async(peaks_idx(revolution_idx):peaks_idx(revolution_idx + 1) - 1);
    N_samples = length(signal_original);

    revolutions.f_0(revolution_idx) = 1 / (N_samples / data.fsamp); % f_0 = 1 / T_0 

    % Here I assume constant speed during the full revolution
    revolutions.t_original{revolution_idx} = 2*pi / N_samples * (0:1:N_samples-1);

    % Low-pass filtering (up to the 20th * f_0)
    [b,a] = butter(4, 2.56 * 20 * revolutions.f_0(revolution_idx) / data.fsamp, 'low');

    % Filtering the signal (?)
    if (true)
        if (true && revolution_idx == 1)
            [revolutions.signal_filtered{revolution_idx}, final_state] = filter(b, a, signal_original);
        else
            [revolutions.signal_filtered{revolution_idx}, final_state] = filter(b, a, signal_original, initial_state);
        end

        initial_state(:, 1) = final_state;
    else
        revolutions.signal_filtered{revolution_idx} = signal_original;
    end

    revolutions.signal(revolution_idx, :) = spline(revolutions.t_original{revolution_idx}, revolutions.signal_filtered{revolution_idx}, revolutions.t_interpolation_vet);

end

signal_averaged = mean(revolutions.signal);


%% Plot

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

% Preliminary analysis
figure_preliminary_analysis = figure('Name', 'Preliminary analysis');
tiledlayout(2, 1)

nexttile
hold on
grid on

yyaxis left;
plot(t_vet, data.proxi_async, 'b', 'LineWidth', 1)
ylabel('Displacement [mm]')

yyaxis right;
plot(t_vet, data.ref, 'r', 'LineWidth', 2)
plot(t_vet(peaks_idx), peaks_magnitude, 'or', 'LineWidth', 2)
ylabel('Voltage [V]')

title('Displacement and Trigger signal')
xlabel('Time [s]')
legend('Displacement signal', 'Trigger signal', 'Trigger peaks')

nexttile
hold on
grid on

plot(t_vet(peaks_idx(2:end)), angular_speed, 'LineWidth', 1)

title('Angular speed during the test')
xlabel('Time [s]')
ylabel('Angular speed [rad/s]')


% Displacement vs. Angular position
figure_displacement_vs_position = figure('Name', 'Displacement vs Angular position');
tiledlayout(1, 2)

nexttile
hold on
grid on

for revolution_idx = 1:revolutions.N
    plot(revolutions.t_original{revolution_idx}, revolutions.signal_filtered{revolution_idx})
end

title('Filtered signals (one for each revolution)');
xlabel('Angular position [rad]')
ylabel('Displacement [mm]')

nexttile
hold on
grid on

plot(revolutions.t_interpolation_vet, signal_averaged, 'LineWidth', 2)

title('Averaged signal');
xlabel('Angular position [rad]')
ylabel('Displacement [mm]')
