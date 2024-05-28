function d_vet = compute_MSD(Z, Z0)
% Computes the Mahalanobis Square Distance (MSD) between two datasets.
%
% d_vet = compute_MSD(Z, Z0) computes the MSD between dataset Z and the
% baseline dataset Z0. It returns the MSD values in d_vet.
%
% Inputs:
%   Z - Dataset for which MSD is calculated.
%   Z0 - Baseline dataset.
%
% Output:
%   d_vet - Vector containing the MSD values.
%
% The function first computes the mean (mu) and covariance (C) of the
% baseline dataset Z0. It then calculates the Mahalanobis distance for each
% sample in dataset Z using the formula:
%
%   d_vet = sum(((Z - mu) * inv(C)) .* (Z - mu), 2);
%
% Example:
%   Z = randn(100, 5); % Sample dataset
%   Z0 = randn(10, 5); % Baseline dataset
%   d_vet = compute_MSD(Z, Z0);


mu = mean(Z0, 1);
C = cov(Z0);

d_vet = sum(((Z - mu) / C) .* (Z - mu), 2);

end