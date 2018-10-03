function [ ts_new, med, stdDev, numgood ] = myMedianStdFilter( ts, numEns, numStdDev, numPass )
% myMedianFilter -- filters input ts by determining the median of each ensemble and
% replacing any values that fall outside a standard deviation filter with
% NaN's.
%
%   Inputs:
%       ts ............ time series to analyze
%       numEns ........ number of ensembles with which to compute the
%                       median
%       numStdDev ..... the number of standard deviations away from the
%                       median where the data is considered "good".
%                       anything outside of this limit will become a NaN
%       numPass ....... the number of passes that you will run the time
%                       series through the stadard deviation filter
%
%   Outputs:
%       ts_new ........ new time series with NaN's in place of data that
%                       is outside of the standard deviation filter
%       mu ............ std. dev. of new time series
%       sigma2 ........ variance of new time series
%       numgood ....... the number of good (non-NaN) data points in gnew
%
%

if nargin == 1      % if no input argument for numStdDev or numPass,
    numStdDev = 3;  % automatically set both = 3
    numPass = 3;
end


N = length(ts);

k = floor(N/(numEns));  % number of data points per ensemble

countNan = 0;
finalNan = 0;

%ts_mod = ts;
ts_new = [];


    for n = 1:numEns
        m1 = 1+(n-1)*k;
        m2 = n*k;
        % select data in ensemble
        x1(:,n)  = ts(m1:m2);
        % determine median of ensemble
        med(n) = median(x1(:,n), 'omitnan');
        % determine std dev of ensemble
        stdDev(n) = std(x1(:,n),'omitnan');
        x2(:,n) = x1(:,n);

        passcount = 0;

        while passcount < numPass

            countNan = 0;

            for j = 1:k
                if x2(j,n) > (med(n) + (numStdDev * stdDev(n))) || x2(j,n) < (med(n) - (numStdDev * stdDev(n)))
                    x3(j,n) = NaN;
                    countNan = countNan+1;
                else
                    x3(j,n) = x2(j,n);
                end

            end

            med(n) = median(x3(:,n),'omitnan');

            stdDev(n) = std(x3(:,n),'omitnan');

            x2(:,n) = x3(:,n);

            passcount = passcount+1;
            finalNan = countNan+finalNan;

        end

        numgood = N - finalNan;

    end
    
 
% Put the the ensembles back together so that ts_new is a single array of
% the same length as the input data, ts

ts_new = x3(:,1);

    for m = 2:numEns
        ts_new = [ts_new ; x3(:,m)];
    end

    
end
