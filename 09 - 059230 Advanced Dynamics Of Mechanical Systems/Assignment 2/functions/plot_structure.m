function plot_structure(posiz, l, gamma, xy, beam_properties_type, idb, ndof)
hold on
grid on

title('Undeformed structure')
xlabel('Length [m]')
ylabel('Height [m]')

n_beams = length(l);
n_nodes = size(xy, 1);
colors_palette = ["r" "g" "b"];

xmax = max(xy(:,1));
xmin = min(xy(:,1));
ymax = max(xy(:,2));
ymin = min(xy(:,2));

dx = (xmax - xmin)/200;
dy = (ymax - ymin)/200;
d = sqrt(dx^2 + dy^2);

% Beams
for ii = 1:n_beams

    x1 = posiz(ii,1);
    y1 = posiz(ii,2);
    x2 = posiz(ii,1) + l(ii) * cos(gamma(ii));
    y2 = posiz(ii,2) + l(ii) * sin(gamma(ii));

    plot([x1 x2], [y1 y2], ...
        'LineWidth', 2, ...
        'Color', colors_palette(beam_properties_type(ii)));

end

% Nodes
triangolo_h = [ 0 0; -sqrt(3)/2 .5; -sqrt(3)/2 -.5; 0 0]*d*2;
triangolo_v = [ 0 0; .5 -sqrt(3)/2; -.5 -sqrt(3)/2; 0 0]*d*2;
triangolo_r = [0 0; .5 -sqrt(3)/2; -.5 -sqrt(3)/2; 0 0]*d*2 * [sqrt(2)/2 -sqrt(2/2); -sqrt(2)/2 -sqrt(2)/2];

for ii = 1:n_nodes

    rectangle('Position', [xy(ii,1)-d/2 xy(ii,2)-d/2 d d], ...
        'Curvature', 1,'FaceColor', "k", ...
        'LineWidth', 0.1);
    text(xy(ii,1) + d, xy(ii,2) + d, num2str(ii));
    
    if (idb(ii, 1) > ndof)
        fill(xy(ii, 1) + triangolo_h(:, 1), xy(ii, 2) + triangolo_h(:, 2), 'k');
    end
    
    if (idb(ii, 2) > ndof)
        fill(xy(ii, 1) + triangolo_v(:, 1), xy(ii, 2) + triangolo_v(:, 2), 'k');
    end
    
    if (idb(ii, 3) > ndof)
        fill(xy(ii, 1) + triangolo_r(:, 1), xy(ii, 2) + triangolo_r(:, 2), 'k');
    end

end

axis equal
xlim([min(xy(:,1))-10*d max(xy(:,1))+10*d]);
ylim([min(xy(:,2))-10*d max(xy(:,2))+10*d]);

end