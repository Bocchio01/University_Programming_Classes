% Structure responses

tabgroup = uitabgroup(figure('Name', 'Structure responses (deformed configurations)'), 'Position', [0 0 1 1]);

% Configuration due to gravity
tab = uitab(tabgroup, 'Title', 'Gravity force (Displacement vs. Acceleration approach)');
tiles = tiledlayout(tab, 1, 2);

nexttile(tiles);
hold on
grid on

axis_displacemnt = plot_deformed(X_gravity_displacement_approach,scale_factor,incid,l,gamma,posiz,idb,xy);

axis tight

title('Displacement method/approach')
xlabel('Length [m]')
ylabel('Height [m]')
legend('Undeformed shape','Deformed shape')

plot_struct.data{end+1} = {gca, '/Responses/Gravity_displacement'};


nexttile(tiles);

axis_acceleration = plot_deformed(X_gravity_acceleration_approach,scale_factor,incid,l,gamma,posiz,idb,xy);

axis tight

title('Nodal acceleration method/approach')
xlabel('Length [m]')
ylabel('Height [m]')
legend('Undeformed shape','Deformed shape')

plot_struct.data{end+1} = {gca, '/Responses/Gravity_acceleration'};

linkaxes([axis_displacemnt axis_acceleration])


% Configuration due to moving load
tab = uitab(tabgroup, 'Title', 'Moving load (D -> A)');
tiles = tiledlayout(tab, 3, 1);

nexttile(tiles, 3);
hold on
grid on

plot(t, X_moving_load(idb(9, 2), :))
xline(20/2, '--k', 'Label', 'Passage at node 8')
xline(20, '--k', 'Label', 'Arrival at node A')

title('Vertical displacement of node A history')
xlabel('Time [s]')
ylabel('Oscillation around initial position [m]')

for time_idx = floor(linspace(1, size(X_moving_load, 2), 50))

    nexttile(tiles, 1, [2, 1]);
    axis_plot = plot_deformed(X_moving_load(:, time_idx), scale_factor, incid, l, gamma, posiz, idb, xy);
    xline(load_position(t(time_idx)) + xy(7, 1), '--k', 'Label', 'Load position')
    axis tight

    nexttile(tiles, 3);
    plot(t(time_idx), X_moving_load(idb(9, 2), time_idx), 'ro')

    drawnow
    if (time_idx ~= size(X_moving_load, 2))
        cla(axis_plot);
    end
    
end

% plot_struct.data{end+1} = {axis_plot, '/Responses/Moving_load_structure'};
plot_struct.data{end+1} = {gca, '/Responses/Moving_load_history'};