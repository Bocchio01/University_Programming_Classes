% Comparison between experimental and numerical FRF

figure('Name', 'Mode shapes - Experimental vs. Numerical');
tiledlayout(ceil(length(f_nat_vet) / 2), floor(length(f_nat_vet) / 2))

for ii = 1:length(f_nat_vet)

    tile = nexttile;
    hold on
    grid on

    plot(x_vet, mode_shape(:, ii), 'LineWidth', 1)
    plot(xj_output, real(A_num(1:6, ii)) / max(abs(A_num(1:6, ii))), 'or')
    
    title(['Mode Shape ' num2str(ii)])
    legend('Experimental', 'Numerical')

    xlabel('Length [m]')
    ylabel('Normalized displachment [m]')

    plot_struct.data{end+1} = {tile, sprintf('/Comparison_ModeShape_%02d', ii)};

end
