%% Mode shapes visualization

figure('Name', 'Mode shapes - Experimental vs. Numerical');
tiledlayout(ceil(length(f_nat_vet) / 2), floor(length(f_nat_vet) / 2) + 1);

d_angle = 15;
angle_vet = deg2rad(0:d_angle:180-d_angle);
angle_resized_vet = linspace(min(angle_vet), max(angle_vet), 180);
base_circle = 6;

for ii = 1:length(f_nat_vet)

    nexttile;
    % hold on
    grid on

    mode_shape_points = real(A_num(:, ii)) / max(abs(A_num(:, ii))) + base_circle;
    mode_shape_spline = spline(angle_vet, mode_shape_points, angle_resized_vet);

    polarplot(deg2rad(0:360-1), base_circle * ones(1, 360), '--k');
    hold on

    polarplot(angle_resized_vet, mode_shape_spline, '-r', 'LineWidth', 2);
    polarplot(deg2rad(360) - angle_resized_vet, mode_shape_spline, '-b', 'LineWidth', 2);
    polarplot(angle_vet, mode_shape_points, 'or');

    set(gca, 'ThetaZeroLocation', 'bottom')
    rticks([]);

    title(['Mode Shape ' num2str(ii)])
    legend('Un-deformed', 'Identified', 'Symmetrical')

    plot_struct.data{end+1} = {gca, sprintf('/ModeShape_%02d', ii)};

end
