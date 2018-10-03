function [nstar, Sa] = get_nstar(ts1, ts2, minlag, maxlag, dt, dmean_flag, dtrend_flag);
%function [nstar, Sa] = get_nstar(ts1, ts2, minlag, maxlag, dt, dmean_flag, dtrend_flag);
%
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

if nargin < 6,
	dmean_flag = 1;
	dtrend_flag = 1;
end;

tlags = 2*(maxlag-minlag + 1);
corr = zeros(tlags,1);

npts = length(ts1);
if npts ~= length(ts2),
        fprintf(1, 'time series are not the same length. Bye.\n');
        return;
end;

if (dmean_flag == 1), 
	dt1 = ts1;
	dt2 = ts2;
	df1 = find(~isnan(ts1));
	df2 = find(~isnan(ts2));
	
	dt1(df1) = detrend(ts1(df1), 'constant');
	dt2(df2) = detrend(ts2(df2), 'constant');
	if (dtrend_flag == 1) 
		dt1(df1) = detrend(dt1(df1));
		dt2(df2) = detrend(dt2(df2));
	end;
else
	dt1 = ts1;
	dt2 = ts2;
end;


% Do negative lags first
mm = 0;
for j=minlag:maxlag
  mm = mm + 1;
  x = dt1(1+j:npts);
  y = dt2(1:npts-j);
  %%dN = find(~isnan(x)==1 & ~isnan(y)==1);
  dN = find(isnan(x)==0 & isnan(y)==0);
  if length(dN) ~= 0,
    sxy = sum(y(dN) .* x(dN)) / length(dN);
    sxlag = sum(x(dN)) / length(dN);
    sy = sum(y(dN)) / length(dN);
    svarx = sum(x(dN).*x(dN))/length(dN) - (sxlag .* sxlag);
    svary = sum(y(dN).*y(dN))/length(dN) - (sy .* sy);
    corr(mm) = (sxy-(sy.*sxlag)) ./ (sqrt(svarx).*sqrt(svary));
  else
    corr(mm) = NaN;
  end;
end;

% now do postive lags, including zero
for j=minlag:maxlag
  mm = mm + 1;
  x = dt1(1:npts-j);
  y = dt2(1+j:npts);
  %%dN = find(~isnan(x)==1 & ~isnan(y)==1);
  dN = find(isnan(x)==0 & isnan(y)==0);
  if length(dN) ~= 0,
    sxy = sum(y(dN) .* x(dN)) / length(dN);
    sylag = sum(y(dN)) / length(dN);
    sx = sum(x(dN)) / length(dN);
    svarx = sum(x(dN).*x(dN))/length(dN) - (sx .* sx);
    svary = sum(y(dN).*y(dN))/length(dN) - (sylag .* sylag);
    corr(mm) = (sxy-(sx.*sylag)) ./ (sqrt(svarx).*sqrt(svary));
  else
    corr(mm) = NaN;
  end;
end;

Sa = mean(corr(1:mm).*corr(1:mm));
nstar = 1/Sa;

return;
