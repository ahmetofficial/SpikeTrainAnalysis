function [fig] = raster_plot (spike_train_matrix, bins, bin_size)

    fig = figure; hold all ;
    
    for trial = 1:size(spike_train_matrix ,1)
        position = bins(spike_train_matrix(trial, :) == 1) ;
        
        for spike_index = 1:length(position)
            plot ([position(spike_index) position(spike_index)], ...
                  [trial-0.4 trial+0.4], 'k') ;
        end
    end
    
    ylim ([0 (size(spike_train_matrix,1)+1)]); 
    title(strcat("raster plot with bin size = ", string(bin_size), " seconds"));
    ylabel("trials"); xlabel("time (seconds)");
   
end
