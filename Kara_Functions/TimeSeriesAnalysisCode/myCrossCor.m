function [ lags, corr ] = myCrossCor( ts1, ts2, lags, delta ) %, DOF, confidence)
% myCrossCor computes the cross-correlation of two input time series,
% or the auto-correlation if the same t.s. is input twice.  Data will be
% filtered with a 3 std. dev. tolerance, with filtered data replaced with
% NaN's.
%
%   Inputs:
%       lags ............. the cross cor. will be analyzed for lags of 0
%                            to the input value for tshift
%       delta .............. the time step

%% Check length of arrays, deal with NaN's
if length(ts1) ~= length(ts2)
    disp('time series must be the same length');
end

%% Filter with 3std filter, determine raw data mean, subtract out mean
[tsx, mux] = myTsStats(ts1);
[tsy, muy] = myTsStats(ts2);

%% Renove Mean
x = tsx - mux;
y = tsy - muy;

% x = ts1;  % used when data is not filtered and mean is not removed
% y = ts2;

nlags = lags/delta;

corr = zeros(2*nlags+1,1);
lags = zeros(2*nlags+1,1);

for k = 0:nlags
    
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
    
    corr(nlags+k+1) = (sxy - sx * sy)/( sqrt(syy - sy^2) * sqrt(sxx - sx^2) );
    lags(nlags+k+1) = k*delta;
    
end


if nlags >0
    %% switch x and y to compute negative lags
    clear x y
    y = tsx - mux;
    x = tsy - muy;
    
    for k = 0:nlags
        
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
        
        corr(nlags-k+1) = (sxy - sx * sy)/( sqrt(syy - sy^2) * sqrt(sxx - sx^2) );
        lags(nlags-k+1) = -k*delta;
        
    end
end


end

