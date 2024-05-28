function [f_spectrum_normalized, f_vet] = fft_normalized(data, f_sampling)
% This function does the normalisation of the output of the fft function
% Input:
%   - data: input data matrix with size [r,c], with r samples and c signals
%   - frequency_sampling: sampling frequency
% Output:
%   - f_spectrum_normalized: normalized spectrum (positive frequencies)
%   - f_vet: frequency vector

N_sampling = length(data);
f_0 = f_sampling / N_sampling;

f_vet = (0:f_0:floor(N_sampling/2)*f_0)';
f_spectrum = fft(data, [], 1);

if (mod(N_sampling / 2, 1) == 0)

    f_spectrum_normalized(1, :) = f_spectrum(1, :) / N_sampling;
    f_spectrum_normalized(2:N_sampling/2, :) = f_spectrum(2:N_sampling/2, :) / (N_sampling/2);
    f_spectrum_normalized(N_sampling/2+1, :) = f_spectrum(N_sampling/2+1, :) / N_sampling;

else

    f_spectrum_normalized(1, :) = f_spectrum(1, :) / N_sampling;
    f_spectrum_normalized(2:(N_sampling+1)/2, :) = f_spectrum(2:(N_sampling+1)/2, :) / (N_sampling/2);

end

end