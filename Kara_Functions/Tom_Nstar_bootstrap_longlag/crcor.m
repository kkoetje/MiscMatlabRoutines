function [lags, corr] = crcor(ts1, ts2, nlags, dt, dmean_flag, dtrend_flag);
%function [lags, corr] = crcor(ts1, ts2, nlags, dt, dmean_flag, dtrend_flag);
%
%  positive lags are ts1 leading ts2
%
%  dmean_flag:  1=take out mean, 0=don't
%  dtrend_flag:  1=take out linear trend, 0=don't
% crcor.m
%
% based on old fortran code by Lippmann.
%
% 12/02/99
% T. C. Lippmann
%

if nargin < 5,
	dmean_flag = 1;
	dtrend_flag = 1;
end;

ts1 = ts1(:);
ts2 = ts2(:);

tlags = 2*nlags + 1;
corr = zeros(tlags,1);
lags = dt*[-nlags:1:nlags];
lags = lags(:);

npts = length(ts1);
if npts ~= length(ts2),
        fprintf(1, 'time series are not the same length. Bye.\n');
        return;
end;

dt1 = ts1;
dt2 = ts2;
if (dmean_flag == 1), 
	df1 = find(~isnan(ts1));
	df2 = find(~isnan(ts2));
	
	dt1(df1) = detrend(ts1(df1), 'constant');
	dt2(df2) = detrend(ts2(df2), 'constant');
	if (dtrend_flag == 1) 
		dt1(df1) = detrend(dt1(df1));
		dt2(df2) = detrend(dt2(df2));
	end;
end;


% Do negative lags first
for j=1:nlags
  x = dt1(1+j:npts);
  y = dt2(1:npts-j);
	nx = length(x);
	sxy = nanmean(y .* x);
	sxlag = nanmean(x);
	sy = nanmean(y);
	svarx = nanvar(x)*(nx-1)/nx;
	svary = nanvar(y)*(nx-1)/nx;
    	corr(nlags+1-j) = (sxy-(sy.*sxlag)) ./ (sqrt(svarx).*sqrt(svary));
end;

% now do postive lags, including zero
for j=0:nlags
  x = dt1(1:npts-j);
  y = dt2(1+j:npts);
	nx = length(x);
    sxy = nanmean(y .* x);
    sylag = nanmean(y);
    sx = nanmean(x);
    svarx = nanvar(x)*(nx-1)/nx;
    svary = nanvar(y)*(nx-1)/nx;
    corr(nlags+1+j) = (sxy-(sx.*sylag)) ./ (sqrt(svarx).*sqrt(svary));
end;

return;
