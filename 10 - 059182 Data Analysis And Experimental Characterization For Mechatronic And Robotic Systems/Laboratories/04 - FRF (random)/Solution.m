clc
clear variables
close all

%% Load data

data = load('04 - FRF (random)\Staircase_empty.mat');
% data = load('04 - FRF (random)\Staircase_people.mat');

N_sampling = length(data.Data);
dt = 1 / data.fsamp;
t_vet = 0:dt:(N_sampling-1)*dt;


%% Computing the frequency response functions H(w) = Y(w) / X(w)
% data.Data(:, 1) contains the force applied as input (x(t))
% data.Data(:, 2) contains the acceleration registered as output (y1(t))
% data.Data(:, 3) contains the acceleration registered as output (y2(t))

[X_t, f_vet] = fft_normalized(hanning(N_sampling) .* data.Data(:, 1), data.fsamp);
[Y1_t, ~] = fft_normalized(hanning(N_sampling) .* data.Data(:, 2), data.fsamp);
[Y2_t, ~] = fft_normalized(hanning(N_sampling) .* data.Data(:, 3), data.fsamp);

H1_t = Y1_t ./ X_t;
H2_t = Y2_t ./ X_t;


%% Power and cross-spectra, H1 and H2 estimators

% Notice that changing the time window length, directly affect the
% frequency resolution that the power and cross spectra will have since
% f_0 = 1 / t_window
hann_time_length = [30 60]; % [s]

G = struct( ...
    'f_vet', [], ...
    'xx', [], ...
    'y1y1', [], ...
    'y2y2', [], ...
    'xy1', [], ...
    'xy2', [], ...
    'y1x', [], ...
    'y2x', []);

gamma = struct( ...
    'xy1', [], ...
    'xy2', []);

H1 = struct( ...
    'y1', [], ...
    'y2', []);

H2 = struct( ...
    'y1', [], ...
    'y2', []);


% Initialize the fields with empty cells
for hann_idx = 1:length(hann_time_length)
    G.xx{hann_idx} = [];
    G.y1y1{hann_idx} = [];
    G.y2y2{hann_idx} = [];
    G.xy1{hann_idx} = [];
    G.xy2{hann_idx} = [];
    G.y1x{hann_idx} = [];
    G.y2x{hann_idx} = [];

    gamma.xy1{hann_idx} = [];
    gamma.xy2{hann_idx} = [];

    H1.y1{hann_idx} = [];
    H1.y2{hann_idx} = [];

    H2.y1{hann_idx} = [];
    H2.y2{hann_idx} = [];
end

for hann_idx = 1:length(hann_time_length)

    % Overlapping helps in have higher number of subrecords, and so a
    % better average result for the spectra of the signals
    overlapping = 66/100;
    hann_window = hanning(round(hann_time_length(hann_idx) * data.fsamp));
    
    [G.xx{hann_idx}, G.f_vet{hann_idx}] = autocross([data.Data(:, 1) data.Data(:, 1)], data.fsamp, hann_window, overlapping);
    [G.y1y1{hann_idx}] = autocross([data.Data(:, 2) data.Data(:, 2)], data.fsamp, hann_window, overlapping);
    [G.y2y2{hann_idx}] = autocross([data.Data(:, 3) data.Data(:, 3)], data.fsamp, hann_window, overlapping);
    [G.xy1{hann_idx}] = autocross([data.Data(:, 1) data.Data(:, 2)], data.fsamp, hann_window, overlapping);
    [G.xy2{hann_idx}] = autocross([data.Data(:, 1) data.Data(:, 3)], data.fsamp, hann_window, overlapping);
    [G.y1x{hann_idx}] = autocross([data.Data(:, 2) data.Data(:, 1)], data.fsamp, hann_window, overlapping);
    [G.y2x{hann_idx}] = autocross([data.Data(:, 3) data.Data(:, 1)], data.fsamp, hann_window, overlapping);

    gamma.xy1{hann_idx} = abs(G.xy1{hann_idx}).^2 ./ (G.xx{hann_idx} .* G.y1y1{hann_idx});
    gamma.xy2{hann_idx} = abs(G.xy2{hann_idx}).^2 ./ (G.xx{hann_idx} .* G.y2y2{hann_idx});

    H1.y1{hann_idx} = G.xy1{hann_idx} ./ G.xx{hann_idx};
    H1.y2{hann_idx} = G.xy2{hann_idx} ./ G.xx{hann_idx};

    H2.y1{hann_idx} = G.y1y1{hann_idx} ./ G.y1x{hann_idx};
    H2.y2{hann_idx} = G.y1y1{hann_idx} ./ G.y2x{hann_idx};

