%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function converts the continious spiking time to a binary process
% that contains zeros and ones. This conversation is done based on defined
% interval. The number of bins basically:
% 
% number of bins = segment_length / interval.
%
% So each time instant in the spiking_times vector will be converted to
% this bins in a binary way. 
%
% Example:
% spiking_times = [37.4, 38, 67]; interval = 10; segment_length = 100;  
% bins will be [10,20,30,40,50,60,70,80,90,100]
% the numbers represent the upper range of the each bin
% 
% the output will be
% spike train = [0,0,0,1,0,0,1,0,0,0]
% spike_count = [0,0,0,2,0,0,1,0,0,0]
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% spiking_times  : array contains spiking times
% interval       : the size of each bin in ms
% segment_length : recording length in ms
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% spike_train    : binary representation of spike train
% spike_count    : number of spike in each bin
%
function [spike_train, spike_count] = spiketime_2_spiketrain(spiking_times, interval, segment_length)
    bins        = interval: interval: segment_length;
    spike_train = zeros(length(bins),1); 
    spike_count = zeros(length(bins),1); 

    for i = 1:length(spiking_times)
        spike_time  = spiking_times(i);
        bin_denoter = ceil(mod(spike_time/interval,length(bins)));
        spike_train(bin_denoter) = 1;
        spike_count(bin_denoter) = spike_count(bin_denoter) + 1;
    end
end

