function Z0_hat  = apply_PCA(F, p)
% Applies Principal Components Analysis (PCA) to a given dataset.
%
% Z0_hat = apply_PCA(F, p) applies PCA to the dataset F and retains only 
% the principal components beyond the first p components. It returns the 
% transformed dataset Z0_hat.
%
% Inputs:
%   F - Dataset to be transformed.
%   p - Number of principal components to retain.
%
% Output:
%   Z0_hat - Transformed dataset after PCA.
%
% The function first centers the dataset F by subtracting the mean, then 
% performs Singular Value Decomposition (SVD) on the centered dataset to 
% obtain the principal components. It retains only the principal components 
% beyond the first p components and constructs the transformed dataset Z0_hat.
%
% Example:
%   F = randn(100, 10); % Input dataset
%   p = 3; % Number of principal components to discard
%   Z0_hat = apply_PCA(F, p);


C = F - mean(F);
[~, ~, V] = svd(C, 'econ');
Z0 = C * V;
Z0_hat = Z0(:, (p+1):end);

end

