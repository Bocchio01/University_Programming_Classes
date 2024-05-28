function data = load_data(filename_inf, filename_mat)

inf_file_id = fopen(filename_inf, 'r');

data = struct( ...
        'x', [], ...
        'y', [], ...
        'fsamp', 0, ...
        'sens', [2.4e-3 1.02e-2 1.02e-2]);

raw_data = load(filename_mat).Dati ./ data.sens;
data.x = raw_data(:, 1);
data.y = raw_data(:, 2:3);
data.fsamp = fscanf(inf_file_id, '%d', 1);

fclose(inf_file_id);

end

