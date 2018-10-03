%% CrossCorrelation function
% Takes in two time series, number of lags, time steps
%removes mean, computes autocorr
%lags go from -lags to +lags
%First input leads with positive lags
%function [acf] = CrossCr(tsx,tsy,lags,dlta)
function [acf] = CrossCr_JT(tsx,tsy,lags,dlta)
%take mean first
N = length(tsx);
sumx=0; sumy=0;
ngoodx=0;ngoody=0;
for i = 1:N
    if isnan(tsx(i))
        i=i+1;
    else
    sumx = sumx + tsx(i);
    ngoodx=ngoodx+1;
    end
end
for i = 1:N
    if isnan(tsy(i))
        i=i+1;
    else
    sumy = sumy + tsy(i);
    ngoody=ngoody+1;
    end
end
meanx = sumx/ngoodx;
meany = sumy/ngoody;
%% correlation
% remove mean
x = tsx-meanx;
y = tsy-meany;
Nlags=lags/dlta;
%Go both -lag and +lag
acf=zeros(length(Nlags*2+1));
for k = 0:Nlags
    sx=0; sxx=0;
    sy=0; syy=0;
    sxy=0;
    ngood=0;
    for i = 1:(length(x)-k)
        if(isnan(x(i))~=1 && isnan(y(i+k))~=1)
            sx = sx + x(i);
            sxx = sxx + x(i)*x(i);
            sy = sy + y(i+k);
            syy = syy + y(i+k)*y(i+k);
            sxy = sxy + x(i)*y(i+k);
            ngood = ngood+1;
        else
        end         
    end
    sx = sx/ngood;
    sxx = sxx/ngood;
    sy = sy/ngood;
    syy = syy/ngood;
    sxy = sxy/ngood;
%autocovariance divided by variance is autocorrelation
acf(k+Nlags+1) = (sxy-sx*sy)/(sqrt(sxx-sx^2)*sqrt(syy-sy^2));
end
%switch x and y
clear x y
y = tsx-meanx;
x = tsy-meany;
for k = 0:Nlags
    sx=0; sxx=0;
    sy=0; syy=0;
    sxy=0;
    ngood=0;
    for i = 1:(length(x)-k)
        if(isnan(x(i))~=1 && isnan(y(i+k))~=1)
            sx = sx + x(i);
            sxx = sxx + x(i)*x(i);
            sy = sy + y(i+k);
            syy = syy + y(i+k)*y(i+k);
            sxy = sxy + x(i)*y(i+k);
            ngood = ngood+1;
        else
        end         
    end
    sx = sx/ngood;
    sxx = sxx/ngood;
    sy = sy/ngood;
    syy = syy/ngood;
    sxy = sxy/ngood;
%autocovariance divided by variance is autocorrelation
acf(Nlags-k+1) = (sxy-sx*sy)/(sqrt(sxx-sx^2)*sqrt(syy-sy^2));
end
end