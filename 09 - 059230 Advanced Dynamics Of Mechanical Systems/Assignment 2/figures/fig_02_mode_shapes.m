% Mode shapes visualization

figure('Name', 'Firsts mode shapes');
tiledlayout(floor(size(Phi, 2) / 2), floor((size(Phi, 2)+1) / 2))

for ii = 1:size(Phi, 2)
    
    nexttile
    
    plot_deformed(mode_shapes(:, ii), scale_factor, incid, l, gamma, posiz, idb, xy);
    
    axis tight
    
    title(['Mode shape ' num2str(ii) ' @\omega_' num2str(ii) ' = ' num2str(omega_nat(ii), 5) ' [rad/s]'])
    xlabel('Length [m]')
    ylabel('Height [m]')

    plot_struct.data{end+1} = {gca, sprintf('/ModeShapes/Mode_%02d', ii)};
    
end