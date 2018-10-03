function [tsnew] = idft_random_phases(ts, winid)
%%function [tsnew] = idft_random_phases(ts, winid)
%%
%%   winid:    1] boxcar   2] hanning

N = length(ts);
delta = 1;
tn = [0 : delta: N-1];
if (winid == 2)
	wind = hanning(N);
else
	wind = ones(N, 1);
end;

dmean = ts - nanmean(ts);
wdata = wind .* dmean;

wfac = sqrt(var(dmean)/var(wdata));
wdata = wdata .* wfac; 

fj = [0 : N-1]/N;
fnyq = 1/2;
df = find(fj > 0 & fj < fnyq);
ndf = length(df);

Aj = zeros(N,1);
Bj = zeros(N,1);

Sj = fft(wdata)/N;
Cj = abs(Sj);
phij = (rand(N,1)*2*pi) - pi;

Aj(1) = 0;
Bj(1) = 0;

Aj(2:ndf+1) = Cj(2:ndf+1) .* cos(phij(2:ndf+1));
Bj(2:ndf+1) = Cj(2:ndf+1) .* sin(phij(2:ndf+1));


if (mod(N,2) == 0),    %% is an even numbered time series record length
	Aj(ndf+2) = 0;
	Bj(ndf+2) = 0;
	nind = ndf + 3;
else
	nind = ndf + 2;
end;

Aj(N : -1 : nind) = Aj(2:ndf+1);
Bj(N : -1 : nind) = -Bj(2:ndf+1);

Gj = Aj + i*Bj;
gn = N*ifft(Gj);
gr = real(gn);
gi = imag(gn);

tsnew = gr + nanmean(ts);
return;
