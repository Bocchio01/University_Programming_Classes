clc
clear variables
close all

%% Load data

data = load('03 - Autocorrelation\Data.mat');

data.Data = data.Data / data.sens;

N_sampling = length(data.Data);
dt = 1 / data.fsamp;
t_vet = 0:dt:(N_sampling-1)*dt;

wheel_radius = 16*0.0254 / 2;


%% Auto-correlation and tau vector

Raa = zeros(N_sampling, 1);
tau = zeros(N_sampling, 1);

for tau_idx = 0:N_sampling - 1    

    a_t = data.Data(1:N_sampling - tau_idx);
    a_t_tau = data.Data(1 + tau_idx:N_sampling);
    
    Raa(tau_idx + 1) = 1 / (N_sampling - tau_idx) * sum(a_t .* a_t_tau);
    tau(tau_idx + 1) = tau_idx * dt;

end

Raa = [+flipud(Raa); Raa(2:end)];
tau = [-flipud(tau); tau(2:end)];

clear tau_idx a_t a_t_tau


%% Speed estimation based on auto-correlation peaks

[peaks_magnitude, peaks_idx] = findpeaks(Raa(N_sampling-1:round(2/3 * end)), 'MinPeakHeight', 2.5*10000);

t_period_vet = diff(peaks_idx) * dt;
omega_vet = 2*pi ./ t_period_vet;
velocity_vet = omega_vet * wheel_radius; % [m/s]


%% Biased vs. Unbiased auto-correlation function

Raa_biased = xcorr(data.Data, 'biased');
Raa_unbiased = xcorr(data.Data, 'unbiased');


%% Time averaging over each period

mean_period_idx = round(mean(diff(peaks_idx)));
N_periods = floor(N_sampling / mean_period_idx);
signal_periods = zeros(N_periods, mean_period_idx);

for period_idx = 1:N_periods
    signal_periods(period_idx, :) = data.Data((period_idx-1) * mean_period_idx + 1:1:period_idx * mean_period_idx);
end

signal_period_averaged = mean(signal_periods);


%% Plot

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

% Preliminary analysis
figure_preliminary_analysis = figure('Name', 'Preliminary analysis');
tiledlayout(3, 1)

nexttile
hold on
grid on

plot(t_vet, data.Data, 'b', 'LineWidth', 1)

title('Radial acceleration')
xlabel('Time [s]')
ylabel('Radial acceleration [m/s^2]')
legend('Acceleration signal')

nexttile
hold on
grid on

plot(tau, Raa, 'LineWidth', 1)
plot((peaks_idx-2) * dt, peaks_magnitude, 'or', 'LineWidth', 1)

title('Autocorrelation of the signal')
xlabel('\tau [s]')
ylabel('[m/s^2]^2')
legend('Autocorrelation function', 'Peaks')

nexttile
hold on
grid on

plot(tau, Raa_biased, 'LineWidth', 1)
plot(tau, Raa_unbiased, 'LineWidth', 1)

title('XCorr of the signal')
xlabel('\tau [s]')
ylabel('[m/s^2]^2')
legend('XCorr biased', 'XCorr un-biased')


% Time averaging
figure_time_averaging = figure('Name', 'Time averaging');
tiledlayout(2, 2)

start_idx = [1 7];
end_idx = [N_periods min(N_periods, 24)];

for set_idx = 1:length(start_idx)

    nexttile
    hold on
    grid on

    plot(t_vet(1:mean_period_idx), signal_periods(start_idx(set_idx):end_idx(set_idx), :));
    plot(t_vet(1:mean_period_idx), mean(signal_periods(start_idx(set_idx):end_idx(set_idx), :)), 'k', 'LineWidth', 2);

    title(['Time averaged (considering subset ' num2str(start_idx(set_idx)) ':' num2str(end_idx(set_idx))  ')']);
    xlabel('Time [s]')
    ylabel('Radial acceleration [m/s^2]')
    % legend('Averaged accelration signal')

end

nexttile([1, 2])
hold on
grid on

for set_idx = 1:length(start_idx)
    plot(t_vet(1:mean_period_idx), mean(signal_periods(start_idx(set_idx):end_idx(set_idx), :)), 'LineWidth', 2);
end

title('Time averaged (comparison of the previous averages)');
xlabel('Time [s]')
ylabel('Radial acceleration [m/s^2]')





