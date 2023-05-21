clc
close all
clear variables

%% Requests

% Scrivere uno script Matlab che, dato un file molecola.cube, scrive un file sistema.xyz rispettando le seguenti condizioni:
% 1. il file molecola.cube contiene la densità elettronica di una molecola qualsiasi;
% 2. il file sistema.xyz contiene la struttura del sistema formato da (i) la molecola considerata al punto precedente (cioè quella di cui è data la densità elettronica) e (ii) un atomo di litio;
% 3. nel file sistema.xyz, l’atomo di litio è posto in un punto scelto casualmente tra tutti quelli con densità elettronica ρ(x, y, z) = ρ0 ± δρ;
% 4. lo script permette all’utente di controllare direttamente i valori di ρ0 e δρ.

% In aggiunta, è possibile estendere lo script per fare in modo che possa essere posizionato un numero qualsiasi di atomi di litio in maniera analoga a quella appena esposta. In questo caso devono sussistere le seguenti condizioni:
% 1. lo script permette all’utente di scegliere quanti atomi di litio posizionare;
% 2. le posizioni degli atomi di litio sono casuali;
% 3. le posizioni degli atomi di litio sono tali che due atomi di litio non hanno mai distanza minore di R;
% 4. lo script permette all’utente di scegliere il valore di R.

%% Section 0: Variable declaration

cube_file_name = 'densita.cube';

rho_0 = 0.3;
delta_rho = 0.05;

N_lithium = 100;
R_lithium  = 0.3;

graph = true;


%% Section 1: Reading molecule state data

% Open the .cube file
fid = fopen(cube_file_name,'r');

% Skip the first two lines of the file
COMMENT1 = fgetl(fid);
COMMENT2 = fgetl(fid);

% Read the third line of the file and extract the number of atoms and the origin coordinates
data = sscanf(fgetl(fid), '%d %f %f %f %d');
NATOMS = data(1);
ORIGIN = struct('X', data(2), 'Y', data(3), 'Z', data(4));

% {NVAL} may be omitted if its value would be equal to one; it MUST be absent or have a value of one if {NATOMS} is negative.
if (length(data) == 5)
    NVAL = data(5);
end

% Read the next three lines of the file to extract the origin coordinates and grid spacing
AXIS = struct('N', [], 'X', [], 'Y', [], 'Z', []);
for dir = 1:3
    data = sscanf(fgetl(fid), '%d %f %f %f');
    AXIS(dir) = struct('N', data(1), 'X', data(2), 'Y', data(3), 'Z', data(4));
end

% Read the info related to the atoms presents in the moleculas
ATOMS_INFO = struct('N', [], 'C', [], 'X', [], 'Y', [], 'Z', []);
for n = 1:NATOMS
    data = sscanf(fgetl(fid), '%d %f %f %f %f');
    ATOMS_INFO(n) = struct('N', data(1), ...
        'C', data(2), ...
        'X', data(3), ...
        'Y', data(4), ...
        'Z', data(5));
end

clear n;


%% Section 2: Reading molecule electronic density data

% Read the rest of the file to extract the electronic density data
data = fscanf(fid, '%f');
% Close the file
fclose(fid);


%% Section 3: Visualize molecule

