% Preliminary analysis

figure('Name', 'Preliminary analysis');
tiles = tiledlayout(2, 1);

% Temperature over time
temperature_plot = nexttile;
hold on
grid on

plot(time_vet, data.temperature_vet, '-b');

xlim('tight')
title('Registered temperature over time')
xlabel('Time [Day]')
ylabel('Temperature [°C]')
legend('T(t) [°C]')

% Structure eigenfrequencies over time
frequencies_plot = nexttile;
hold on
grid on

legend_entries = cell(1, size(data.frequencies_mat, 2));

for ii = 1:size(data.frequencies_mat, 2)

    plot(time_vet, data.frequencies_mat(:, ii), '-');
    legend_entries{ii} = ['f_' num2str(ii) ' [Hz]'];

end

xlim('tight')
title('Registered eigenfrequency over time')
xlabel('Time [Day]')
ylabel('Natural frequencies [Hz]')
legend(legend_entries)

plot_struct.data{end+1} = {tiles, '/Preliminary_analysis'};

linkaxes([temperature_plot frequencies_plot], 'x')

clear ii tiles legend_entries temperature_plot frequencies_plot