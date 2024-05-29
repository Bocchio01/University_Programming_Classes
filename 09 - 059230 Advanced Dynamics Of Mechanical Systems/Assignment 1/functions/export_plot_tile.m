function export_plot_tile(tile, title, plot_struct)

if (isfield(plot_struct, 'export_path'))

    pause(1);
    filename = [plot_struct.export_path '\' title '.png'];
    exportgraphics(tile, filename, 'Resolution', 300);

end

end