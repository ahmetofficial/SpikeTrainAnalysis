%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Bayesian Adaptive Kernel Smoother (BAKS)
% 
% BAKS is a method for estimating firing rate from spike train data that 
% uses kernel smoothing technique with adaptive bandwidth determined using 
% a Bayesian approach. More information, please refer to "Estimation of 
% neuronal firing rate using Bayesian adaptive kernel smoother (BAKS)"
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% spiking_times : spike event times [nSpikes x 1]
% Time          : time at which the firing rate is estimated [nTime x 1]
% a             : shape parameter (alpha) 
% b             : scale paramter (beta)
%
%% %%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% h             : adaptive bandwidth [nTime x 1]
% firing_rate   : estimated firing rate [nTime x 1]
%
function [firing_rate, h] = BAKS(spiking_times, time, alpha, beta)
    
    N        = length(spiking_times);
    sumnum   = 0; 
    sumdenum = 0;
    
    for i = 1:N
        numerator   = (((time-spiking_times(i)).^2)./2 + 1./beta).^(-alpha);
        denumerator = (((time-spiking_times(i)).^2)./2 + 1./beta).^(-alpha-0.5);
        sumnum      = sumnum + numerator;
        sumdenum    = sumdenum + denumerator;
    end
    
    h           = (gamma(alpha)/gamma(alpha+0.5)).*(sumnum./sumdenum); % estimated  bandwidth
    firing_rate = zeros(length(time),1);
    
    for j = 1:N
        K           = (1./(sqrt(2.*pi).*h)).*exp(-((time-spiking_times(j)).^2)./(2.*h.^2));
        firing_rate = firing_rate + K;
    end
    
end