end



%% Plot

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

% Preliminary analysis
figure_preliminary_analysis = figure('Name', 'Preliminary analysis');
tiledlayout(2, 1)

nexttile
hold on
grid on

plot(t_vet, data.Data(:, 1), 'b', 'LineWidth', 1)

title('Force')
xlabel('Time [s]')
ylabel('Force [N]')
legend('Force signal')

nexttile
hold on
grid on

plot(t_vet, data.Data(:, 2), 'LineWidth', 1)
plot(t_vet, data.Data(:, 3), 'LineWidth', 1)

title('Accelerations')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
legend('Accelerometer 17', 'Accelerometer 18')


% Frequency spectras and response
figure_spectras_FRF = figure('Name', 'Spectras and FRF');
tiledlayout(3, 1)

nexttile
hold on
grid on

plot(f_vet, abs(Y1_t));
plot(f_vet, abs(Y2_t));

title('Signals Spectra')
xlabel('Frequency [Hz]')
ylabel('Normalized FFT')
legend('FFT(Accelerometer 17)', 'FFT(Accelerometer 18)')

nexttile
hold on
grid on

% From a simple H FRF, it's impossible to understant which are the real
% resonance peaks because of noise. We will use instead H1 and H2
% estimators to solve this issue.
semilogy(f_vet, abs(H1_t));
semilogy(f_vet, abs(H2_t));

set(gca, 'YScale', 'log');

title('H = Y / X, Module')
xlabel('Frequency [Hz]')
ylabel('|H_i(f)| [m/(s^2*N)]')
legend('FRF(Accelerometer 17)', 'FRF(Accelerometer 18)')

nexttile
hold on
grid on

plot(f_vet, angle(H1_t));
plot(f_vet, angle(H2_t));

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('H = Y / X, Phase')
xlabel('Frequency [Hz]')
ylabel('\phi H_i(f) [rad]')
legend('FRF(Accelerometer 17)', 'FRF(Accelerometer 18)')


% Power (auto) and cross spectra of the signals
figure_auto_cross_spectra = figure('Name', 'Power (auto) and cross spectras');
tiledlayout(4, 1)

nexttile
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 3);

for hann_idx = 1:length(hann_time_length)
    
    % Power spectrum level are shifted because of the different power
    % distribution due to different resolution (f_0(30s) != f_0(60s))
    % To compare the two, we should use the Power Spectra Density instead
    semilogy(G.f_vet{hann_idx}, G.xx{hann_idx});

    % From here, I still can't state wheter the peaks are due to resonance
    % of the structure or only due to the input that is working at that
    % frquency. To solve this, we can use a white noise as input (excite
    % all the frequency with the same power over every frequency (i.e hammer
    % test)) or adopt coherence functions
    semilogy(G.f_vet{hann_idx}, G.y1y1{hann_idx});
    semilogy(G.f_vet{hann_idx}, G.y2y2{hann_idx});

    legend_entries{(hann_idx - 1) * 3 + 1} = sprintf('G.xx Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 3 + 2} = sprintf('G.y1y1 Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 3 + 3} = sprintf('G.y2y2 Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YScale', 'log');

title('Power Spectra of each signal')
xlabel('Frequency [Hz]')
ylabel({'G_{xx} [N^2]', 'G_{yy} [(m/s^2)^2]'});
legend(legend_entries)

% Module of the cross spectras
nexttile
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 2);

