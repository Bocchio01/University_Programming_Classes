function [d_PCA, t_PCA_lo, t_PCA, t_PCA_up] = analyze_with_PCA(frequencies_mat, b, n, p)
% Computes the Principal Component Analysis (PCA) based damage assessment 
% for a given dataset and determines the damage thresholds.
%
% [d_PCA, t_PCA_lo, t_PCA, t_PCA_up] = analyze_with_PCA(frequencies_mat, b, p)
% computes the PCA-based damage indices for each row in the frequencies_mat 
% and returns the results in d_PCA. It also calculates the damage thresholds 
% t_PCA_lo, t_PCA, and t_PCA_up based on the training data.
%
% Inputs:
%   frequencies_mat - Matrix of frequency data where each row
%       represents a different time point.
%   b - Number of baseline samples used for training.
%   p - Number of principal components to retain.
%
% Outputs:
%   d_PCA - Vector containing the PCA-based damage indices for each row
%       in the frequencies_mat.
%   t_PCA_lo - Lower bound of the PCA damage threshold.
%   t_PCA - PCA damage threshold calculated based on the baseline data.
%   t_PCA_up - Upper bound of the PCA damage threshold.
%
% The function follows these steps:
% 1. Extracts the baseline data (first b rows of frequencies_mat).
% 2. Computes the PCA damage thresholds (t_PCA_lo, t_PCA, t_PCA_up).
% 3. Iterates through each row of frequencies_mat to compute the PCA-based damage indices.


assert(nargin == 4, 'All arguments are required');
assert(size(frequencies_mat, 1) > b, 'Training dataset can not be larger than the whole dataset.');

F0 = frequencies_mat(1:b, :);

% Training phase
Z0_hat = apply_PCA(F0, p);
[P095, t_PCA_lo, t_PCA, t_PCA_up] = compute_t_PCA(F0, p);

% Monitoring phase
d_PCA = zeros(size(frequencies_mat, 1), 1);
for idx = 1:size(frequencies_mat, 1)

    F_star = frequencies_mat(max(idx-n, 1):idx, :);
    F0_star = [F0; F_star];

    Z0_star_hat = apply_PCA(F0_star, p);

    d = compute_MSD(Z0_star_hat(1:b, :), Z0_hat);
    
    d_PCA(idx) = sum(d(1:b) > P095) / b;

end

end

