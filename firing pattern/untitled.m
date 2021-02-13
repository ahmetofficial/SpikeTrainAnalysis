% clc; clear; close all;

%%Simulate spike train by drawing interspike intervals (ISIs) from the gamma distribution. 
% logkappa  = 2.0; % shape parameter
% loglambda = 3.0; % scale parameter
% a         = exp(logkappa);
% b         = 1/(exp(loglambda)*a);
% ISI       = gamrnd(a,b,1,1000);
% X         = histogram(ISI,200);
% spkt      = horzcat(0.0,cumsum(ISI));

%%Compute firing characteristics
fp_vec = get_firing_pattern(spiking_times, N-1);

firing_rate       = fp_vec(1);
firing_regularity = fp_vec(2);
rho               = fp_vec(3);
lv                = fp_vec(4);

% bar(X);
%--------------------------------------------

