% FRFs visualization

tabgroup = uitabgroup(figure('Name', 'FRFs of the structure'), 'Position', [0 0 1 1]);

tab = uitab(tabgroup, 'Title', 'FRF related to Vertical force in A');
tiles = tiledlayout(tab, 2, 2);

interrogation_points = [idb(9, 2) idb(14, 1)];
interrogation_labels = {'Vertical Displacement of A', 'Horizontal Displacement of B'};

for point_idx = 1:length(interrogation_points)
    
    FRF_abs = nexttile(tiles, point_idx);
    hold on
    grid on
    
    semilogy(omega_vet / (2*pi), abs(FRF_direct_approach(interrogation_points(point_idx), :)))
    
    set(gca, 'YScale', 'log');
    
    title(['FRF - ' interrogation_labels{point_idx} ' caused by Vertical force in A'])
    xlabel('Frequency [Hz]')
    ylabel('|FRF| [m/N]')
    
    
    FRF_angle = nexttile(tiles, point_idx + 2);
    hold on
    grid on
    
    plot(omega_vet / (2*pi), angle(FRF_direct_approach(interrogation_points(point_idx), :)))
    
    xlabel('Frequency [Hz]')
    ylabel('Phase [rad]')
    
    linkaxes([FRF_abs FRF_angle], 'x');
    
end

plot_struct.data{end+1} = {tiles, '/FRFs/Vertical_in_A'};


% FRF Direct vs. Modal approach
tab = uitab(tabgroup, 'Title', 'Direct (Lagrangian) vs. Modal Superposition Approach');
tiles = tiledlayout(tab, 2, 1);

FRF_abs = nexttile(tiles);
hold on
grid on

semilogy(omega_vet / (2*pi), abs(FRF_direct_approach(interrogation_points(end), :)))
semilogy(omega_vet / (2*pi), abs(FRF_modal_approach(interrogation_points(end), :)))

set(gca, 'YScale', 'log');

title(['FRF - ' interrogation_labels{2} ' caused by Vertical force in A' ])
xlabel('Frequency [Hz]')
ylabel('|FRF| [m/N]')
legend('Direct (FEM)', 'Modal Superpostion')


FRF_angle = nexttile(tiles);
hold on
grid on

plot(omega_vet / (2*pi), angle(FRF_direct_approach(interrogation_points(end), :)))
plot(omega_vet / (2*pi), angle(FRF_modal_approach(interrogation_points(end), :)))

xlabel('Frequency [Hz]')
ylabel('Phase [rad]')
legend('Direct (FEM)', 'Modal Superpostion')

linkaxes([FRF_abs FRF_angle], 'x');

plot_struct.data{end+1} = {tiles, '/FRFs/Direct_vs_Modal'};


% Reaction force in O2 caused by Vertical force in A
tab = uitab(tabgroup, 'Title', 'Reaction force in O2');
tiles = tiledlayout(tab, 2, 1);

FRF_abs = nexttile(tiles);
hold on
grid on

semilogy(omega_vet / (2*pi), abs(FRF_RV1))

set(gca, 'YScale', 'log');

title('FRF - Vertical reaction force in O_2 caused by Vertical force in C')
xlabel('Frequency [Hz]')
ylabel('|FRF| [N/N]')


FRF_angle = nexttile(tiles);
hold on
grid on

plot(omega_vet / (2*pi), angle(FRF_RV1))

xlabel('Frequency [Hz]')
ylabel('Phase [rad]')

linkaxes([FRF_abs FRF_angle], 'x');

plot_struct.data{end+1} = {tiles, '/FRFs/Reaction_O2'};