for hann_idx = 1:length(hann_time_length)

    % Differently from the auto spectra, cross spectra are represented by
    % complex numbers
    semilogy(G.f_vet{hann_idx}, abs(G.xy1{hann_idx}));
    semilogy(G.f_vet{hann_idx}, abs(G.xy2{hann_idx}));

    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('G.xy1 Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('G.xy2 Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YScale', 'log');

title('Cross Spectra Magnitude')
xlabel('Frequency [Hz]')
ylabel('|G_{xyi}| [N * (m/s^2)]');
legend(legend_entries)

% Phase of the cross spectras
nexttile
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 2);

for hann_idx = 1:length(hann_time_length)
    
    plot(G.f_vet{hann_idx}, angle(G.xy1{hann_idx}));
    plot(G.f_vet{hann_idx}, angle(G.xy2{hann_idx}));

    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('G.xy1 Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('G.xy2 Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('Cross Spectra Phase')
xlabel('Frequency [Hz]')
ylabel('\phi(G_{xyi}) [rad]');
legend(legend_entries)

% Coherence
nexttile
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 2);

for hann_idx = 1:length(hann_time_length)
    
    % Coherence tells us over which frequency range the output is really
    % due to the input and not because of other factors. If it's 1, then
    % the structure is vibrating in response to the shaker input.
    % Coherence may drop because of:
    % - Lack of linearity
    % - Presence of noise (over the input or the output)
    % - Presence of uncorrelated unmeasured input
    % - Leakage -> Enlarge the t_windows -> Use H2 as estimator over
    % resonance peaks
    plot(G.f_vet{hann_idx}, gamma.xy1{hann_idx});
    plot(G.f_vet{hann_idx}, gamma.xy2{hann_idx});

    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('Coherence xy1 Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('Coherence xy2 Window %d s', hann_time_length(hann_idx));

end

title('Coherence')
xlabel('Frequency [Hz]')
ylabel('\gamma^2_{xyi} []');
legend(legend_entries)


% H1 and H2 estimators
figure_H1_H2 = figure('Name', 'H1 and H2 estimators');
tiledlayout(2, 1)

nexttile
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 4);

