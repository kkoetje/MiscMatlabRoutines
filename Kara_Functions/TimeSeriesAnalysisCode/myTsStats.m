function [ gnew , mu , sigma2 , numgood ] = myTsStats( g , numStdDev , numPass )
% myTsStats computes the relevant stats for time series analysis.  The
% function passes a given time series through standard deviation filter
% (the default is 3 standard deviations) and replaces any value outside of
% that limit with a NaN.  The default number of passes is 3.
%
%   Inputs:
%       g ............. time series to analyze
%       numStdDev ..... the number of standard deviations away from the
%                       mean where the data is considered "good".  
%                       anything outside of this limit will become a NaN
%       numPass ....... the number of passes that you will run the time
%                       series through the stadard deviation filter
%
%   Outputs:
%       gnew .......... new time series with NaN's in place of data that
%                       is outside of the standard deviation filter
%       mu ............ mean of new time series
%       sigma2 ........ variance of new time series
%       numgood ....... the number of good (non-NaN) data points in gnew
%
%


if nargin == 1      % if no input argument for numStdDev or numPass,                    
    numStdDev = 3;  % automatically set both = 3
    numPass = 3;          
end


N = length(g);

mu = myMean(g);

sigma2 = myVar(g);

stdDev = sqrt(sigma2);

countNan = 0;
finalNan=0;

gmod = g;
gnew = [];

passcount = 0;

while passcount < numPass
    
countNan = 0;

    for ii = 1:N
              
        if gmod(ii) > (mu + (numStdDev * stdDev)) || gmod(ii) < (mu - (numStdDev * stdDev))
            gnew(ii) = NaN;
            countNan = countNan+1;
        else
            gnew(ii) = gmod(ii);
        end
        
    end
    
        mu = myMean(gnew);
        
        sigma2 = myVar(gnew);
        
        stdDev = sqrt(sigma2);
        
        gmod = gnew;
    
    passcount = passcount+1;
   finalNan=countNan+finalNan;
end

numgood = N - finalNan;

end
