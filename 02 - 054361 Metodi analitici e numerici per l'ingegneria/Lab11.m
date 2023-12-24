clc
clear variables
close all

%% Section 1
% diffusione_Dirichlet function

L = 1;
mu0 = 1;

u_ex = @(x) -sin(pi*x);
f = @(x) -pi^2 * sin(pi*x);

x = linspace(0, L, 1000);


% We evaluate the error of the Galerkian method knowing the exact solution
% in function of the h-paramether (discretization peace)

H = 1./(5 * 2.^[0:2:5]);

errL2 = [];

for h = H

    [K, B, M, F, xn] = FE_Dirichlet(L, h, mu0, 0, 0, f);

    % [L, U, u_galerkin] = thomas(K, F);
    u_galerkin = K\F;
    u_galerkin = [0; u_galerkin; 0];
    xn = [0 xn L];

    errL2 = [errL2 sqrt(simpcomp(0, L, 1000, @(x) (u_ex(x) - interp1(xn, u_galerkin, x)).^2))];

    nexttile
    hold on
    grid on
    plot(x, u_ex(x), 'k', ...
        xn, u_galerkin, '-or', ...
        'LineWidth', 2)
    title(sprintf('Comparison solutions, h=%0.5f', h))
    legend('Exact solution', 'Galerkin solution')

end

nexttile
hold off
loglog(H, errL2, '-k', ...
    H, H, '--r', ...
    H, H.^2, '--g', ...
    'LineWidth', 2)
grid on
title('Error validation')
legend('ErrL2', 'H', 'H^2')


%% Section 2
% We change the f(x) in the initial problem and we re-calculate all the
% solution with the same procedure as before

u_ex = @(x) (1/sqrt(3) - 2/3) .* x .* (x < 1/sqrt(3)) + ...
    ((x.^2)/2 - 2/3*x + 1/6)  .* (x >= 1/sqrt(3));

f = @(x) - heaviside(x - 1/sqrt(3));

H = 1./(5 * 2.^[0:2:5]);

errL2 = [];

for h = H

    [K, B, M, F, xn] = FE_Dirichlet(L, h, mu0, 0, 0, f);

    % [L, U, u_galerkin] = thomas(K, F);
    u_galerkin = K\F;
    u_galerkin = [0; u_galerkin; 0];
    xn = [0 xn L];

    errL2 = [errL2 sqrt(simpcomp(0, L, 1000, @(x) (u_ex(x) - interp1(xn, u_galerkin, x)).^2))];

    nexttile
    hold on
    grid on
    plot(x, u_ex(x), 'k', ...
        xn, u_galerkin, '-og', ...
        'LineWidth', 2)
    title(sprintf('Comparison solutions, h=%0.5f', h))
    legend('Exact solution', 'Galerkin solution')

end

nexttile
hold off
loglog(H, errL2, '-k', ...
    H, H, '--r', ...
    H, H.^2, '--g', ...
    'LineWidth', 2)
grid on
title('Error validation')
legend('ErrL2', 'H', 'H^2')


%% Section 3

L = 1;
mu0 = 1;
sigma0 = 1;

u_ex = @(x) sin(pi/2 * x);

f = @(x) (pi^2 + 4)/4 * sin(pi/2 * x);

H = 1./(5 * 2.^[0:2:5]);

errL2 = [];

for h = H

    [K, M, F, xn] = diffusionereazione_DirichletNeumann(L, h, mu0, sigma0, f);

    % [L, U, u_galerkin] = thomas(K, F);
    u_galerkin = (K+M)\F;
    u_galerkin = [0 u_galerkin'];

    errL2 = [errL2 sqrt(simpcomp(0, L, 1000, @(x) (u_ex(x) - interp1(xn, u_galerkin, x)).^2))];

    nexttile
    hold on
    grid on
    plot(x, u_ex(x), 'k', ...
        xn, u_galerkin, '-ob', ...
        'LineWidth', 2)
    title(sprintf('Comparison solutions, h=%0.5f', h))
    legend('Exact solution', 'Galerkin solution')

end

nexttile
hold off
loglog(H, errL2, '-k', ...
    H, H, '--r', ...
    H, H.^2, '--g', ...
    'LineWidth', 2)
grid on
title('Error validation')
legend('ErrL2', 'H', 'H^2')




