clc; clear; close all;

%% MAIN PARAMETERS FOR THE ANALYSIS
% definition of mer recording
fs        = 24000;      % sampling frequency
dt        = 1 / fs;     % time resolution
bin_size  = 0.010;      % interval for converting spike time to binary process (in seconds)

%% SORTED NEURONS DIRECTORY
% the directory contains patients recording
base_directory = "E:\Master Thesis\GPi Besta AK Thesis\Analysis\Paz1";
filelist       = dir(fullfile(base_directory, '**\*.*')); 
filelist       = filelist(~[filelist.isdir]);  

%% ANALYSIS

% iterate on each .mat file contains spiking activities of sorted neurons
for i = 1 : length(filelist)                    
    
    file_name      = filelist(i).name;
    file_name_we   = string(extractBetween(file_name,1,length(file_name)-4)) ; %without extension
    file_path      = strcat(filelist(i).folder);
    file_extension = string(extractBetween(file_name,(length(file_name)-3),length(file_name)));
    
    % apply the analysis only .mat file contains single unit activity
    if(strcmp(file_extension,'.mat')==1)
        
        full_file_path = strcat(file_path, '\', file_name);
        
        % get the data of sorted spikes from the defined path
        [sua, segment_length] = get_spiking_times(full_file_path);
        
        % number of detected neurons for the current depth of the track
        number_of_neurons = length(sua);

        for neuron_count = 1:number_of_neurons

            % get the sorted neurons spiking activity
            neuron_name   = sua(neuron_count).neuron;
            spiking_times = sua(neuron_count).spiking_times ./ 1000;    % in seconds
            N             = length(spiking_times);                      % number of spikes
            time_vector   = 0: bin_size: segment_length-bin_size;

            % converting spike times to binary spike train with a specific interval
            spike_train = spiketime_2_spiketrain(spiking_times, bin_size, segment_length);
            
            % -------------------------------------------------------------
            % INSTANTENOUS FIRING RATE ------------------------------------
            % -------------------------------------------------------------
            
            alpha = 4;
            beta  = N ^ (4/5);
            % getting instantenous firing rate
            [ins_firing_rate, h] = BAKS(spiking_times, time_vector', alpha, beta);
            
            % -------------------------------------------------------------
            % ISI ---------------------------------------------------------
            % -------------------------------------------------------------
            
            % calculating isi probability for each interval / bin
            [isi, isi_per_bin, isi_probs, bin_centers] = isi_probability(spiking_times, bin_size);
            
            % get firing rate and 
            firing_pattern    = get_firing_pattern(spiking_times, length(isi)-1);
            firing_rate       = firing_pattern(1);                % calculated firing rate
            firing_regularity = firing_pattern(2);                % firing regularity
            isi_rho           = firing_pattern(3);                % isi autocorr rho
            
            lv                = local_variation(isi);             % local variation metric
            cv                = coefficient_of_variation(isi);    % coefficient of variation metric
            shape_param       = exp(firing_regularity);           % shape parameter of fitted gamma dist
            scale_param       = 1/(exp(firing_rate)*shape_param); % scale parameter of fitted gamma dist
            
            isi_pdf = makedist('Gamma', 'a', shape_param, 'b', scale_param);
            isi_pdf = pdf(isi_pdf, bin_centers);

            % -------------------------------------------------------------
            % ACF ---------------------------------------------------------
            % -------------------------------------------------------------
            
            % autocorrelation of spike train
            [acf,lags] = xcorr(spike_train, 'normalized');
            acf        = acf(int32(length(acf))/2:end);
            lags       = lags(int32(length(lags))/2:end);
            lags       = (lags * bin_size)';

            % -------------------------------------------------------------
            % PLOTS -------------------------------------------------------
            % -------------------------------------------------------------
            
            acf_path_name     = strcat(file_path, '\', file_name_we, '_', neuron_name, '_ACF.png');
            isiprob_path_name = strcat(file_path, '\', file_name_we, '_', neuron_name, '_ISIPROB.png');
            raster_path_name  = strcat(file_path, '\', file_name_we, '_', neuron_name, '_raster.png');
            ifr_path_name     = strcat(file_path, '\', file_name_we, '_', neuron_name, '_IFR.png');
            
            % raster plot
            rp_figure = raster_plot(spike_train', time_vector, bin_size);    
            saveas(gcf, raster_path_name);
            hold off;
            
            % firing rate plot
            ifr_figure = firing_rate_plot(spike_train', time_vector, bin_size, ins_firing_rate);
            saveas(gcf, ifr_path_name);
            hold off;
            
            % isi probability plot
            figure; bar(bin_centers, isi_probs.*100 , 'b');
            hold on;
            plot(bin_centers, isi_pdf, 'LineWidth', 2 , 'color', 'r');
            xlabel("ISI [second]"); ylabel("probability [percentage]"); 
            title(strcat("ISI Probabilities (bin size ", string(bin_size), " seconds)"));
            legend('ISI bins', strcat('Fitted Gamma Distribution (shape:', string(shape_param),...
                                      ' | scale:', string(scale_param),')'));
            saveas(gcf, isiprob_path_name);
            hold off;
            
            % acf of spike train            
            figure; stem(lags,acf);
            xlabel("time [seconds]"); ylabel("autocorrelation");
            title(strcat("Autocorrelogram (bin size ", string(bin_size), " seconds)"));
            saveas(gcf, acf_path_name);
            close all; 
        
            % -------------------------------------------------------------
            % SAVING STATISTICS -------------------------------------------
            % -------------------------------------------------------------
            
            % add all the analysis results to statistic struct
            characteristics_struct.fr          = firing_rate;
            characteristics_struct.regularity  = firing_regularity;
            characteristics_struct.ifr         = ins_firing_rate;
            characteristics_struct.isi_rho     = isi_rho;
            characteristics_struct.cv          = cv;
            characteristics_struct.lv          = lv;
            acf_struct.lags                    = lags;
            acf_struct.acf                     = acf;
            isi_probs_struct.bin_centers       = bin_centers;
            isi_probs_struct.isi_probability   = isi_probs;
            isi_pdf_struct.scale_param         = scale_param;
            isi_pdf_struct.shape_parap         = shape_param;
            statistics(neuron_count).name      = neuron_name;
            statistics(neuron_count).chars     = characteristics_struct;
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
        
        
        
        

