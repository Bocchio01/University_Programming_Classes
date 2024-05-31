clc
clear variables
close all

%% Data input and constant definition

filename = 'models/harbour_crane.inp';

[xy, nnod, idb, ndof, incid, l, gamma, m, EA, EJ, posiz, nbeam, pr] = load_structure(filename);

node_A_vertical = idb(9, 2);
node_C_vertical = idb(1, 2);
node_02_vertical = idb(15,2);


%% Assemble mass and stiffness matrices

[M, K] = assembly(incid, l, m, EA, EJ, gamma, idb);
C = 1e-1 * M + 2.0e-4 * K;

M_FF = M(1:ndof, 1:ndof);
C_FF = C(1:ndof, 1:ndof);
K_FF = K(1:ndof, 1:ndof);

M_CF = M(ndof+1:end, 1:ndof);
C_CF = C(ndof+1:end, 1:ndof);
K_CF = K(ndof+1:end, 1:ndof);

F_F = zeros(ndof, 1);


%% Natural frequencies, mode shapes and modal matrices

[mode_shapes, omega_square] = eig(M_FF\K_FF);
omega_nat = sqrt(diag(omega_square));

[omega_nat, omega_idx] = sort(omega_nat);
mode_shapes = mode_shapes(:, omega_idx);

omega_vet = 2*pi * linspace(0, 8, 1000);

Phi = mode_shapes(:, 1:5);
M_FF_modal = Phi' * M_FF * Phi;
C_FF_modal = Phi' * C_FF * Phi;
K_FF_modal = Phi' * K_FF * Phi;

clear omega_square


%% FRF using "Direct (Lagrangian) Approach"

F_F(node_A_vertical) = 1;

FRF_direct_approach = zeros(size(M_FF, 1), length(omega_vet));
for ii = 1:length(omega_vet)
    FRF_direct_approach(:, ii) = (-omega_vet(ii)^2 * M_FF + 1i*omega_vet(ii) * C_FF + K_FF) \ F_F;
end

F_F(node_A_vertical) = 0;


%% FRF using "Modal Superposition Approach"
% To observe the approximation introduced, we consider only 2 modes

F_F(node_A_vertical) = 1;

Phi_reduced = mode_shapes(:, 1:2);
M_FF_modal_reduced = Phi_reduced' * M_FF * Phi_reduced;
C_FF_modal_reduced = Phi_reduced' * C_FF * Phi_reduced;
K_FF_modal_reduced = Phi_reduced' * K_FF * Phi_reduced;
F_F_modal = Phi_reduced' * F_F;

FRF_modal_approach = zeros(size(M_FF_modal_reduced, 1), length(omega_vet));
for ii = 1:length(omega_vet)
    FRF_modal_approach(:, ii) = (-omega_vet(ii)^2 * M_FF_modal_reduced + 1i*omega_vet(ii) * C_FF_modal_reduced + K_FF_modal_reduced) \ F_F_modal;
end

FRF_modal_approach = Phi_reduced * FRF_modal_approach;

F_F(node_A_vertical) = 0;


%% FRF between external F and reaction forces (Direct approach)

F_F(node_C_vertical) = 1;

FRF_reactions_forces = zeros(size(M_CF, 1), length(omega_vet));
for ii=1:length(omega_vet)
    FRF_direct_approach(:, ii) = (-omega_vet(ii)^2 * M_FF + 1i*omega_vet(ii) * C_FF + K_FF) \ F_F;
    FRF_reactions_forces(:, ii) = (-omega_vet(ii)^2 * M_CF + 1i*omega_vet(ii) * C_CF + K_CF) * FRF_direct_approach(:, ii);
end

FRF_RV1 = FRF_reactions_forces(node_02_vertical - ndof, :);

F_F(node_C_vertical) = 0;


%% Static response of the structure considering \vec{g} force field (Direct approach)

% Displacement approach. Refer to Prof. Cocchetti's tables to check the
% coefficients of equivalent nodal loads due to a distributed one along
% the FEM element.
F_global = zeros(3*nnod, 1);

for ii = 1:nbeam
    
    [R, Q] = compute_rotational_matrices(gamma(ii));
    
    % Here we are negletting the possibility of a distributed momentum
    % load. Just distributed force loads are considered.
    elemental_distributed_load = R(1:2, 1:2)' * [0 -9.81 * m(ii)]';
    
    elemental_equivalent_nodal_load = [
        l(ii)/2 0
        0       l(ii)/2
        0       l(ii)^2/12
        l(ii)/2 0
        0       l(ii)/2
        0       -l(ii)^2/12
        ] * elemental_distributed_load;
    
    global_equivalent_nodal_load = Q * elemental_equivalent_nodal_load;
    
    F_global(incid(ii, :)) = F_global(incid(ii, :)) + global_equivalent_nodal_load;
    
