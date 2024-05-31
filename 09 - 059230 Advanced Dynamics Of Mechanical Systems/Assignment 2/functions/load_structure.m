function [xy,nnod,idb,ndof,incidenze,l,gamma,m,EA,EJ,posiz,nbeam,pr] = load_structure(filename)

lines = readlines(filename);

% NODES
line_idx = find(contains(lines, "*NODES", 'IgnoreCase', true), 1, 'first') + 2;
while (~contains(lines(line_idx), ["*ENDNODES", "!"], 'IgnoreCase', true))

    tmp = sscanf(lines(line_idx), '%i %i %i %i %f %f');
    ivinc(tmp(1), :) = tmp(2:4);
    xy(tmp(1), :) = tmp(5:6);

    line_idx = line_idx + 1;

end

nnod = size(xy, 1);

ndof = numel(find(ivinc == 0));
ndoc = numel(find(ivinc == 1));

idb = zeros(size(ivinc));

ivinc = reshape(ivinc', 1, []);
idb = reshape(idb', 1, []);
idb(ivinc == 0) = 1:ndof;
idb(ivinc == 1) = ndof + (1:ndoc);
ivinc = reshape(ivinc, 3, [])';
idb = reshape(idb, 3, [])';

% PROPERTIES
line_idx = find(contains(lines, "*PROPERTIES", 'IgnoreCase', true), 1, 'first') + 2;
while (~contains(lines(line_idx), "*ENDPROPERTIES", 'IgnoreCase', true))

    tmp = sscanf(lines(line_idx), '%i %f %f %f');
    properties(tmp(1), :) = tmp(2:4);

    line_idx = line_idx + 1;

end

% BEAMS
line_idx = find(contains(lines, "*BEAMS", 'IgnoreCase', true), 1, 'first') + 2;
while (~contains(lines(line_idx), "*ENDBEAMS", 'IgnoreCase', true))

    tmp = sscanf(lines(line_idx), '%i %i %i %i');

    incid(tmp(1), :)     = tmp(2:3);
    pr(1, tmp(1))        = tmp(4);
    m(1, tmp(1))         = properties(tmp(4), 1);
    EA(1, tmp(1))        = properties(tmp(4), 2);
    EJ(1, tmp(1))        = properties(tmp(4), 3);
    l(1, tmp(1))         = sqrt((xy(incid(tmp(1),2),1)-xy(incid(tmp(1),1),1))^2 + (xy(incid(tmp(1),2),2)-xy(incid(tmp(1),1),2))^2);
    gamma(1, tmp(1))     = atan2(xy(incid(tmp(1),2),2)-xy(incid(tmp(1),1),2), xy(incid(tmp(1),2),1)-xy(incid(tmp(1),1),1));
    incidenze(tmp(1), :) = [idb(incid(tmp(1),1),:) idb(incid(tmp(1),2),:)];
    posiz(tmp(1), :)     = xy(incid(tmp(1),1),:);
    
    line_idx = line_idx + 1;

end

nbeam = size(incid, 1);

end