function [fig] = firing_rate_plot (spike_train_matrix, time_vector, bin_size, firing_rate)

    fig = figure; hold all ;
    
    for trial = 1:size(spike_train_matrix ,1)
        position = time_vector(spike_train_matrix(trial, :) == 1) ;
        
        for spike_index = 1:length(position)
            plot ([position(spike_index) position(spike_index)], ...
                  [trial-0.5 trial+0.5], 'k') ;
        end
    end
    
    title(strcat("instantenous firing rate (", string(bin_size), " seconds bin size)"));
    ylabel("frequency [Hz]"); xlabel("time [seconds]");
    hold on; 
    plot(time_vector, firing_rate, 'r');
   
end
