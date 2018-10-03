function [ Nstar, sigLevel, Sa ] = myGetNstar( ts1, ts2, minlag, maxlag, confidence)
% myGetNstar computes the number of independent observations using the 
% long-lag artificial skill method.
% Data will be filtered with a 3 std. dev. tolerance, with filtered data 
% replaced with NaN's.
%
%   Inputs:
%       tshift ............. the cross cor. will be analyzed for lags of 0
%                            to the input value for tshift
%       delta .............. the time step
%       minlag ............. lower bound of long-lag range (e.g. 1700)
%       maxlag ............. upper bound of long-lag range (e.g. 1800)
%    

%% Check length of arrays, deal with NaN's
if length(ts1) ~= length(ts1)
    disp('time series must be the same length');
end

%% default 95% confidence 
if nargin == 4
    confidence = 95;
end

[tsx, mux] = myTsStats(ts1);
[tsy, muy] = myTsStats(ts2);

%% Remove Mean
x = tsx - mux;
y = tsy - muy;

M = (maxlag - minlag + 1);

corrA = 0;

for k = maxlag : -1 : minlag
    
    sx = 0;
    sy = 0;
    sxx = 0;
    syy = 0;
    sxy = 0;
    ngood = 0;
    
    for n = 1:(length(x)-k)
        
        if isnan(x(n)) ~= 1 && isnan(y(n+k)) ~= 1
            sx = sx + x(n);
            sxx = sxx + x(n) * x(n);
            sy = sy + y(n+k);
            syy = syy + y(n+k)*y(n+k);
            sxy = sxy + x(n)* y(n+k);
            ngood = ngood + 1;
        end
    end
    sx =  sx/ngood;
    sy = sy/ngood;
    sxx = sxx/ngood;
    syy = syy/ngood;
    sxy = sxy/ngood;
    
    corrA = corrA + ((sxy - sx * sy)/( sqrt(syy - sy^2) * sqrt(sxx - sx^2) ))^2;
    
end


%% switch x and y to compute negative lags
clear x y
y = tsx - mux;
x = tsy - muy;

corrB = 0;

for k =  minlag : maxlag
    
    sx = 0;
    sy = 0;
    sxx = 0;
    syy = 0;
    sxy = 0;
    ngood = 0;
    
    for n = 1:(length(x)-k)
        
        if isnan(x(n)) ~=1 && isnan(y(n+k)) ~=1
            sx = sx + x(n);
            sxx = sxx + x(n) * x(n);
            sy = sy + y(n+k);
            syy = syy + y(n+k)*y(n+k);
            sxy = sxy + x(n)* y(n+k);
            ngood = ngood + 1;
        end
    end
    sx =  sx/ngood;
    sy = sy/ngood;
    sxx = sxx/ngood;
    syy = syy/ngood;
    sxy = sxy/ngood;
    
    corrB = corrB + ((sxy - sx * sy)/( sqrt(syy - sy^2) * sqrt(sxx - sx^2) ))^2;
    
end

Sa = (corrA + corrB) * (1/(2*M));
Nstar = 1/Sa;



%% Compute significance for given confidence interval

% degrees of freedom for both corr. & cross-corr. is = 1

if confidence == 90
    chisq = 2.71;  % chi square value for 90%
elseif confidence == 95
    chisq = 3.84;  % chi square value for 90%
else
    disp('no chi square value available for this confidence value')
end

sigLevel = ( chisq / Nstar )^(.5);


end

