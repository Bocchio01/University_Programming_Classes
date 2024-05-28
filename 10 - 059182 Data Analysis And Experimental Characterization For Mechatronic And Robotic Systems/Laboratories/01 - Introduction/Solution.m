clc
clear variables
close all

%% Start of the script

load('01 - Introduction\Data.mat');


%% Data analysis

datas = Data ./ sens;

sampling_time = 1 / fsamp;
time_vector = 0:sampling_time:(size(datas, 1)-1) * sampling_time;

number_signals = size(datas, 2);

statistics = struct( ...
    'max', max(datas), ...
    'min', min(datas), ...
    'mean', mean(datas), ...
    'std', std(datas));

statistics.rms = sqrt(sum(datas.^2) / length(datas));
% statistics.rms = sqrt(mean(datas.^2));
% statistics.rms = sqrt(statistics.mean.^2 + statistics.std.^2);


%% Saving to file

% save('_output.txt', '-ascii', '-double', '-tabs', ...
%     statistics.max, ...
%     statistics.min, ...
%     statistics.mean, ...
%     statistics.std, ...
%     statistics.rms);

output_table = table( ...
    statistics.max', ...
    statistics.min', ...
    statistics.mean', ...
    statistics.std', ...
    statistics.rms', ...
    'VariableNames', {'Max [m/s^2]', 'Min [m/s^2]', 'Mean [m/s^2]', 'STD [m/s^2]', 'RMS [m/s^2]'});
output_table.Properties.RowNames = channels;

writetable(output_table, '_output.xls', 'WriteRowNames', true)


%% Plot the signals in the time domain

set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

figure('Name', 'Signals in time domain')
tiledlayout(2, 1)

for i = 1:number_signals

    nexttile
    hold on
    grid on

    plot(time_vector, datas(:, i))
    plot([0 time_vector(end)], statistics.max(i) * [1 1], 'g')
    plot([0 time_vector(end)], statistics.min(i) * [1 1], 'm')
    plot([0 time_vector(end)], statistics.std(i) * [1 1], 'y', 'Linewidth', 2)
    plot([0 time_vector(end)], statistics.rms(i) * [1 1], '--k', 'Linewidth', 2)

    axis tight
    title(['Channel ' channels{i}])
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    legend( ...
        [channels{i} ' direction'], ...
        ['Max: ' num2str(statistics.max(i)) ' m/s^2'], ...
        ['Min: ' num2str(statistics.min(i)) ' m/s^2'], ...
        ['STD: ' num2str(statistics.std(i)) ' m/s^2'], ...
        ['RMS: ' num2str(statistics.rms(i)) ' m/s^2'], ...
        'Location', 'Best');

end