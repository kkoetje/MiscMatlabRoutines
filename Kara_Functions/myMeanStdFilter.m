function [ ts_new, mu, stdDev, numGood ] = myMeanStdFilter( ts, numEns, numStdDev, numPass )
% myMeanStdFilter -- filters input ts by determining the mean of each ensemble and
%   replacing any values that fall outside a standard deviation filter with
%   NaN's.
%
%   This function uses myTsStats.m (created in time series class),
%   but adds ensembling for the specific case of processing GB 2015-2017 
%   data.  
%   If the number of ensembles chosen is 1, this function will return the 
%   same result as myTsStats.m
%
%   Inputs:
%       ts ............ time series to analyze
%       numEns ........ number of ensembles with which to compute the
%                       mean
%       numStdDev ..... the number of standard deviations away from the
%                       mean where the data is considered "good".
%                       anything outside of this limit will become a NaN
%       numPass ....... the number of passes that you will run the time
%                       series through the stadard deviation filter
%
%   Outputs:
%       ts_new ........ new time series with NaN's in place of data that
%                       is outside of the standard deviation filter
%       mu ............ mean of new time series
%       stdDev ........ std. dev. of new time series
%       numgood ....... the number of good (non-NaN) data points in gnew
%
%


if nargin == 1      % if no input argument for numEns, numStdDev or numPass
    numEns = 1;     % use only a single ensemble
    numStdDev = 3;  % automatically set both = 3
    numPass = 3;
end

if nargin == 2      % if only ts and numEns inputs are entered
    numStdDev = 3;  % automatically set both = 3
    numPass = 3;
end



%% Ensemble data first

N = length(ts);

k = floor(N/(numEns));

for nn = 1:numEns
    m1 = 1+(nn-1)*k;
    m2 = nn*k;
    % select data in ensemble
    x1(nn,:)  = ts(m1:m2);
end


%% Run each ensemble through a 3-pass, 3 std dev filter, replacing "bad" data with NaN's
% using myTsStats.m to carry out the filtering

for ii = 1:numEns
    
    [ x2(ii,:) , mu(ii,:) , sigma2(ii,:) , numgood(ii,:) ] = myTsStats( x1(ii,:) , numStdDev , numPass );
    
end


%% Put the the ensembles back together so that ts_new is a single array of
% the same length as the input data, ts

ts_new = x2(1,:);

for jj = 2:numEns
    ts_new = [ts_new, x2(jj,:)];
end

%% Sum the number of good points in each ensemble to get the total number of good points
numGood = sum(numgood);

%% Take the sqrt of variance to report the std. dev. of each ensemble

stdDev = sqrt(sigma2);

end

