%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The inverse gaussian function will be fit based on following criteria:
% 
% ISI distribution is modelled with inverse gaussian distribution. The 
% inverse Gaussian distribution has two parameters that determine its 
% shape: μ, which determines the mean of the distribution; and λ, which is 
% called the shape parameter. For each isi value: IG distribution is used
% with shape and location parameters. In here "THE SPIKES CONSIDERED AS 
% STATISTICALLY INDEPENDENT". So the likelihood of ISI joint pdf can be 
% defined as the multiplication of each individual distribution. Taking
% derivation of maximum likelihood of each parameter will provide the
% estimation of shape and location parameters.
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% isi         : Nx1 vector contains different isi values
% bin_centers : the bin centers of isi distribution.
% 
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% mu          : estimated mean parameter for IG distribution
% lambda      : estimated location parameter for IG distribution
% isi_pdf     : estimated IG distribution based on bin centers
%
function [mu, lambda, isi_pdf] = isi_fit_inverse_gaussian(isi, bin_centers)

    mu        = mean(isi);
    lambda    = 1 / mean((1./isi) - (1./mu));
    isi_pdf   = zeros(length(bin_centers),1);
    
    for i = 1:length(bin_centers)
        t          = bin_centers(i);
        isi_pdf(i) = sqrt(lambda/(2*pi*t^3)) * exp((-lambda*(t-mu)^2) / (2*t*mu^2));
    end
    
end

