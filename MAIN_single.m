clc; clear; close all;

% definition of mer recording
fs       = 24000;     % sampling frequency
dt       = 1 / fs;    % time resolution
bin_size = 0.01;      % interval for converting spike time to binary process (second)

% get the spiking times
base_directory        = 'E:\Master Thesis\GPi Besta AK Thesis\Analysis\Paz1\GPI dx\posteriore\-10 mm (detected)\times_00000122_02_01_6_0002_-10000merged.mat';
[sua, segment_length] = get_spiking_times(base_directory);
spiking_times         = sua(1).spiking_times./1000;  % in seconds
N                     = length(spiking_times);
time_vector           = 0: bin_size: segment_length-bin_size;

% get spike train
[spike_train, spike_count] = spiketime_2_spiketrain(spiking_times, bin_size, segment_length);

% get spike train
[spike_train, spike_count] = spiketime_2_spiketrain(spiking_times, bin_size, segment_length);
raster_plot(spike_train', time_vector, bin_size);

alpha = 4;
beta  = N ^ (4/5);

[ins_firing_rate, h] = BAKS(spiking_times, time_vector', alpha, beta);

firing_rate_plot(spike_train', time_vector, bin_size, ins_firing_rate);

firing_pattern = get_firing_pattern(spiking_times, N-1);
firing_rate    = firing_pattern(1);
firing_rate_mean = mean(ins_firing_rate);



% find isi and isi probabilities
[isi, isi_per_bin, isi_probs, bin_centers] = isi_probability(spiking_times, bin_size);

cv = coefficient_of_variation(isi);
lv = local_variation(isi);

% [mu, lambda, isi_pdf]                      = isi_fit_inverse_gaussian(isi, bin_centers);
% 
% figure; bar(bin_centers, isi_probs);
%         hold on;
%         plot(bin_centers, isi_pdf, 'LineWidth', 2);
%         xlabel("ISI [ms]"); ylabel("probability"); 
%         title(strcat("ISI Probabilities (bin size ", string(bin_size), " ms)"));
%         legend('ISI bins', strcat('Fitted Inverse Gaussian Distribution (mu:', string(mu) , ' | lambda:', string(lambda),')'));
%         hold off;
%         
% % ks_result = kstest(isi_pdf, isi_probs, length(isi));
