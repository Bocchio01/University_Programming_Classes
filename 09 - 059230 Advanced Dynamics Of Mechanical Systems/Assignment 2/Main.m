clc
clear variables
close all

%% Load structure data

filename = 'structure.inp';
[xy, nnod, idb, ndof, incid, l, gamma, m, EA, EJ, posiz, nbeam, pr] = load_structure(filename);

node_A_vertical = idb(9, 2);
node_C_vertical = idb(1, 2);
node_R_vertical = idb(15,2);

%% Assemble mass and stiffness matrices

[M, K] = assembly(incid, l, m, EA, EJ, gamma, idb);
C = 1e-1*M + 2.0e-4*K; % Damping matrix

M_FF = M(1:ndof, 1:ndof);
C_FF = C(1:ndof, 1:ndof);
K_FF = K(1:ndof, 1:ndof);

%% Compute the natural frequencies and vibration modes

[mode_shapes, omega_square] = eig(M_FF\K_FF); 
omega_nat = sqrt(diag(omega_square));

[omega_nat, omega_idx] = sort(omega_nat);
mode_shapes = mode_shapes(:, omega_idx);

omega_vet = linspace(0, ceil(10 * omega_nat(1)), 1000);

clear omega_square


%% FRF using "Direct (Lagrangian) Approach"

F = zeros(ndof, 1);

F(node_A_vertical) = 1;

X_direct = zeros(size(M_FF, 1), length(omega_vet));
for ii = 1:length(omega_vet)
    X_direct(:, ii) = (-omega_vet(ii)^2 * M_FF + 1i*omega_vet(ii) * C_FF + K_FF) \ F;
end 


%% FRF using "Modal Superposition Approach"
% To observe the approximation introduced, we adopt only 2 modes

Phi = mode_shapes(:, 1:2);

Mmod = Phi' * M(1:ndof, 1:ndof) * Phi;
Kmod = Phi' * K(1:ndof, 1:ndof) * Phi;
Cmod = Phi' * C(1:ndof, 1:ndof) * Phi;
Fmod = Phi' * F;

X_modal = zeros(size(Mmod, 1), length(omega_vet));
for ii = 1:length(omega_vet)
    X_modal(:, ii) = (-omega_vet(ii)^2 * Mmod + 1i*omega_vet(ii) * Cmod + Kmod) \ Fmod;
end

X_modal = Phi * X_modal;

F(node_A_vertical) = 0;


%% FRF between external F and reaction forces (Direct approach)

M_CF = M(ndof+1:end,1:ndof);
C_CF = C(ndof+1:end,1:ndof);
K_CF = K(ndof+1:end,1:ndof);

F(node_C_vertical) = 1;

Reactions_forces = zeros(size(M_CF, 1), length(omega_vet));
for ii=1:length(omega_vet)
    X_direct(:, ii) = (-omega_vet(ii)^2 * M_FF + 1i*omega_vet(ii) * C_FF + K_FF) \ F;
    Reactions_forces(:, ii) = (-omega_vet(ii)^2 * M_CF + 1i*omega_vet(ii) * C_CF + K_CF) * X_direct(:, ii);
end

FRF_RV1 = Reactions_forces(node_R_vertical - ndof, :);


%% Static response of the structure considering g force field (Direct approach)

FGa = zeros(3*nnod, 1);

for ii = 1:nbeam
    
    p0 = -9.81 * m(ii);
    gammaii = gamma(ii);
    
    p0G = [0 p0]';
    Lk = l(ii);

    p0L = [
        cos(gammaii) sin(gammaii);
        -sin(gammaii) cos(gammaii)
        ]*p0G;

    FkL = [Lk/2 0 0 Lk/2 0 0]' * p0L(1) + ...
    [0 ; Lk/2; Lk^2/12; 0 ; Lk/2; -Lk^2/12]*p0L(2);

    FkG = [
        cos(gammaii) -sin(gammaii) 0 0 0 0;
        sin(gammaii) cos(gammaii) 0 0 0 0;
        0 0 1 0 0 0;
        0 0 0 cos(gammaii) -sin(gammaii) 0;
        0 0 0 sin(gammaii) cos(gammaii) 0;
        0 0 0 0 0 1
        ]*FkL;

    Ek = zeros(6,3*nnod);
    
    Ek(1:6, incid(ii, 1:6)) = 1;

    FGa = FGa + Ek' * FkG;

end

F0a = FGa(1:ndof);

% Displacement with method A

Xa=K_FF\F0a;

% Max deflection
X_free_a=[Xa(1:33,1);0;0;Xa(34:40,1);0;0;Xa(41:end)];
X_Ha=X_free_a(1:3:end)+xy(1:end,1);
X_Va=X_free_a(2:3:end)+xy(1:end,2);
XX_a=[X_Ha,X_Va];
deflect_xa=X_free_a(1:3:end);
deflect_ya=X_free_a(2:3:end);
max_def_a=[max(abs(deflect_xa)),max(abs(deflect_ya))];

%% B-Acceleration Approach
x_dotdot=zeros(ndof,1);
x_dotdot(idb(:,2))=-9.81;

Fnodal=zeros(3*nbeam,1);
Fnodal=M*x_dotdot;
Fnodal = Fnodal(1:ndof,1);

