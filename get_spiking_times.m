%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The functions that get the information about sorted spikes. To do that,
% it read a .mat file that contains a matrix [N,2]; First column represent
% the id of detected neuron. So each number represent a different neuron.
% Second column represents the spiking times of neurons. The spiking times
% that belong to neuron id with 0 rejected (during the spike sorting these
% spiking activities labelled as multi unit activity).
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% path           : the full path of math file that contains sorted spikes
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sua            : struct contains the neuron names and spiking times as
%                  vector. For each row, there are two information.
% segment_length : recording length in ms
%
function [sua, segment_length] = get_spiking_times(path)
    load(path);
    spikes = cluster_class;        % loaded matlab file provides 'cluster_class'
    neurons = unique(spikes(:,1)); % determined neurons after spike sorting [1,2,3...]
    neurons = neurons(neurons~=0); % 0 represent the rejected spiking activity
    
    for i = 1:length(neurons)      % putting spiking times of different neurons in separate arrays
        neuron_index         = neurons(i);
        neuron_spikes        = spikes(spikes(:,1)==neuron_index,:);
        sua(i).neuron        = strcat('neuron', string(i));
        sua(i).spiking_times = neuron_spikes(:,2);
    end
    segment_length = ceil(cluster_class(end,2)/1000);
end