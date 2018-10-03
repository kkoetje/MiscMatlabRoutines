function [ ts_new ] = myMedianFilter( ts, numEns, threshold )
% myMedianFilter Summary -- filters input ts by determining the median of each ensemble and
% replacing any values that fall outside an input threshold with NaN
%

N = length(ts);

k = floor(N/(numEns));  % number of data points per ensemble
%%f = (0:k-1)/(k*delta);  % hold over from mySpectra2.m... i think it's a time stamp thing
                          % if this gets put back in, need to add delta (sample freq) to the input args

for n = 1:numEns
    m1 = 1+(n-1)*k;
    m2 = n*k;
    % select data in ensemble
    x1(:,n)  = ts(m1:m2);
    % determine median of ensemble
    med(n) = median(x1(:,n), 'omitnan');
    x2(:,n) = x1(:,n);
    
    for j = 1:k
        if abs(x2(j,n) - med(n)) > threshold
            x2(j,n) = NaN;
        end
    end
    
end


% Put the the ensembles back together so that ts_new is a single array of
% the same length as the input data, ts

ts_new = x2(:,1);

for m = 2:numEns
    ts_new = [ts_new ; x2(:,m)];
end


end

