% Undeformed structure

figure('Name', 'Undeformed structure')
plot_structure(posiz, l, gamma, xy, pr, idb, ndof);

plot_struct.data{end+1} = {gca, '/undeformed-structure'};