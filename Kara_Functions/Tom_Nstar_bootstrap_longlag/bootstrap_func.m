function [lags, minxv, maxxv, Nstar] = bootstrap_func(t1, t2, dt, nlags, nloops, pid)
%function [lags, minxv, maxxv, Nstar] = bootstrap_func(t1, t2, dt, nlags, nloops, pid)


klen = nloops;
%%klen = 10000;

tlags = 2*nlags+1;
corra = zeros(tlags, klen);

for k = 1:klen

	[ts1in] = idft_random_phases(t1, 2);
	[ts2in] = idft_random_phases(t2, 2);

	[lags, corr] = crcor(ts1in, ts2in, nlags, dt, 0, 0);

	corra(:, k) = corr;
	%%corra(k) = corr;
end;

minxv = zeros(1, tlags);
maxxv = zeros(1, tlags);
Nstar = zeros(1, tlags);

m = 0;
for k = -nlags:nlags

	m = m + 1;
	[nv, xv] = hist(corra(m, :), 100);
	nv = nv/klen;
	cpdf = zeros(length(xv), 1);
	cpdf(1) = nv(1);
	for n=2:length(xv)
		cpdf(n) = cpdf(n-1) + nv(n);
	end;

	if (pid)
		figure(pid);
		clf;
		subplot(2,1,1);
		plot(xv, nv);
		subplot(2,1,2);
		plot(xv, cpdf);
	end;

	df = find(cpdf <= 0.025);
	minxv(m) = xv(df(end));
	df = find(cpdf >= 0.975);
	maxxv(m) = xv(df(1));
	Nstar(m) = 3.84/(maxxv(m)^2);

	if (pid)
		fprintf(1, 'm = %d  ', m);
		fprintf(1, 'sig levels:   %f  %f  ', minxv(m), maxxv(m));
		fprintf(1, 'Nstar:  %f\n', Nstar(m));
	end;
end;

return;