%Displacement with method B
Xb=K_FF\Fnodal;

% Max deflection
X_free_b=[Xb(1:33,1);0;0;Xb(34:40,1);0;0;Xb(41:end)];
X_Hb=X_free_b(1:3:end)+xy(1:end,1);
X_Vb=X_free_b(2:3:end)+xy(1:end,2);
XX_b=[X_Hb,X_Vb];
deflect_xb=X_free_b(1:3:end);
deflect_yb=X_free_b(2:3:end);
max_def_b=[max(abs(deflect_xb)),max(abs(deflect_yb))];



%% 7- Vertical displacement time history of point A
% Calculate the vertical displacement time history of point A, taking into account a 
% moving load traveling between points D and A.

% Velocity profile
L_D_A=0:0.12:24; % [m]
t_D_A=0:0.1:20; % [s]
v_max=1; %[m/s]
v=zeros(1,100);
v(1)=0;

a=v_max/6;
for ii=2:61
    v(ii)=a*t_D_A(ii);
end
for ii=62:141
    v(ii)=v_max;
end
for ii=142:201
    v(ii)=v_max-a*(t_D_A(ii)-t_D_A(141));
end
figure
plot(L_D_A,v)
%%
Load=1;
mode_D_A=mode_shapes(19:27,:);


%% Plots

reset(0)
set(0, 'DefaultFigureNumberTitle', 'off');
set(0, 'DefaultFigureWindowStyle', 'docked');

plot_structure(posiz, l, gamma, xy, pr, idb, ndof);


figure_mode_shapes = figure('Name', 'Firsts mode shapes');
tiledlayout(2, 2);

for ii = 1:4
    nexttile

    plot_deformed(mode_shapes(:, ii), 2, incid, l, gamma, posiz, idb, xy)
    
    title(['Mode shape ' num2str(ii) '@\omega_0=' num2str(omega_nat(ii)) ' [rad/s]'])
    legend('Undeformed shape', 'Deformed shape')
    xlabel('Length [m]')
    ylabel('Height [m]')
end


figure_FRF_examples = figure('Name', 'FRF examples of the structure');
tiledlayout(2, 2);

interrogation_points = [idb(9, 2) idb(14, 1)];
interrogation_labels = [
    "Vertical Displacement of A"
    "Horizontal Displacement of B"
    ];

for point_idx = 1:length(interrogation_points)

    FRF_abs = nexttile(point_idx);
    hold on
    grid on

    semilogy(omega_vet / (2*pi), abs(X_direct(interrogation_points(point_idx), :)))
    
    set(gca, 'YScale', 'log');

    title(['FRF: ' interrogation_labels(point_idx) ' caused by Vertical force in A' ])
    xlabel('Frequency [Hz]')
    ylabel('|FRF|')
    

    FRF_angle = nexttile(point_idx + 2);
    hold on
    grid on

    plot(omega_vet / (2*pi), angle(X_direct(interrogation_points(point_idx), :)))
    
    xlabel('Frequency [Hz]')
    ylabel('Phase [rad]')

    linkaxes([FRF_abs FRF_angle], 'x');

end


figure_direct_vs_modal_approach = figure('Name', 'Direct (Lagrangian) vs. Modal Superposition Approach');
tiledlayout(2, 1)


FRF_abs = nexttile;
hold on
grid on

semilogy(omega_vet / (2*pi), abs(X_direct(interrogation_points(end), :)))
semilogy(omega_vet / (2*pi), abs(X_modal(interrogation_points(end), :)))

set(gca, 'YScale', 'log');

title(['FEM vs Modal' interrogation_labels(end) ' caused by Vertical force in A' ])
xlabel('Frequency [Hz]')
ylabel('|FRF|')
legend('Direct (FEM)', 'Modal Superpostion (considering first 2 modes)')


FRF_angle = nexttile;
hold on
grid on

plot(omega_vet / (2*pi), angle(X_direct(interrogation_points(end), :)))
plot(omega_vet / (2*pi), angle(X_modal(interrogation_points(end), :)))

xlabel('Frequency [Hz]')
ylabel('Phase [rad]')
legend('Direct (FEM)', 'Modal Superpostion (considering first 2 modes)')

linkaxes([FRF_abs FRF_angle], 'x');

%%

figure
subplot(2,1,1)
semilogy(0:0.01:8,abs(FRF_RV1),'LineWidth',1.5)
title('FRF: Vertical Force in C-Axial Force in O_2')
xlabel('f [Hz]')
ylabel('|FRF|')
grid on
subplot(2,1,2)
plot(0:0.01:8,angle(FRF_RV1),'LineWidth',1.5)
xlabel('f [Hz]')
ylabel('Phase [rad]')
grid on

% Comparison plots
figure
subplot(2,1,1)
diseg2(Xa,10,incid,l,gamma,posiz,idb,xy)
title('Deformed shape due to self weight (Lagrange Approach)')
legend('Undeformed shape','Deformed shape')
xlabel('Length [m]')
ylabel('Height [m]')

subplot(2,1,2)
diseg2(Xb,10,incid,l,gamma,posiz,idb,xy)
title('Deformed shape due to self weight (Nodal acceleration)')
legend('Undeformed shape','Deformed shape')
xlabel('Length [m]')
ylabel('Height [m]')