function G_jk = compute_G_exp(xk, xj, omega_vet, x_vet, m, f_nat_vet, mode_shape)

m_i = zeros(1, length(f_nat_vet));
omega_nat_vet = 2 * pi * f_nat_vet;

G_jk = 0;

[~, xj_idx] = min(abs(x_vet - xj));
[~, xk_idx] = min(abs(x_vet - xk));

for ii = 1:length(f_nat_vet)

    m_i(ii) = trapz(x_vet, m .* mode_shape(:, ii).^2);
    eps = 1/100;

    G_jk = G_jk + ...
        ((mode_shape(xj_idx, ii)*-mode_shape(xk_idx, ii)) / m_i(ii)) ./ (-omega_vet.^2 + (2*eps*omega_nat_vet(ii)*1i).*omega_vet + omega_nat_vet(ii)^2);

end

end