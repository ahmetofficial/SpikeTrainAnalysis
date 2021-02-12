function [] = raster_plot (spike_train_matrix, bins )

    hold all ;
    
    for trial = 1:size(spike_train_matrix ,1)
        spike_position = bins(spike_train_matrix(trial, :) == 1) ;
        
        for spike_count = 1:length(spike_position)
            plot ([spike_position(spike_count) spike_position(spike_count)], ...
                  [trial-0.4 trial+0.4], 'k') ;
        end
        
    end
    
    ylim ([0 (size(spike_train_matrix,1)+1)]);
    
end
