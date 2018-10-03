

load 20160707_uv_velocities.mat

dt = 1;

df = [52972 : 68825];
nlen = length(df);
tvec = [1 : dt : nlen];
u10nan = u(10,df)';
v10nan = v(10,df)';

u10 = u10nan;
dn = find(isnan(u10nan)==1);
dg = find(isnan(u10nan)==0);
if numel(dn),
	u10(dn) = interp1(tvec(dg), u10nan(dg), tvec(dn));
end;

v10 = v10nan;
dn = find(isnan(v10nan)==1);
dg = find(isnan(v10nan)==0);
if numel(dn),
	v10(dn) = interp1(tvec(dg), v10nan(dg), tvec(dn));
end;

c10 = sqrt(u10.^2 + v10.^2);

%% its not clear that you should detrend 
%%if you compute means over the non-detrened time series
%%u10 = detrend(u10);
%%v10 = detrend(v10);
%%c10 = detrend(c10);

%dmean_flag = 0;
%dtrend_flag = 0;
%[ulags, ucorr] = crcor(u10, u10, 100, dt, dmean_flag, dtrend_flag);
%[vlags, vcorr] = crcor(v10, v10, 100, dt, dmean_flag, dtrend_flag);
%[clags, ccorr] = crcor(c10, c10, 100, dt, dmean_flag, dtrend_flag);

nlags = 0;
nloops = 10000;
pid = 1;
[plags, pcu, pcl, unstar] = bootstrap_func(u10, u10, dt, nlags, nloops, pid);
pid = 2;
[plags, pcu, pcl, vnstar] = bootstrap_func(v10, v10, dt, nlags, nloops, pid);
pid = 3;
[plags, pcu, pcl, cnstar] = bootstrap_func(c10, c10, dt, nlags, nloops, pid);

fprintf(1, 'Bootstrap Method Nstar values:  u = %f      v = %f     cmag =  %f\n', unstar, vnstar, cnstar);


%% now get nstar from long-lag method:

minlag = 6000;
maxlag = 7000;
dmean_flag = 0;
dtrend_flag = 0;
[u2nstar, Sa] = get_nstar(u10, u10, minlag, maxlag, dt, dmean_flag, dtrend_flag);
[v2nstar, Sa] = get_nstar(v10, v10, minlag, maxlag, dt, dmean_flag, dtrend_flag);
[c2nstar, Sa] = get_nstar(c10, c10, minlag, maxlag, dt, dmean_flag, dtrend_flag);

fprintf(1, 'Long-Lag Method Nstar values:  u = %f      v = %f     cmag =  %f\n', u2nstar, v2nstar, c2nstar);
