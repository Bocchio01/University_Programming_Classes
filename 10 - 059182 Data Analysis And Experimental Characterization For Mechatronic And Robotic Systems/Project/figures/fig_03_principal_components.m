% Principal components visualization

PC_parameters = cell(0);
PC_parameters{end+1} = struct('b', compute_window(20/100), 'start_idx', compute_window(0/100));
PC_parameters{end+1} = struct('b', compute_window(40/100), 'start_idx', compute_window(50/100));

tabgroup = uitabgroup(figure('Name', 'Principal components analysis'), 'Position', [0 0 1 1]);

for ii = 1:length(PC_parameters)

    PC_parameter = PC_parameters{ii};
    b = PC_parameter.b;
    start_idx = PC_parameter.start_idx;

    PCs = apply_PCA(data.frequencies_mat(start_idx + (1:b), :), 0);

    tab = uitab(tabgroup);
    axes('parent', tab);
    tiles = tiledlayout(size(PCs, 2), 1);

    for PC_idx = 1:size(PCs, 2)

        nexttile(tiles)
        hold on
        grid on

        plot(time_vet(start_idx + (1:b)), PCs(:, PC_idx))

    end

    title_string = sprintf('PCs @ [b, start_{idx}] = [%d, %d]', b, start_idx);

    tab.Title = title_string;
    tiles.Title.String = title_string;

    tiles.XLabel.String = 'Time [Day]';
    tiles.YLabel.String = 'Scores []';

    plot_struct.data{end+1} = {tiles, sprintf('/PCs_%02d', ii)};

end

clear ii PC_idx tabgroup tab tiles title_string
clear PCs PC_parameter b start_idx