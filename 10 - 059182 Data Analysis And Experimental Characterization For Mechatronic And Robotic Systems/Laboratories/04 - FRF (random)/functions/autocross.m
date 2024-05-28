function [autocross_mean, f_vet] = autocross(data, f_sampling, hann_window, overlapping)
% Auto / cross average spectrum
%
% [Output, mediacomp, frequencies] = autocross(data1, data2, fsamp, N_win, N_OL, Win)
%
% data: two columns matrice containg the time histories of the signals to be analyzed
% f_sampling: sampling frequency
% hann_window: time window used to weight the data
% overlapping: overlapping percentace between the two time records

N_hann = length(hann_window);
N_overlapping = floor(overlapping * N_hann);

N_sampling    = size(data, 1);
f_0           = f_sampling / N_hann;
f_vet         = 0:f_0:floor(N_hann/2)*f_0;
N_frequencies = length(f_vet);

N_records = fix((N_sampling - N_overlapping) / (N_hann - N_overlapping));
autocross = zeros(N_frequencies, N_records);

for record_idx = 1:N_records

    start_idx = 1 + (record_idx - 1) * (N_hann - N_overlapping);
    end_idx = start_idx + (N_hann - 1);

    spectra_1 = fft(hann_window .* data(start_idx:end_idx, 1)) ./ N_hann;
    spectra_2 = fft(hann_window .* data(start_idx:end_idx, 2)) ./ N_hann;

    % Here we are negletting the negative frequency 
    autocross(:, record_idx) = conj(spectra_1(1:N_frequencies)) .* spectra_2(1:N_frequencies);

end

% Here we compensate the module of the (only positive) spectra
if (mod(N_hann / 2, 1) == 0)
    autocross(2:end-1, :) = 2 * autocross(2:end-1, :);
else
    autocross(2:end, :) = 2 * autocross(2:end, :);
end

autocross_mean = mean(autocross(1:N_frequencies, :), 2);

end