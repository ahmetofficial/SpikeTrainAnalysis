%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% For a spike train that contains the spiking times from 0< t1,t2,...,tn <T
% this function will gives the probability distribution of inter spike
% intervals. As a first step inter spikes intervals are calculated. In the
% following step, these invervals split into bins with corresponding bin
% size. As a last step, the number of occurence of isi for each bin is
% divided into total number of spikes to calculate probability of observing
% a spike after the a spiking event.
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% spiking_times   : vector contains spiking times 0< t1,t2,...,tn <T
% bin_size        : the size of each bin (integer)
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% isi_probability : isi probabilites of each time interval
% bin_centers     : the center value of each bin (vector)
%
function [isi_probability, bin_centers] = isi_probability(spiking_times, bin_size)

    spikes_count                 = length(spiking_times);
    isi                          = spiking_times(2:end) - spiking_times(1:end-1);
    [isi_per_bin, bin_centers]   = binning(isi, bin_size);
    isi_probability              = isi_per_bin ./ spikes_count;
    isi_probability              = isi_probability(1:end-1);
    
end