VOXEL_GRID_MATRIX = [[AXIS.X]', [AXIS.Y]', [AXIS.Z]'];
ORIGIN_VECTOR = struct2array(ORIGIN)';

% Reshape the data into a 3D array
density = reshape(data, [AXIS.N]);
density = permute(density, [3, 2, 1]);

% Plot N slice of the electronic density data
if graph
    for section_level=linspace(1, AXIS(3).N/2, 3)
        nexttile
        hold on
        axis equal tight;
        colormap("parula");
        % colormap("hot");
        colorbar;
        imagesc(squeeze(density(round(section_level),:,:)));
        title(sprintf('Densità elettronica @Z=%d', round(section_level)))
        xlabel('x_{eq}')
        ylabel('y_{eq}')
    end
end


%% Section 4: Identify iso-density surface

% Find points with density within the range
idx = find(abs(density - rho_0) <= delta_rho);
[x,y,z] = ind2sub(size(density), idx);

ISO_DENSITY = [x y z] * VOXEL_GRID_MATRIX + ORIGIN_VECTOR';
ISO_DENSITY = struct('X', num2cell(ISO_DENSITY(:, 1)), ...
    'Y', num2cell(ISO_DENSITY(:, 2)), ...
    'Z', num2cell(ISO_DENSITY(:, 3)));

% Plot the points in 3D space with colors indicating density
if graph
    nexttile
    hold on
    grid on
    scatter3([ISO_DENSITY.X], ...
        [ISO_DENSITY.Y], ...
        [ISO_DENSITY.Z], ...
        10, ...
        density(idx), ...
        'filled');
    colorbar;
    view(3);
    title(sprintf('Volume ad iso-densità, rho=%0.3f+-%0.3f', rho_0, delta_rho))
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end


if graph
    nexttile
    hold on
    grid on

    % Create a 3D grid of coordinates corresponding to the density matrix
    [X,Y,Z] = meshgrid( ...
        1:size(density,1), ...
        1:size(density,2), ...
        1:size(density,3) ...
        );

    % I suppose the space grid is orthogonal...
    X = X * VOXEL_GRID_MATRIX(1, 1) + ORIGIN_VECTOR(1);
    Y = Y * VOXEL_GRID_MATRIX(2, 2) + ORIGIN_VECTOR(2);
    Z = Z * VOXEL_GRID_MATRIX(3, 3) + ORIGIN_VECTOR(3);

    % Visualizing iso-density surface
    for isovalue = rho_0 + [-delta_rho, delta_rho]

        % Create the isosurface using the isodensity value and the density matrix
        fv = isosurface(Y, X, Z, ...
            density, ...
            isovalue);

        % Plot the isosurface with a color map
        p = patch(fv);
        set(p, ...
            'FaceColor', 'red', ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.3);
        view(3);
        camlight;
        lighting gouraud;

    end
    title(sprintf('Superfici superiore ed inferiore ad iso-densità, rho=%0.3f', rho_0))
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end


%% Section 5: Random positioning of the Lithium athoms

if (~exist('N_lithium', 'var') || ~exist('R_lithium', 'var'))
    N_lithium = input('Enter the number of lithium athoms to be added: ');
    R_lithium = input('Enter the value of the athom radius: ');
end

LI_VECTOR = struct('X', [], 'Y', [], 'Z', []);
foundPosition = false(N_lithium, 1);
maxAttempts = 100;

for i = 1:N_lithium
    attempt = 1;
    D = 0;

    while (attempt == 1 || any(D < R_lithium))
        % Generate random positions for the new lithium atom
        index = randi(numel(ISO_DENSITY));
        LI = ISO_DENSITY(index);

        % Calculate the distances between the new atom and existing atoms
        D = pdist([[LI_VECTOR.X]' [LI_VECTOR.Y]' [LI_VECTOR.Z]'; ...
            struct2array(LI)]);

        % Check if the distances satisfy the constraint
        if all(D >= R_lithium)
            LI_VECTOR(i) = LI;
            foundPosition(i) = true;
            break;
        end

        % Increase the attempt counter
        attempt = attempt + 1;

        % Check if the maximum number of attempts is reached
        if attempt > maxAttempts
            fprintf('Could not find a suitable position for lithium atom %d\n', i);
            break;
        end
    end
end

view(3);

clear i;


%% Section 6: Write to XYZ file

% Load the periodical element from external file
Elements = table2struct(readtable('periodic-table.xlsx'));

% Open a file for writing
fid = fopen('sistema.xyz', 'w');

% Write the number of atoms as the first line and comment as second
fprintf(fid, '%d\n', NATOMS + nnz(foundPosition));
fprintf(fid, '%s\n', strcat(strtrim(COMMENT1), '-', strtrim(COMMENT2)));

% Adding the index element value to each lithium athom added
LI_INFO = arrayfun(@(s) struct('N', 3, 'X', s.X, 'Y', s.Y, 'Z', s.Z), LI_VECTOR);

% Write the XYZ coordinates to the file
print_to_xyz(fid, ATOMS_INFO, Elements);
print_to_xyz(fid, LI_INFO(foundPosition), Elements);

if graph
    plot_xyz(ATOMS_INFO, Elements, 'g');
    plot_xyz(LI_INFO(foundPosition), Elements, 'b');
end

% Close the file
fclose(fid);



%% Functions

function [] = print_to_xyz(fid, atoms_data, Elements)
for i = 1:numel(atoms_data)
    fprintf(fid, ...
        '%s %.4f %.4f %.4f\n', ...
        Elements(atoms_data(i).N).Symbol, ...
        atoms_data(i).X, ...
        atoms_data(i).Y, ...
        atoms_data(i).Z);
end
end


function [] = plot_xyz(atoms_data, Elements, color)
for i = 1:numel(atoms_data)
    [X, Y, Z] = sphere(20);
    R = Elements(atoms_data(i).N).x_VanDerWaalsRadius__pm_/1000;
    surf(R * X + atoms_data(i).X, ...
        R * Y + atoms_data(i).Y, ...
        R * Z + atoms_data(i).Z, ...
        'EdgeColor', 'none', ...
        'FaceColor', color);
end
end
