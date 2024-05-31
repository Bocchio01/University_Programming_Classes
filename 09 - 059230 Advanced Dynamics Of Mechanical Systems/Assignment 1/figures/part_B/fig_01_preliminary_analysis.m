% Data visualization (FRFs and coherence)

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

plot_struct.data{end+1} = {tiles, '/Experimental_data'};