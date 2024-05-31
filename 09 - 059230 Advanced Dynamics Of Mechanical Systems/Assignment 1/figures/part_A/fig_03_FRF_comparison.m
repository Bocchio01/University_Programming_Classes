% Comparison between experimental and numerical FRF

tabgroup = uitabgroup(figure('Name', 'FRF - Experimental vs. Numerical'), 'Position', [0 0 1 1]);

tab = uitab(tabgroup, 'Title', 'Overview (all peaks)');
tiles = tiledlayout(tab, 2, 1);

xj_idx = 3;
xk_idx = 5;
idx = sub2ind([length(xk_input) length(xj_output)], xj_idx, xk_idx);

abs_FRF = nexttile(tiles);
hold on
grid on

semilogy(f_vet, abs(G_exp(idx, :)))
for ii = 1:length(f_nat_vet)
    semilogy(f_range_vet(ii, :), abs(squeeze(G_num(idx, ii, :))), 'or')
end

set(gca, 'YScale', 'log')

title(['|FRF| @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
legend('G_{exp}(f)', 'G_{num}(f)')
xlabel('f [Hz]')
ylabel('|G(f)| [m/N]')

angle_FRF = nexttile(tiles);
hold on
grid on

plot(f_vet, angle(G_exp(idx, :)))
for ii = 1:length(f_nat_vet)
    plot(f_range_vet(ii, :), angle(squeeze(G_num(idx, ii, :))), 'or')
end

set(gca, 'YTick', -pi:pi/2:pi)
set(gca, 'YTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'})

title(['\phi(FRF) @[xk, xj] = [' num2str(xk_idx) ', ' num2str(xj_idx) ']'])
legend('G_{exp}(f)', 'G_{num}(f)')
xlabel('f [Hz]')
ylabel('\phi(G(f)) [rad]')

linkaxes([abs_FRF angle_FRF], 'x')

plot_struct.data{end+1} = {tiles, sprintf('/Comparison_FRF_couple_%d_%d', xj_idx, xk_idx)};


for ii = 1:length(f_nat_vet)

    tab = uitab(tabgroup, 'Title', ['Zoom peak ' num2str(ii)]);
    tiles = tiledlayout(tab, 2, 2);

    tile_abs = nexttile(tiles, 1);
    grid on
    copyobj(abs_FRF.Children, tile_abs)

    title(['FRF @[xk, xj, peak] = [' num2str(xk_idx) ', ' num2str(xj_idx) ', ' num2str(ii) ']'])

    tile_angle = nexttile(tiles, 3);
    grid on
    copyobj(angle_FRF.Children, tile_angle)

    linkaxes([tile_abs tile_angle], 'x')

    xlim([min(f_range_vet(ii, :))-1 max(f_range_vet(ii, :))+1])
    plot_struct.data{end+1} = {tiles, sprintf('/Comparison_FRF_couple_%d_%d_zoom_peak_%02d', xj_idx, xk_idx, ii)};

end
