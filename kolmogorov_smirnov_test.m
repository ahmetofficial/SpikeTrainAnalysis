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
% h         : represent if the Ho can be rejected or not. If h=0 then the
%             given data belongs to specified distribution (Ho is true), If
%             h=1 then the given data doesn't belong to specified 
%             distribution (Ho can be rejected)
%
function [h, fig] = kolmogorov_smirnov_test(isi_pdf, isi_probs, N)
    
    % to prevent from same values in cdf_model and cdf_empirical
    randomity = 10E-11 + (10E-13 - 10E-11).*rand(length(isi_pdf),1);
    
    % Kolmogorov - Smirnov Test with 95% confidence interval
    cdf_model     = cumsum(isi_pdf);    % model CDF
    cdf_model     = (cdf_model - min(cdf_model)) / (max(cdf_model) - min(cdf_model));
    cdf_model     = cdf_model + randomity;
    cdf_empirical = cumsum(isi_probs);  % empirical CDF
    cdf_empirical = (cdf_empirical - min(cdf_empirical)) / (max(cdf_empirical) - min(cdf_empirical));
    cdf_empirical = cdf_empirical + randomity;

    border_line   = linspace(0,1,length(cdf_model))';
    upper_border  = border_line + (1.358 / sqrt(N));   % 1.358 from KS table for 95% confidence
    lower_border  = border_line - (1.358 / sqrt(N));

    cdf_diff          = interp1(cdf_model,cdf_empirical,border_line);
    cdf_diff(1)       = 0; % replacing nan value
    cdf_diff(end)     = 1; % replacing nan value
    lower_bound_check = cdf_diff >= lower_border;
    upper_bound_check = cdf_diff <= upper_border;

    fig = figure;
    plot(cdf_model, cdf_empirical);
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
    
     % if any of check arrays contains zero, the number of unique elements
     % will be 2 ([0,1]), in this case the fitted distribution reaches out
     % of 95% confidence interval. In this case the test will be
     % unsuccessful.
     if(length(unique(lower_bound_check))==1 && length(unique(upper_bound_check))==1)
         h = 0;
     else
         h = 1;
     end
     
end

