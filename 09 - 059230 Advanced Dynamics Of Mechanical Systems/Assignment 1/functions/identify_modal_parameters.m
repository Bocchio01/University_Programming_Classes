function [omega_num, xi_num, A_num, RL_num, RH_num] = identify_modal_parameters(f_range_vet, G_exp)

switch(2)
    
    case 1
        % Parameter_vet = [omega xi A B_real B_imag];
        G_num = @(parameter_vet, omega) ...
            (parameter_vet(3))./(-omega.^2 + 2i*parameter_vet(2).*parameter_vet(1).*omega + parameter_vet(1).^2) + ...
            (parameter_vet(4) + 1i*parameter_vet(5));

    case 2
        % Parameter_vet = [omega xi A RL_real RL_imag RH_real RH_imag];
        G_num = @(parameter_vet, omega) ...
            (parameter_vet(3))./(-omega.^2 + 2i*parameter_vet(2).*parameter_vet(1).*omega + parameter_vet(1).^2) + ...
            (parameter_vet(4) + 1i*parameter_vet(5)) ./ omega .^ 2 + ...
            (parameter_vet(6) + 1i*parameter_vet(7));

    otherwise
        error('Model for G_{num} unknown');

end


minimization_function = @(parameter_vet) 0;
omega = @(frequency) 2 * pi * frequency;

omega_range_vet = omega(f_range_vet);

G_num_hat = @(parameter_vet) G_num(parameter_vet, omega_range_vet);
G_num_real = @(parameter_vet) real(G_num_hat(parameter_vet));
G_num_imag = @(parameter_vet) imag(G_num_hat(parameter_vet));


for idx = 1:size(G_exp, 1)

    [~, max_idx] = max(abs(G_exp(idx, :)));

    f_num_nat(idx) = f_range_vet(max_idx);

    % Slope method to extrapolate modal parameters
    d_omega = omega(f_range_vet(max_idx + 1) - f_range_vet(max_idx - 1));
    d_G_angle = angle(G_exp(idx, max_idx + 1)) - angle(G_exp(idx, max_idx - 1));

    xi(idx) = - 1 / (omega(f_num_nat(idx)) * (d_G_angle/d_omega));
    
    % A(idx) = 1i * (2 * G_exp(idx, max_idx) * omega(f_num_nat(idx))^2 * xi(idx));
    A(idx) = - imag(2 * G_exp(idx, max_idx) * omega(f_num_nat(idx))^2 * xi(idx));

    G_exp_hat = G_exp(idx, :);
    G_exp_real = real(G_exp_hat);
    G_exp_imag = imag(G_exp_hat);

    minimization_function = @(parameter_vet) ...
        minimization_function(parameter_vet) + ...
        sum((G_exp_real - G_num_real(parameter_vet)) .^ 2 + (G_exp_imag - G_num_imag(parameter_vet)) .^ 2);

end

zero_vet = zeros(length(f_num_nat(:)), 1);
X0 = [omega(f_num_nat(:)) xi(:) A(:) zero_vet zero_vet zero_vet zero_vet];

tic
X = lsqnonlin( ...
    @(parameter_vet) minimization_function(parameter_vet), ...
    X0, ...
    [], ...
    [], ...
    optimoptions('lsqnonlin', 'MaxIterations', 1e8, 'Algorithm', 'levenberg-marquardt'));
toc

omega_num = X(1, 1);
xi_num = mean(X(:, 2));
A_num = X(:, 3);
RL_num = X(:, 4) + 1i * X(:, 5);
RH_num = X(:, 6) + 1i * X(:, 7);

end