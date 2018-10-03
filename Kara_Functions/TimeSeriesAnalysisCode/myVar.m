function [sigma2 ] = myVar( g , w )
% myVar computes the variance without using builtin functions
%   input time series, g, function outputs the variance, sigma^2
%   input w, or the weight, is specified as one of the following:
%       0 -- normalizes by the number of ovservations minus one
%       1 -- normalizes by the number of observations
%       if no input argument for w, function will default to normalizing
%           by N - 1.
%           ^^ this is consistent with Matlab's built-in variance calc.

N = length(g);

if nargin == 1      % if no input argument for w, automatically set w = 0
    w = 0;          
end

if w == 0           % if w = 0, normalize by N-1
    norm = N - 1;
elseif w == 1       % if w = 1, nomarlize by N
    norm = N;
end

sumsig = 0;
nancount = 0;
mu = myMean(g);  %compute mean from myMean code

for ii = 1:N
   if isnan(g(ii)) == 1;
     nancount = nancount + 1;
   else
    sumsig = sumsig + g(ii)^2 - mu^2;  % sum all values in time series
   end
end

sigma2 = (1/(norm - nancount)) * sumsig;  % divide by normalization factor defined above

end

