function [d_MSD, t_MSD] = analyze_with_MSD(frequencies_mat, b, F0_contains_damage)
% Computes the Mahalanobis Square Distance (MSD) for a given dataset and 
% determines the damage threshold.
%
% [d_MSD, t_MSD] = analyze_with_MSD(frequencies_mat, b, F0_contains_damage)
% computes the MSD for each row in the frequencies_mat and returns the
% results in d_MSD. It also calculates the damage threshold t_MSD based
% on the training data.
%
% Inputs:
%   frequencies_mat - Matrix of frequency data where each row
%       represents a different time point.
%   b - Number of baseline samples used for training.
%   F0_contains_damage  - Boolean flag indicating whether the initial
%       baseline data contains damage.
%
% Outputs:
%   d_MSD - Vector containing the MSD values for each row
%       in the frequencies_mat.
%   t_MSD - Damage threshold calculated based on the baseline data.
%
% The function follows these steps:
% 1. Extracts the baseline data (first b rows of frequencies_mat).
% 2. Computes the MSD damage threshold (t_MSD).
% 3. Iterates through each row of frequencies_mat to compute the MSD.


assert(nargin >= 2, 'frequencies_mat and b are required');
assert(size(frequencies_mat, 1) > b, 'Training dataset can not be larger than the whole dataset.');

F0 = frequencies_mat(1:b, :);

% Training phase
t_MSD = compute_t_MSD(b, size(F0, 2), 1000, F0_contains_damage);

% Monitoring phase
d_MSD = compute_MSD(frequencies_mat, F0);

end

