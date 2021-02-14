clc; clear; close all;

% definition of mer recording
fs       = 24000;     % sampling frequency
dt       = 1 / fs;    % time resolution
bin_size = 0.010;     % interval for converting spike time to binary process (second)

% get the spiking times
base_directory        = 'E:\Master Thesis\GPi Besta AK Thesis\Analysis\Paz1\GPI dx\anteriore\-7 mm (detected - ambiguous)\times_00000122_02_01_5_0005_-07000.mat';
[sua, segment_length] = get_spiking_times(base_directory);
spiking_times         = sua(1).spiking_times./1000;  % in seconds
N                     = length(spiking_times);
time_vector           = 0: bin_size: segment_length-bin_size;

% get spike train
[spike_train, spike_count] = spiketime_2_spiketrain(spiking_times, bin_size, segment_length);

% raster_plot(spike_train', time_vector, bin_size);

alpha = 4;
beta  = N ^ (4/5);
[ins_firing_rate, h] = BAKS(spiking_times, time_vector', alpha, beta);

% firing_rate_plot(spike_train', time_vector, bin_size, ins_firing_rate);

% find isi and isi probabilities
[isi, isi_per_bin, isi_probs, bin_centers] = isi_probability(spiking_times, bin_size);
%--------------------------------------------------------------------------
firing_pattern    = get_firing_pattern(spiking_times, N-1);
firing_rate       = firing_pattern(1);
firing_regularity = firing_pattern(2);
isi_rho           = firing_pattern(3);
lv                = local_variation(isi);
cv                = coefficient_of_variation(isi);

shape_param       = exp(firing_regularity);
scale_param       = 1/(exp(firing_rate)*shape_param);

isi_dist = makedist('Gamma', 'a', shape_param, 'b', scale_param);
isi_pdf  = pdf(isi_dist, bin_centers);

[h1, p] = kstest(isi,'CDF',isi_dist,'Alpha',0.05);

[h2, fig] = kolmogorov_smirnov_test(isi_pdf, isi_probs, length(isi));
