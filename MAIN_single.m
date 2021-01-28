clc; clear; close all;

% definition of mer recording
fs        = 24000;     % sampling frequency
dt        = 1 / fs;    % time resolution
bin_size  = 1;        % interval for converting spike time to binary process (second)

% get the spiking times
base_directory        = 'E:\Master Thesis\GPi Besta AK Thesis\Analysis\Paz3\GPI sx\anteriore\Results\Std Min Threshold = 4\-4 mm (detected)\times_00000106_01_01_5_0012_-04000.mat';
[sua, segment_length] = get_spiking_times(base_directory);
spiking_times         = sua(1).spiking_times;  % in seconds
N                     = length(spiking_times);

% get spike train
[spike_train, spike_count] = spiketime_2_spiketrain(spiking_times, bin_size, segment_length);

% find isi and isi probabilities
[isi, isi_per_bin, isi_probs, bin_centers] = isi_probability(spiking_times, bin_size);
[mu, lambda, isi_pdf]                      = isi_fit_inverse_gaussian(isi, bin_centers);

figure; bar(bin_centers, isi_probs);
        hold on;
        plot(bin_centers, isi_pdf, 'LineWidth', 2);
        xlabel("ISI [ms]"); ylabel("probability"); 
        title(strcat("ISI Probabilities (bin size ", string(bin_size), " ms)"));
        legend('ISI bins', strcat('Fitted Inverse Gaussian Distribution (mu:', string(mu) , ' | lambda:', string(lambda),')'));
        hold off;
        
kstest(isi_pdf, isi_probs, length(isi));


ime  = 0:dt:10;
time  = time(1:end-1)';
alpha = lambda;
beta  = mu;

% [firing_rate, h]      = BAKS(spiking_times, time, alpha, beta);