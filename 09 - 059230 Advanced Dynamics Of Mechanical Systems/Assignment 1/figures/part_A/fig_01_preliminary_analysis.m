% Preliminary analysis

figure('Name', 'Frequencies and mode shapes');
tiledlayout(2, length(f_nat_vet));

H_tile = nexttile([1 length(f_nat_vet)]);
hold on
grid on

semilogy(f_vet, H_det_vet, '-b');
semilogy(f_nat_vet, H_det_vet(find(ismember(f_vet, f_nat_vet))), 'or');

set(gca, 'YScale', 'log')

title('Natural frequencies search')
xlabel('f [Hz]')
ylabel('|H(f)|')

legend('Module of H(f)', 'Natural frequecies')

plot_struct.data{end+1} = {H_tile, '/H_module'};

for ii = 1:length(f_nat_vet)

    tile = nexttile;
    hold on
    grid on

    plot(x_vet, mode_shape(:, ii));

    title(['Mode Shape ' num2str(ii)])
    legend(['f' num2str(ii) ' = ' num2str(f_nat_vet(ii)) ' [Hz]'])

    xlabel('Length [m]')
    ylabel('Normalized displachment [m]')

    plot_struct.data{end+1} = {tile, sprintf('/Mode_shapes/mode_shape_%02d', ii)};

end