end

X_gravity_displacement_approach = K_FF \ F_global(1:ndof);


% Acceleration approach.
x_dot_dot = zeros(ndof, 1);
x_dot_dot(idb(:, 2)) = -9.81;

F_nodal = M * x_dot_dot;

X_gravity_acceleration_approach = K_FF \ F_nodal(1:ndof);


%% Moving load and displacement time history of node A

x_vet = 0:0.12:24;
t_vet = 0:0.1:30;

% Trapezoidal motion control parameters computed by hand
a = (10/20)^2;
t1 = sqrt(16/a);
t3 = t1;
t2 = 2 / sqrt(a);
v = 8 / t2;

load_position = @(t) ...
    (t <= t1) .*                             (1/2 * a * t.^2) + ...
    (t > t1 & t <= (t1 + t2)) .*             (1/2 * a * t1^2 + v * (t - t1)) + ...
    (t > (t1 + t2) & t <= (t1 + t2 + t3)) .* (1/2 * a * t1^2 + v * t2 + v * (t - (t2 + t1)) - 1/2 * a * (t - (t1 + t2)).^2) + ...
    (t > (t1 + t2 + t3)) .*                  (1/2 * a * t1^2 + v * t2 + v * t3 - 1/2 * a * t3.^2);

Q_func = @(t) Phi' * compute_nodal_load(load_position(t), xy, idb, -9.81 * 40e3);

initial_conditions = [zeros(length(Q_func(0)), 1) zeros(length(Q_func(0)), 1)];
% initial_conditions = [zeros(length(Q_func(0)), 1) K_FF_modal \ Q_func(0)];

[t, z] = ode45( ...
    @(t, z) EquationOfMotion(t, z, M_FF_modal, C_FF_modal, K_FF_modal, Q_func), ...
    [0 max(t_vet)], ...
    initial_conditions, ...
    odeset('RelTol', 1e-6, 'AbsTol', 1e-6));

X_moving_load = Phi * z(:, size(Phi, 2)+1:end)';


%% Plots

reset(0)
set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

plot_struct.flags = true * [0 0 0 1];
% plot_struct.export_path = 'latex/img/MATLAB';
plot_struct.data = cell(0);
scale_factor = 10;

if (plot_struct.flags(1))
    run("figures\fig_01_undeformed_structure.m");
end

if (plot_struct.flags(2))
    run("figures\fig_02_mode_shapes.m");
end

if (plot_struct.flags(3))
    run("figures\fig_03_FRFs.m");
end

if (plot_struct.flags(4))
    run("figures\fig_04_responses.m");
end

if (isfield(plot_struct, 'export_path'))
    for plot_idx = 1:numel(plot_struct.data)
    
        current_plot = plot_struct.data{plot_idx};
        tile = current_plot{1};
        local_path = current_plot{2};

        filename = [plot_struct.export_path local_path '.png'];
        exportgraphics(tile, filename, 'Resolution', 300);
    
    end
end



%% Functions

function [z_dot] = EquationOfMotion(t, z, M_FF_modal, C_FF_modal, K_FF_modal, Q_func)

N_considered_modes = size(K_FF_modal, 1);

q_dot = z(1:N_considered_modes, 1);
q = z(N_considered_modes + (1:N_considered_modes), 1);

% M * x_dot_dot + C * x_dot + K * x = F(t) -> Modal coordinates -> q
q_dot_dot = M_FF_modal \ (Q_func(t) - C_FF_modal * q_dot - K_FF_modal * q);

z_dot(1:N_considered_modes, 1) = q_dot_dot;
z_dot(N_considered_modes + (1:N_considered_modes), 1) = q_dot;

end


function F_nodal = compute_nodal_load(load_position, xy, idb, F0)
% Strictly related to our case at hand, nodes D to A.

F_nodal = zeros(71, 1);

if (load_position + xy(7, 1) < xy(8, 1))
    
    L = xy(8, 1) - xy(7, 1);
    xi = (load_position) / L;
    
    N1 = 1 - xi;
    N2 = xi;
    
    F_nodal(idb(7, 2)) = F0 * N1;
    F_nodal(idb(8, 2)) = F0 * N2;
    
else
    
    L = xy(9, 1) - xy(8, 1);
    xi = (load_position - (xy(8, 1) - xy(7, 1))) / L;
    
    N1 = 1 - xi;
    N2 = xi;
    
    F_nodal(idb(8, 2)) = F0 * N1;
    F_nodal(idb(9, 2)) = F0 * N2;
    
end

end







