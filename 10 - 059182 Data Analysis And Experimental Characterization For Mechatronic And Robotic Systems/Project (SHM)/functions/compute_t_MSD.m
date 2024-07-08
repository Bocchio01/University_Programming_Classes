function t_MSD = compute_t_MSD(b, m, trials, F0_contains_damage)
% Computes the Mahalanobis Squared Distance (MSD) damage threshold incrementally.
%
% t_MSD = compute_t_MSD(b, m, trials, F0_contains_damage) computes the MSD
% damage threshold incrementally based on a given number of trials. It returns
% the calculated damage threshold t_MSD.
%
% Inputs:
%   b - Number of baseline samples.
%   m - Number of dimensions (features).
%   trials - Number of trials to perform.
%   F0_contains_damage - Boolean flag indicating whether the baseline data
%       contains damage.
%
% Output:
%   t_MSD - MSD damage threshold.
%
% The function generates random samples, computes their MSD, and determines
% the 95th percentile of the maximum distances across trials. If the baseline
% data contains damage, the 95th percentile is directly used as the damage
% threshold. Otherwise, the threshold is adjusted based on the baseline size
% and the percentile value.
%
% Example:
%   t_MSD = compute_t_MSD(10, 5, 1000, true);


max_distances = zeros(trials, 1);

for trial_idx = 1:trials

    random_mat = randn(b, m);
    max_distances(trial_idx) = max(compute_MSD(random_mat, random_mat));

end

sorted_max_distances = sort(max_distances);

t_MSD_inc = sorted_max_distances(ceil(0.95 * trials));

if (F0_contains_damage)
    t_MSD = t_MSD_inc;
else
    t_MSD = ((b-1)*(b+1)^2*t_MSD_inc) / (b*(b^2-(b+1)*t_MSD_inc));
end

end