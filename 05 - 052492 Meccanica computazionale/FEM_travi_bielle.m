clc;
clear variables;
close all;

%% Problem datas

n_beams = 2;
n_nodes = 3;

data = struct(...
    'n_beams', n_beams, ...
    'n_nodes', n_nodes, ...
    'material', struct(...
        'E', 80e3 * ones(n_beams, 1), ...
        'A', 100 * ones(n_beams, 1), ...
        'I', 833 * ones(n_beams, 1), ...
        'poisson', 0.3 * ones(n_beams, 1) ...
    ), ...
    'nodes', struct(...
        'coordinates', zeros(n_nodes, 2), ...
        'connections', zeros(2, 2), ...
        'constraints', NaN(n_nodes, 3) ...
    ), ...
    'loads', struct(...
        'concentrated', zeros(n_nodes, 3), ...
        'distributed', zeros(n_beams, 3), ...
        'thermal', zeros(n_beams, 2) ...
    ) ...
    );

data.nodes.coordinates = [
    0   0;
    50  0;
    100 0];

data.nodes.connections = [
    1 2;
    2 3];

data.nodes.constraints([1 3], [1 2]) = 0;

data.loads.concentrated(2, 2) = -100;


%% Reshape and DOC/DOF

data.nodes.constraints = reshape(data.nodes.constraints', [], 1);
data.loads.concentrated = reshape(data.loads.concentrated', [], 1);
data.loads.distributed = reshape(data.loads.distributed', [], 1);
data.loads.thermal = reshape(data.loads.thermal', [], 1);

dof = isnan(data.nodes.constraints);
doc = not(dof);


%% Matrices computation

Kg = zeros(length(dof), length(dof));
Fg = zeros(length(dof), 1);

Fg = Fg + reshape(data.loads.concentrated', [], 1);

for i = 1:data.n_beams
    nodes = data.nodes.connections(i,:);
    el = [(1:3) + (nodes(1)-1)*3 (1:3) + (nodes(2)-1)*3];

    deltaX = diff(data.nodes.coordinates(nodes, 1));
    deltaY = diff(data.nodes.coordinates(nodes, 2));

    L = norm([deltaX, deltaY]);

    R = computeR(deltaY / deltaX);

    K = computeK(data.material.E(i), data.material.A(i), data.material.I(i), L);

    Fd = computeFd(data.loads.distributed([1 2 3] + 3*(i-1)), L);
    Ft = computeFt(data.loads.thermal([1 2] + 2*(i-1)), data.material.E(i), data.material.A(i), data.material.I(i));

    K = R' * K * R;
    Fd = R' * Fd;
    Ft = R' * Ft;

    Kg(el, el) = Kg(el, el) + K;
    Fg(el) = Fg(el) + Fd + Ft;

end


%% Resolution of the system

Kg_ff = Kg(dof,dof);
Kg_fc = Kg(dof,doc);
Kg_cf = Kg(doc,dof);
Kg_cc = Kg(doc,doc);

Fg_f = Fg(dof);
Fg_c = Fg(doc);

U_c = data.nodes.constraints(doc);


U_f = Kg_ff \ (Fg_f - Kg_fc*U_c);
S_c = Kg_cf*U_f + Kg_cc*U_c - Fg_c;

Ug = zeros(length(dof), 1);
Ug(dof) = U_f;
Ug(doc) = U_c;

Sg = zeros(length(dof), 1);
Sg(doc) = S_c;


%% Internal action

s = [0:.01:1];
N = zeros(data.n_beams, length(s));
T = zeros(data.n_beams, length(s));
M = zeros(data.n_beams, length(s));

for i = 1:data.n_beams
    nodes = data.nodes.connections(i,:);
    el = [(1:3) + (nodes(1)-1)*3 (1:3) + (nodes(2)-1)*3];

    deltaX = diff(data.nodes.coordinates(nodes, 1));
    deltaY = diff(data.nodes.coordinates(nodes, 2));

    L = norm([deltaX, deltaY]);

    R = computeR(deltaY / deltaX);

    K = computeK(data.material.E(i), data.material.A(i), data.material.I(i), L);

    Fd = computeFd(data.loads.distributed([1 2 3] + 3*(i-1)), L);
    Ft = computeFt(data.loads.thermal([1 2] + 2*(i-1)), data.material.E(i), data.material.A(i), data.material.I(i));

    K = R' * K * R;
    Fd = R' * Fd;
    Ft = R' * Ft;

    U = R * Ug(el);
    S = K*U - Fd - Ft;
    N(i,:) = -S(1)*(1-s) + S(4)*s;
    T(i,:) =  S(2)*(1-s) - S(5)*s;
    M(i,:) = -S(3)*(1-s) + S(6)*s - s.*(1-s)*data.loads.distributed(2 + 3*(i-1))*L^2/2;
end


%% Plots

amplification = 100;
Ug_plot = Ug * amplification;


nexttile
hold on
grid on

plot(data.nodes.coordinates(:,1), ...
    data.nodes.coordinates(:,2), ...
    'bx-', ...
    'LineWidth', 2, ...
    'MarkerSize', 2)
plot(data.nodes.coordinates(:,1) + Ug_plot(1:3:end), ...
    data.nodes.coordinates(:,2) + Ug_plot(2:3:end), ...
    'ro-', ...
    'LineWidth', 2, ...
    'MarkerSize', 2)

legend('Struttura originale','Struttura deformata')
xlabel('x (m)')
ylabel('y (m)')
title('Struttura deformata')
axis equal


for action = {N T M}

    nexttile
    hold on
    grid on

    plot(data.nodes.coordinates(:,1), ...
        data.nodes.coordinates(:,2), ...
        'bx-', ...
        'LineWidth', 2, ...
        'MarkerSize', 2)

    for i = 1:data.n_beams

        nodes = data.nodes.connections(i,:);
    
        deltaX = diff(data.nodes.coordinates(nodes, 1));
        deltaY = diff(data.nodes.coordinates(nodes, 2));
    
        L = norm([deltaX, deltaY]);
    
        R = computeR(deltaY / deltaX);

        Diagram_coords = R(1:2, 1:2)' * [s * L; -action{1}(i,:)];
        A_coords = data.nodes.coordinates(nodes(1), :);
        B_coords = data.nodes.coordinates(nodes(2), :);

        xPoints = [B_coords(1), A_coords(1), A_coords(1) + Diagram_coords(1,:), B_coords(1)];
        yPoints = [B_coords(2), A_coords(2), A_coords(2) + Diagram_coords(2,:), B_coords(2)];
        
        fill(xPoints, yPoints, 'r-');
    
    end

    title('Diagramma')

end



%% Functions

function [K]  = computeK(E, A, I, L)

K = [E*A/L 0 0 -E*A/L 0 0;
    0 12*E*I/L^3 6*E*I/L^2 0 -12*E*I/L^3 6*E*I/L^2;
    0 6*E*I/L^2 4*E*I/L 0 -6*E*I/L^2 2*E*I/L;
    -E*A/L 0 0 E*A/L 0 0;
    0 -12*E*I/L^3 -6*E*I/L^2 0 12*E*I/L^3 -6*E*I/L^2;
    0 6*E*I/L^2 2*E*I/L 0 -6*E*I/L^2 4*E*I/L];

end

function [R]  = computeR(alpha)

cosine = cos(alpha);
sine = sin(alpha);

R = [cosine sine 0 0 0 0;
    -sine cosine 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 cosine sine 0;
    0 0 0 -sine cosine 0;
    0 0 0 0 0 1];

end

function [Fd]  = computeFd(loads, L)

Fp=[loads(1)*L/2, 0, 0, loads(1)*L/2, 0, 0]';
Fq=[ 0, loads(2)*L/2, loads(2)*L^2/12, 0, loads(2)*L/2, -loads(2)*L^2/12]';
Fm=[0, -loads(3), 0, 0, loads(3), 0]';

Fd = Fp + Fq + Fm;

end

function [Ft]  = computeFt(thermal, E, A, I)

Fe=[-E*A*thermal(1), 0, 0, E*A*thermal(1), 0, 0]';
Fc=[0, 0, -E*I*thermal(2), 0, 0, E*I*thermal(2)]';

Ft = Fe + Fc;

end
