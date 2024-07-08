function [P095, t_PCA_lo, t_PCA, t_PCA_up] = compute_t_PCA(F0, p)
% Computes the Principal Component Analysis (PCA) damage thresholds.
%
% [P095, t_PCA_lo, t_PCA, t_PCA_up] = compute_t_PCA(F0, p) computes the
% 95th percentile (P095) and its lower (t_PCA_lo) and upper (t_PCA_up)
% bounds of the MSD distribution based on PCA analysis. It also calculates
% the mean damage threshold (t_PCA) for the given baseline data.
%
% Inputs:
%   F0 - Baseline dataset.
%   p - Number of principal components to retain.
%
% Outputs:
%   P095 - 95th percentile of the MSD distribution.
%   t_PCA_lo - Lower bound of the MSD distribution.
%   t_PCA - Mean damage threshold.
%   t_PCA_up - Upper bound of the MSD distribution.
%
% The function first applies PCA to the baseline dataset F0, computes the
% Mahalanobis Squared Distance (MSD) between the projected dataset and
% itself, and fits a Gamma distribution to the MSD values. Then, it
% calculates the 95th percentile of the fitted distribution along with
% its lower and upper bounds. Finally, it computes the mean damage
% threshold (t_PCA) and its lower and upper bounds based on the 95th
% percentile values.
%
% Example:
%   F0 = randn(100, 10); % Baseline dataset
%   [P095, t_PCA_lo, t_PCA, t_PCA_up] = compute_t_PCA(F0, 3);


Z0_hat = apply_PCA(F0, p);

d0 = compute_MSD(Z0_hat, Z0_hat);

probability_distribution_obj = fitdist(d0, 'Gamma');

P095 = icdf(probability_distribution_obj, 0.95);
ci = paramci(probability_distribution_obj, 'Alpha', 0.05);

% Compute the upper and lower bounds for the 95th percentile
shape_lb = ci(1, 1);
scale_lb = ci(1, 2);
shape_ub = ci(2, 1);
scale_ub = ci(2, 2);

pd_lb = makedist('Gamma', 'a', shape_lb, 'b', scale_lb);
pd_ub = makedist('Gamma', 'a', shape_ub, 'b', scale_ub);

P095_LB = icdf(pd_lb, 0.95);
P095_UB = icdf(pd_ub, 0.95);

b = size(F0, 1);
t_PCA = sum(d0 > P095) / b;
t_PCA_up = sum(d0 > P095_LB) / b;
t_PCA_lo = sum(d0 > P095_UB) / b;

end

