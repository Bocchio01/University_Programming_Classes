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


%% Section 1: Reading molecule state data

% Open the .cube file
fid = fopen('densita.cube','r');

% Skip the first two lines of the file
COMMENT1 = fgetl(fid);
COMMENT2 = fgetl(fid);

% Read the third line of the file and extract the number of atoms and the origin coordinates
line = fgetl(fid);
data = sscanf(line, '%d %f %f %f %d');
NATOMS = data(1);
ORIGIN.X  = data(2);
ORIGIN.Y  = data(3);
ORIGIN.Z  = data(4);

% {NVAL} may be omitted if its value would be equal to one; it MUST be absent or have a value of one if {NATOMS} is negative.
if (length(data) == 5)
    NVAL = data(5);
end

% Read the next three lines of the file to extract the origin coordinates and grid spacing
data = sscanf(fgetl(fid), '%d %f %f %f');
XAXIS.N = data(1);
XAXIS.X = data(2);
XAXIS.Y = data(3);
XAXIS.Z = data(4);

data = sscanf(fgetl(fid), '%d %f %f %f');
YAXIS.N = data(1);
YAXIS.X = data(2);
YAXIS.Y = data(3);
YAXIS.Z = data(4);

data = sscanf(fgetl(fid), '%d %f %f %f');
ZAXIS.N = data(1);
ZAXIS.X = data(2);
ZAXIS.Y = data(3);
ZAXIS.Z = data(4);

% Read the info related to the atoms presents in the moleculas
% Declare the ATOMS_INFO struct array
ATOMS_INFO(NATOMS).N = [];
ATOMS_INFO(NATOMS).C = [];
ATOMS_INFO(NATOMS).X = [];
ATOMS_INFO(NATOMS).Y = [];
ATOMS_INFO(NATOMS).Z = [];

for n = 1:NATOMS
    data = sscanf(fgetl(fid), '%d %f %f %f %f');
    ATOMS_INFO(n).N = data(1);
    ATOMS_INFO(n).C = data(2);
    ATOMS_INFO(n).X = data(3);
    ATOMS_INFO(n).Y = data(4);
    ATOMS_INFO(n).Z = data(5);
end

clear line n data;


%% Section 2: Reading molecule electronic density data

% Read the rest of the file to extract the electronic density data
data = fscanf(fid, '%f');
% Close the file
fclose(fid);


%% Section 3: Visualize molecule

% Reshape the data into a 3D array
density = reshape(data, [XAXIS.N, YAXIS.N, ZAXIS.N]);

% Plot N slice of the electronic density data
for section_level=linspace(1, ZAXIS.N/2, 3)
    nexttile
    hold on
    axis equal tight;
    colormap("parula"); % Set colormap(hot) for a better visualization
    colorbar;
    imagesc(squeeze(density(:,:,round(section_level))));
end


%% Section 4: Identify iso-density surface

rho_0 = 0.3;
delta_rho = 0.05;

% Find points with density within the range
idx = find(abs(density - rho_0) <= delta_rho);
[x,y,z] = ind2sub(size(density), idx);
x = x * XAXIS.X;
y = y * YAXIS.Y;
z = z * ZAXIS.Z;

% % Create a color map for the density values
% cmap = jet(256);
% density_scaled = round((density - rho_0 + delta_rho) / (2 * delta_rho) * 255) + 1;
% density_scaled(density_scaled < 1) = 1;
% density_scaled(density_scaled > 256) = 256;
% colors = cmap(density_scaled, :);

% Plot the points in 3D space with colors indicating density
nexttile
scatter3(x, y, z, 10, density(idx), 'filled');
colorbar;


% Visualizing iso-density surface
for isovalue = rho_0 + [-delta_rho, delta_rho]

    % Create a 3D grid of coordinates corresponding to the density matrix
    [X,Y,Z] = meshgrid( ...
        1:size(density,1), ...
        1:size(density,2), ...
        1:size(density,3) ...
        );

    % Create the isosurface using the isodensity value and the density matrix
    fv = isosurface(X,Y,Z,density,isovalue);

    % Plot the isosurface with a color map
    nexttile
    p = patch(fv);
    set(p, 'FaceColor', 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
    daspect([XAXIS.X YAXIS.Y ZAXIS.Z]);
    view(3);
    camlight;
    lighting gouraud;

end


%% Section 5: Write to XYZ file

% Load the periodical element from external file
load('Elements.mat')

% Open a file for writing
fid = fopen('sistema.xyz', 'w');

% Write the number of atoms as the first line and comment as second
fprintf(fid, '%d\n', NATOMS);
fprintf(fid, '%s\n', COMMENT1);

% Write the XYZ coordinates for each atom
for i = 1:NATOMS
    index = find([Elements.atomic_number] == ATOMS_INFO(i).N);
    if (index)
        symbol = Elements(index).symbol;
    else
        symbol = int2str(ATOMS_INFO(i).N);
    end
    fprintf(fid, '%s %.4f %.4f %.4f\n', symbol, ATOMS_INFO(i).X, ATOMS_INFO(i).Y, ATOMS_INFO(i).Z);
end

% Write the XYZ coordinates for the litium element
rnd_index = randi(length(x));
fprintf(fid, ...
    '%s %.4f %.4f %.4f\n', ...
    Elements(3).symbol, ...
    x(rnd_index), ...
    y(rnd_index), ...
    z(rnd_index));


% Close the file
fclose(fid);

clear symbol index i;






