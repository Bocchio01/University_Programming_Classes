% Results comparison

tabgroup = uitabgroup(figure('Name', 'Results comparison'), 'Position', [0 0 1 1]);

for ii = 1:length(results)

    tab = uitab(tabgroup);
    axes('parent', tab)

    parameter = parameters{ii};
    result = results{ii};

    nexttile
    hold on
    grid on
    colororder({'k','b'})

    yyaxis right
    plot(time_vet, data.temperature_vet - mean(data.temperature_vet), '-b');

    yyaxis left
    switch (result.method)

        case 'MSD'
            b = parameter.b;

            d_MSD = result.d_MSD;
            t_MSD = result.t_MSD;

            plot(time_vet(1:b), d_MSD(1:b) / t_MSD, 'xk')
            plot(time_vet(b+1:end), d_MSD(b+1:end) / t_MSD, '^r')
            yline(t_MSD / t_MSD, '--k', 'Label', 't_{threshold}', 'LineWidth', 2)
            xline(time_vet(b), '-.k', 'Label', 'baseline')

            legend('(MSD) Baseline data', '(MSD) Observation data')

            title_string = sprintf('MSD @ [b, contains-damage-flag] = [%d, %d]', b, parameter.F0_contains_damage);

        case 'PCA'
            b = parameter.b;
            n = parameter.n;
            p = parameter.p;

            d_PCA = result.d_PCA;
            t_PCA_lo = result.t_PCA_lo;
            t_PCA = result.t_PCA;
            t_PCA_up = result.t_PCA_up;

            plot(time_vet(b+1:end), d_PCA(b+1:end) / t_PCA, '^r')
            yline(t_PCA_up / t_PCA, '--k', 'Label', 't_{up}', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
            yline(t_PCA / t_PCA, '-.k', 'Label', 't_{threshold}', 'LabelHorizontalAlignment', 'left');
            yline(t_PCA_lo / t_PCA, '--k', 'Label', 't_{lo}', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
            xline(time_vet(b), '-.k', 'Label', 'baseline')

            legend('(PCA) Observation data')

            title_string = sprintf('PCA @ [b, n, p] = [%d, %d, %d]', b, n, p);

    end

    xlim('tight')

    tab.Title = title_string;
    title(title_string)
    yyaxis left
    ylabel('Normalized index []')

    yyaxis right
    ylabel('Temperature oscillation [°C]')

    xlabel('Time [Day]')

    plot_struct.data{end+1} = {tab, sprintf('/Run_%02d', ii)};

end

clear ii tabgroup tab title_string
clear parameter b n p
clear result d_MSD t_MSD d_PCA t_PCA_lo t_PCA t_PCA_up