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
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% KS test is plotted and saved to defined path.
%
function kstest(isi_pdf, isi_probs, N)

    % Kolmogorov - Smirnov Test with 95% confidence interval
    cdf_model     = cumsum(isi_pdf);    % model CDF
    cdf_empirical = cumsum(isi_probs);  % empirical CDF

    figure; plot(cdf_model, cdf_empirical);
            hold on;
            plot([0, 1], [0, 1] + 1.36 / sqrt(N),'k:');
            hold on;
            plot([0, 1], [0, 1] - 1.36 / sqrt(N),'k:');
            xlabel('Model CDF'), ylabel('Empirical CDF');
            title('Kolmogorov - Smirnov Test with 95% Confidence Bounds');
            hold off;

end