for hann_idx = 1:length(hann_time_length)

    % Coherence tell us where we can trust the data (and the FRF functions
    % computed). If coherence is low, then the real FRF will be found in
    % the middle of both H1 and H2 function (one is underestimating and the
    % other is overestimating).
    % In general:
    % - H1 can be considered valid almost everywhere (antiresonance in
    % particular)
    % - H2 performs better at the resonance frequency
    % General solution, adopt H1, but adopt a higher frequency resolution,
    % which means in enlarging the t_window used to calculate the spectra
    % (longer test might be needed)
    semilogy(G.f_vet{hann_idx}, abs(H1.y1{hann_idx}));
    semilogy(G.f_vet{hann_idx}, abs(H2.y1{hann_idx}));

    legend_entries{(hann_idx - 1) * 4 + 1} = sprintf('H1(y1) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 4 + 2} = sprintf('H2(y1) Window %d s', hann_time_length(hann_idx));
    
    semilogy(G.f_vet{hann_idx}, abs(H1.y2{hann_idx}));
    semilogy(G.f_vet{hann_idx}, abs(H2.y2{hann_idx}));

    legend_entries{(hann_idx - 1) * 4 + 3} = sprintf('H1(y2) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 4 + 4} = sprintf('H2(y2) Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YScale', 'log');

title('H1 and H2 estimators Module')
ylabel('|H_i| [(m/s^2)/N)]')
xlabel('Frequency [Hz]')
legend(legend_entries)

nexttile
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 4);

for hann_idx = 1:length(hann_time_length)
    
    plot(G.f_vet{hann_idx}, angle(H1.y1{hann_idx}));
    plot(G.f_vet{hann_idx}, angle(H2.y1{hann_idx}));

    legend_entries{(hann_idx - 1) * 4 + 1} = sprintf('H1(y1) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 4 + 2} = sprintf('H2(y1) Window %d s', hann_time_length(hann_idx));
    
    plot(G.f_vet{hann_idx}, angle(H1.y2{hann_idx}));
    plot(G.f_vet{hann_idx}, angle(H2.y2{hann_idx}));

    legend_entries{(hann_idx - 1) * 4 + 3} = sprintf('H1(y2) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 4 + 4} = sprintf('H2(y2) Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('H1 and H2 estimators Phase')
ylabel('\phi(H_i) [rad]')
xlabel('Frequency [Hz]')
legend(legend_entries)


% Final results with H1, H2 and coherence splitting Accelerometers data
figure_result = figure('Name', 'Analysis result');
tiledlayout(2, 2)

y1_abs = nexttile(1);
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 3);

for hann_idx = 1:length(hann_time_length)

    yyaxis left
    semilogy(G.f_vet{hann_idx}, abs(H1.y1{hann_idx}));
    semilogy(G.f_vet{hann_idx}, abs(H2.y1{hann_idx}));
    
    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('H1(y1) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('H2(y1) Window %d s', hann_time_length(hann_idx));

end

for hann_idx = 1:length(hann_time_length)

    yyaxis right
    plot(G.f_vet{hann_idx}, gamma.xy1{hann_idx}, 'LineWidth', 1);
    legend_entries{(hann_idx - 1) + 5} = ['\gamma_{xy1} Window ' num2str(hann_time_length(hann_idx)) ' s'];
    
end

title('Accelerometers #17')
xlabel('Frequency [Hz]')

yyaxis left
set(gca, 'YScale', 'log')
ylabel('|H_i| [(m/s^2)/N)]')

yyaxis right
ylabel('Coherence level []')

legend(legend_entries)

y1_angle = nexttile(3);
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 2);

for hann_idx = 1:length(hann_time_length)

    yyaxis left
    semilogy(G.f_vet{hann_idx}, angle(H1.y1{hann_idx}));
    semilogy(G.f_vet{hann_idx}, angle(H2.y1{hann_idx}));
    
    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('H1(y1) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('H2(y1) Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('Accelerometers #17')
ylabel('\phi(H_i) [rad]')
xlabel('Frequency [Hz]')
legend(legend_entries)


y2_abs = nexttile(2);
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 3);

for hann_idx = 1:length(hann_time_length)

    yyaxis left
    semilogy(G.f_vet{hann_idx}, abs(H1.y2{hann_idx}));
    semilogy(G.f_vet{hann_idx}, abs(H2.y2{hann_idx}));
    
    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('H1(y2) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('H2(y2) Window %d s', hann_time_length(hann_idx));

end

for hann_idx = 1:length(hann_time_length)

    yyaxis right
    plot(G.f_vet{hann_idx}, gamma.xy2{hann_idx}, 'LineWidth', 1);
    legend_entries{(hann_idx - 1) + 5} = ['\gamma_{xy2} Window ' num2str(hann_time_length(hann_idx)) ' s'];
    
end

title('Accelerometers #18')
xlabel('Frequency [Hz]')

yyaxis left
set(gca, 'YScale', 'log')
ylabel('|H_i| [(m/s^2)/N)]')

yyaxis right
ylabel('Coherence level []')

legend(legend_entries)

y2_angle = nexttile(4);
hold on
grid on

legend_entries = cell(1, length(hann_time_length) * 2);

for hann_idx = 1:length(hann_time_length)

    yyaxis left
    semilogy(G.f_vet{hann_idx}, angle(H1.y2{hann_idx}));
    semilogy(G.f_vet{hann_idx}, angle(H2.y2{hann_idx}));
    
    legend_entries{(hann_idx - 1) * 2 + 1} = sprintf('H1(y2) Window %d s', hann_time_length(hann_idx));
    legend_entries{(hann_idx - 1) * 2 + 2} = sprintf('H2(y2) Window %d s', hann_time_length(hann_idx));

end

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('Accelerometers #18')
ylabel('\phi(H_i) [rad]')
xlabel('Frequency [Hz]')
legend(legend_entries)


linkaxes([y1_abs y1_angle y2_abs y2_angle], 'x')










