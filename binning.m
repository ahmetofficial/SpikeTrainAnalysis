%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Dividing a series of data points according to defined bin size. In this
% function, the values of datapoints will be binned between 0 and max
% datapoint value in the datapoint vector. All the elements in the input
% vector will be placed into its corresponding bin. At the end of the
% process, the output vector: event_count will contain occurence of
% datapoint values in each bin.
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% datapoints    : vector contains different elements to be binned (vector)
% bin_size      : the size of each bin (integer)
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% event_count   : frequency of elements for each bin (vector)
% bin_centers   : the center value of each bin (vector)
%
function [event_count, bin_centers] = binning(datapoints, bin_size)

    max_datapoint         = max(datapoints);
    bins                  = 0:bin_size:max_datapoint+bin_size;
    bin_centers           = bins(1:end-1) + bin_size/2;
    event_count           = zeros(length(bins),1); 

    for i = 1:length(datapoints)
        value  = datapoints(i);
        bin_denoter = ceil(mod(value/bin_size,length(bins)));
        event_count(bin_denoter) = event_count(bin_denoter) + 1;
    end
    
    bin_centers           = bin_centers';
end