function [ mu ] = myMean( g )
% myMean computes the mean without using builtin functions
%   input time series, g, function outputs the mean, mu

N = length(g);
sumg = 0;
nancount = 0;

for ii = 1:N
   if isnan(g(ii)) == 1;
       nancount = nancount + 1;
   else
    sumg = sumg + g(ii);  % sum all values in time series
   end
end

mu = (1/(N-nancount)) * sumg;   % divide by number of values in series

end

