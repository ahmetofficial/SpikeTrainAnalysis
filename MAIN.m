clc; clear; close all;

% definition of mer recording
fs        = 24000;     % sampling frequency
dt        = 1 / fs;    % time resolution
bin_size  = 10;        % interval for converting spike time to binary process (ms)

% the directory contains patients recording
base_directory = 'E:\Master Thesis\GPi Besta AK Thesis\Analysis\Paz1';
filelist = dir(fullfile(base_directory, '**\*.*')); 
filelist = filelist(~[filelist.isdir]);  

for i = 1 : length(filelist)
    
    file_name      = filelist(i).name;
    file_name_we   = string(extractBetween(file_name,1,length(file_name)-4)) ; %without extension
    file_path      = strcat(filelist(i).folder);
    file_extension = string(extractBetween(file_name,(length(file_name)-3),length(file_name)));
    
    if(strcmp(file_extension,'.mat')==1)
        
        full_file_path = strcat(file_path, '\', file_name);
        
        % get the data of sorted spikes from the defined path
        [sua, segment_length] = get_spiking_times(full_file_path);
        
        % number of detected neurons for that depth of the track
        number_of_neurons = length(sua);

        for neuron_count = 1:number_of_neurons

            % get the sorted neurons' spiking activity
            neuron_name   = sua(neuron_count).neuron;
            spiking_times = sua(neuron_count).spiking_times;

            % converting spike times to binary spike train with a specific interval
            spike_train = spiketime_2_spiketrain(spiking_times, bin_size, segment_length);

            % calculating isi probability for each interval / bin
            [isi_probs, bin_centers] = isi_probability(spiking_times, bin_size);
           
            % autocorrelation of spike train
            [acf,lags] = xcorr(spike_train, 'normalized');
            acf        = acf(int32(length(acf))/2:end);
            lags       = lags(int32(length(lags))/2:end);
            lags       = (lags * bin_size)';


            % plotting 
            acf_path_name     = strcat(file_path, '\', file_name_we, '_', neuron_name, '_ACF.mat');
            isiprob_path_name = strcat(file_path, '\', file_name_we, '_', neuron_name, '_ISIPROB.mat');
            
            % plot and save the acf of spike train
            figure; bar(bin_centers, isi_probs);
            xlabel("ms"); ylabel("probability"); title(strcat("ISI Probabilities(Bin size ", string(bin_size), " ms)"));
            saveas(gcf, strcat(acf_path_name, '_ISIPROB.png'));

            % plot and save the isi probability of spike train
            figure; stem(lags,acf);
            xlabel("ms"); ylabel("autocorrelation");
            saveas(gcf, strcat(isiprob_path_name, '_ACF.png'));
            close all; 
        
            % add all the analysis results to statistic struct
            acf_struct.lags                    = lags;
            acf_struct.acf                     = acf;
            isi_probs_struct.bin_centers       = bin_centers;
            isi_probs_struct.isi_probability   = isi_probs;
            statistics(neuron_count).name      = neuron_name;
            statistics(neuron_count).acf       = acf_struct;
            statistics(neuron_count).isi_probs = isi_probs_struct;
            
        end
        
        % save the analysis result to given directory
        statistics_file_name = strcat(file_path, '\', file_name_we, '_STATISTICS.mat');
        save(statistics_file_name,'statistics');
        
    end
end
        
        
        
        

