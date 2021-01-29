clc; clear; close all;

% definition of mer recording
fs        = 24000;     % sampling frequency
dt        = 1 / fs;    % time resolution
bin_size  = 1;       % interval for converting spike time to binary process (ms)

% the directory contains patients recording
base_directory = "E:\Master Thesis\GPi Besta AK Thesis\Analysis\Paz1";
filelist       = dir(fullfile(base_directory, '**\*.*')); 
filelist       = filelist(~[filelist.isdir]);  

% clean the KS text file
ks_result_path = 'E:\Master Thesis\GPi Besta AK Thesis\Analysis\KS-IG.txt';
if exist(ks_result_path, 'file') == 2 
	delete(ks_result_path);
end
ks_result_txt  = fopen(ks_result_path,'wt');

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
            [isi, isi_per_bin, isi_probs, bin_centers] = isi_probability(spiking_times, bin_size);
            
            % fitting IG distribution for given isi
            [mu, lambda, isi_pdf] = isi_fit_inverse_gaussian(isi, bin_centers);
            
            % plotting KS graph to see the goodness of fit
            ks_path_name     = strcat(file_path, '\', file_name_we, '_', neuron_name, '_KS.png');
            ks_result = kstest(isi_pdf, isi_probs, length(isi), ks_path_name);
            
            % if the KS test failed, then write down the info to txt file
            if(ks_result == 0) 
                fprintf(ks_result_txt, '\n%s', full_file_path);
            end
            
            % autocorrelation of spike train
            [acf,lags] = xcorr(spike_train, 'normalized');
            acf        = acf(int32(length(acf))/2:end);
            lags       = lags(int32(length(lags))/2:end);
            lags       = (lags * bin_size)';

            % plotting 
            acf_path_name     = strcat(file_path, '\', file_name_we, '_', neuron_name, '_ACF.png');
            isiprob_path_name = strcat(file_path, '\', file_name_we, '_', neuron_name, '_ISIPROB.png');
            
            % plot and save the isi probability of spike train
            figure; bar(bin_centers, isi_probs);
            hold on;
            plot(bin_centers, isi_pdf, 'LineWidth', 2);
            xlabel("ISI [ms]"); ylabel("probability"); 
            title(strcat("ISI Probabilities (bin size ", string(bin_size), " ms)"));
            legend('ISI bins', strcat('Fitted Inverse Gaussian Distribution (mu:', string(mu) , ' | lambda:', string(lambda),')'));
            saveas(gcf, isiprob_path_name);
            hold off;
            
            % plot and save the acf of spike train            
            figure; stem(lags,acf);
            xlabel("ms"); ylabel("autocorrelation");
            saveas(gcf, acf_path_name);
            close all; 
        
            % add all the analysis results to statistic struct
            acf_struct.lags                    = lags;
            acf_struct.acf                     = acf;
            isi_probs_struct.bin_centers       = bin_centers;
            isi_probs_struct.isi_probability   = isi_probs;
            isi_pdf_struct.mu                  = mu;
            isi_pdf_struct.lambda              = lambda;
            statistics(neuron_count).name      = neuron_name;
            statistics(neuron_count).acf       = acf_struct;
            statistics(neuron_count).isi_probs = isi_probs_struct;
            statistics(neuron_count).isi_pdf   = isi_pdf_struct;
            
        end
        
        % save the analysis result to given directory
        statistics_file_name = strcat(file_path, '\', file_name_we, '_STATISTICS.mat');
        
        % if file exist delete
        if exist(statistics_file_name, 'file') == 2 
            delete(statistics_file_name);
        end
        save(statistics_file_name,'statistics');
        
    end
end

fclose(ks_result_txt);
        
        
        
        

