%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function Kolmogorov - Smirnov (quantile to quantile) plot which shows
% the goodness of fit of generated distribution. In this test, model and 
% empirical cdf's are compared.
%
% For 95% confidence bounds, a well-fit model should stay within ±1.36/√N
% of the 45-degree line, where N is the number of ISIs observed.
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% isi_pdf   : fitted isi distribution (IG distribution were fitted)
% isi_probs : probability vector of each ISI bins
% N         : number of elements ISI (number of spikes - 1)
% path_name : the full path name that KS plot will be saved
%             "directory/file_name.png"
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% KS test is plotted and saved to defined path.
% result    : the result of KS test(0:unsuccessfull, 1:successful)
%
function result = kstest(isi_pdf, isi_probs, N, path_name)

    % Kolmogorov - Smirnov Test with 95% confidence interval
    cdf_model     = cumsum(isi_pdf);    % model CDF
    cdf_empirical = cumsum(isi_probs);  % empirical CDF
    
    border_line   = linspace(0,1,length(cdf_model))';
    upper_border  = border_line + (1.36 / sqrt(N));
    lower_border  = border_line - (1.36 / sqrt(N));
    
    cdf_diff          = interp1(cdf_model,cdf_empirical,border_line);
    cdf_diff(1)       = 0; % replacing nan value
    cdf_diff(end)     = 1; % replacing nan value
    lower_bound_check = cdf_diff >= lower_border;
    upper_bound_check = cdf_diff <= upper_border;
            
    figure; plot(cdf_model, cdf_empirical);
            hold on;
            plot(border_line, border_line);
            hold on;
            plot(border_line, upper_border, 'k:');
            hold on;
            plot(border_line, lower_border, 'k:');
            xlabel('Model CDF'), ylabel('Empirical CDF');
            title('Kolmogorov - Smirnov Test with 95% Confidence Interval');
            legend('fitted model', 'perfect fit line', 'upper - lower bounds');
            hold off;
            saveas(gcf, path_name);
     
     % if any of check arrays contains zero, the number of unique elements
     % will be 2 ([0,1]), in this case the fitted distribution reaches out
     % of 95% confidence interval. In this case the test will be
     % unsuccessful.
     if(length(unique(lower_bound_check))==1 && length(unique(upper_bound_check))==1)
         result = 1;
     else
         result = 0;
     end
end

