% Experimental FRFs for each input/output couple

tabgroup = uitabgroup(figure('Name', 'FRF Experimental'), 'Position', [0 0 1 1]);
tab = uitab(tabgroup, 'Title', 'FRF: single-input multi-output');
tiles = tiledlayout(tab, 2, 1);

xj_idx = [1 2 3 4 5 6];
xk_idx = [5 5 5 5 5 5];
idx = sub2ind([length(xk_input) length(xj_output)], xj_idx, xk_idx);

abs_FRF = nexttile(tiles);
hold on
grid on

semilogy(f_vet, abs(G_exp(idx, :)))

set(gca, 'YScale', 'log')

title(['|G_{exp}(f)| @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
xlabel('f [Hz]')
ylabel('|G(f)| [m/N]')

angle_FRF = nexttile(tiles);
hold on
grid on

plot(f_vet, angle(G_exp(idx, :)))

set(gca, 'YTick', -pi:pi/2:pi)
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title(['\phi(G_{exp}(f)) @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
xlabel('f [Hz]')
ylabel('\phi(G(f)) [rad]')

linkaxes([abs_FRF angle_FRF], 'x')

plot_struct.data{end+1} = {tiles, '/Experimental_FRF_SIMO'};


tab = uitab(tabgroup, 'Title', 'FRF: multi-input multi-output');
tiles = tiledlayout(tab, 2, 1);

xj_idx = [1 4 6 1 4 6];
xk_idx = [2 2 2 5 5 5];
idx = sub2ind([length(xk_input) length(xj_output)], xj_idx, xk_idx);

abs_FRF = nexttile(tiles);
hold on
grid on

semilogy(f_vet, abs(G_exp(idx, :)))

set(gca, 'YScale', 'log')

title(['|G_{exp}(f)| @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
xlabel('f [Hz]')
ylabel('|G(f)| [m/N]')

angle_FRF = nexttile(tiles);
hold on
grid on

plot(f_vet, angle(G_exp(idx, :)))

set(gca, 'YTick', -pi:pi/2:pi)
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title(['\phi(G_{exp}(f)) @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
xlabel('f [Hz]')
ylabel('\phi(G(f)) [rad]')

linkaxes([abs_FRF angle_FRF], 'x')

plot_struct.data{end+1} = {tiles, '/Experimental_FRF_MIMO'};


