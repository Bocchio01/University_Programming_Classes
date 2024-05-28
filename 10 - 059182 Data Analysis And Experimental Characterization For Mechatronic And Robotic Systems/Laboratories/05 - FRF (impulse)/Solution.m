% The use of hammer might introduce non-linearity in th response from the structure.
% Tukey windows helps in reducing the leakage because the starting and
% ending point of the input signal are zero (continuity -> fft no leakage
% beacause of perfect periodicity)
% Exponential windows alters the output signal (in particular its decay
% speed) and so also the computed damping ratio for example. If
% accelerometers are of good quality, then it's better to not use any
% windowing function on the output.

clc
clear variables
close all

%% Get number of files to be loaded

files_data = struct( ...
    'path', '05 - FRF (impulse)\Data', ...
    'dir_content', [], ...
    'N_files', 0);

files_data.dir_content = dir([files_data.path '\*.mat']);
files_data.N_files = length(files_data.dir_content);


%% Load data

data = repmat( ...
        struct( ...
            'x', [], ...
            'y', [], ...
            'fsamp', 0, ...
            'sens', []), ...
        1, ...
        files_data.N_files);
    

%% Read files

for file_idx = 1:files_data.N_files

    file_path_mat = [files_data.path '\' files_data.dir_content(file_idx).name];
    data(file_idx) = load_data(strrep(file_path_mat, '.mat', '.inf'), file_path_mat);

end

clear file_idx file_path_mat


%% Perform analysis

Threshold_level = 10;
T_pre_trigger = 0.01; % [s]
T_post_trigger = 10; % [s]

N_pre_trigger = ceil(data(1).fsamp * T_pre_trigger);
N_post_trigger = ceil(data(1).fsamp * T_post_trigger);

N_sampling = length(data(1).x);
dt = 1 / data(1).fsamp;
df = 1 / T_post_trigger;
t_vet = 0:dt:(N_sampling-1)*dt;
f_vet = 0:df:data(1).fsamp/2;

tukey_flag = true;
exponential_flag = true;

S = struct( ...
    'f_vet', 0:df:data(1).fsamp/2, ...
    'xx', zeros(N_post_trigger, 2), ...
    'yy', zeros(N_post_trigger, 2), ...
    'xy', zeros(N_post_trigger, 2), ...
    'yx', zeros(N_post_trigger, 2));

gamma = struct( ...
    'xy1', [], ...
    'xy2', []);

for file_idx = 1:files_data.N_files

    dataset = data(file_idx);



    idx_vet = find(dataset.x >= Threshold_level, 1) + (-N_pre_trigger:-N_pre_trigger + N_post_trigger - 1);
    
    x = dataset.x(idx_vet);
    y = dataset.y(idx_vet, :);
    [~, peak_idx] = max(x);

    if (tukey_flag)
        tukey_window = compute_window("Tukey", struct('N', 2*peak_idx, 'L', length(x), 'r', 0.5));
        x = x .* tukey_window;
    end
    
    if (exponential_flag)
        exponential_window = compute_window("Exponential", struct('N', length(x), 'P', 1/100));
        y = exponential_window' .* y;
    end

    sp_x = fft(x) ./ size(x, 1);
    sp_y = fft(y) ./ size(y, 1);

    S.xx = S.xx + sp_x .* conj(sp_x);
    S.yy = S.yy + sp_y .* conj(sp_y);

    S.xy = S.xy + sp_x .* conj(sp_y);
    S.yx = S.yx + sp_y .* conj(sp_x);
    
end


%% Estimating average power/cross-spectra

Gxx = S.xx(1:end/2+1,:) ./ files_data.N_files;
Gxx(2:end-1, :) = 2 * Gxx(2:end-1, :);

Gyy = S.yy(1:end/2+1, :) ./ files_data.N_files;
Gyy(2:end-1, :) = 2 * Gyy(2:end-1, :);

Gxy = S.xy(1:end/2+1, :) ./ files_data.N_files;
Gxy(2:end-1, :) = 2 * Gxy(2:end-1, :);

Gyx = S.yx(1:end/2+1, :) ./ files_data.N_files;
Gyx(2:end-1, :) = 2 * Gyx(2:end-1, :);


%% Estimating FRF and coherence

H1 = Gxy ./ Gxx;
H2 = Gyy ./ Gyx;
coherence = abs(Gxy).^2 ./ (Gxx .* Gyy);


%% Plot

reset(0);
set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

figure_preliminary_analysis = figure('Name', 'Preliminary analysis');
tiledlayout(3, 1)

axis_in = nexttile;
hold on
grid on

yline(Threshold_level, '--k', 'LineWidth', 2, 'Label', 'Threshold level')
for file_idx = 1:files_data.N_files
    plot(t_vet, data(file_idx).x)
end

title('Input impluse')
xlabel('Time [s]')
ylabel('Force [N]')

axis_out1 = nexttile;
hold on
grid on

for file_idx = 1:files_data.N_files
    plot(t_vet, data(file_idx).y(:, 1))
end

title('Output 1')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')

axis_out2 = nexttile;
hold on
grid on

for file_idx = 1:files_data.N_files
    plot(t_vet, data(file_idx).y(:, 2))
end

title('Output 2')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')

linkaxes([axis_in axis_out1 axis_out2], 'x')

%% 
figure_analysis = figure('Name', 'H1 and H2 (and coherence) of the FRF');
tiledlayout(2, 2)

abs_FRF = nexttile(1);
hold on
grid on

yyaxis left
semilogy(f_vet, abs(H1(:, 1)), '-b')
semilogy(f_vet, abs(H2(:, 1)), '-r')

set(gca, 'YScale', 'log')
ylabel('|Hi(f)| [(m/s^2)/N]')

yyaxis right
semilogy(f_vet, coherence(:, 1), '-k')
ylabel('Coherence []')

title('H1 and H2 module estimators for accelerometer #1')
xlabel('Frequency [Hz]')
legend('H1(y1)', 'H2(y1)', 'Coherence')

angle_FRF = nexttile(3);
hold on
grid on

plot(f_vet, unwrap(angle(H1(:, 1)))./(2*pi)*360, '-b')
plot(f_vet, unwrap(angle(H2(:, 1)))./(2*pi)*360, '-r')

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('H1 and H2 phase estimators for accelerometer #1')
xlabel('Frequency [Hz]')
ylabel('\phi Hi(f) [rad]')
legend('H1(y1)', 'H2(y1)')

linkaxes([abs_FRF angle_FRF], 'x')


abs_FRF = nexttile(2);
hold on
grid on

yyaxis left
semilogy(f_vet, abs(H1(:, 2)), '-b')
semilogy(f_vet, abs(H2(:, 2)), '-r')

yyaxis right
semilogy(f_vet, coherence(:, 2), '-k')

yyaxis left
set(gca, 'YScale', 'log')
axis tight

title('H1 and H2 module estimators for accelerometer #2')
xlabel('Frequency [Hz]')
ylabel('|Hi(f)| [(m/s^2)/N]')
legend('H1(y1)', 'H2(y1)', 'Coherence')

angle_FRF = nexttile(4);
hold on
grid on

plot(f_vet, angle(H1(:, 2)), '-b')
plot(f_vet, angle(H2(:, 2)), '-r')

set(gca, 'YTick', -pi:pi/2:pi) 
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title('H1 and H2 phase estimators for accelerometer #2')
xlabel('Frequency [Hz]')
ylabel('\phi Hi(f) [rad]')
legend('H1(y1)', 'H2(y1)')

linkaxes([abs_FRF angle_FRF], 'x')


