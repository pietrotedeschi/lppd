function [CI] = my_confidence_interval(x,alfa)
%Function to compute the confidence interval of a vector x
%   x is the input vector
%   alfa is the percentage of data included in the standard deviation


SEM = std(x)/sqrt(length(x));               % Standard Error
%ts = tinv([0.025  0.975],length(x)-1);      % T-Score
ts = tinv([(1-alfa)  alfa],length(x)-1);      % T-Score
CI = mean(x) + ts*SEM;                      % Confidence Intervals


end

