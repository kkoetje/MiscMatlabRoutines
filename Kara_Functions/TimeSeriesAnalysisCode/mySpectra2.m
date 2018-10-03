function [SSband, freqBand, DOF, Gx] = mySpectra2(ts, NumBands,NumEns,delta, window_id) %delta is the 1/f

% %test
% load 'waveData.mat'
% ts = eta_p(1,:);
% ts = gp;
% NumBands = 5;
% NumEns = 5;
% delta = .5;
% window_id = 'hanning';
% %

% ts must be vertical
% Check if ts is horizontal. If so, transpose to a vertical array.
if size(ts,1) == 1
    ts = ts';
end


% % Ensemble Average % %
DOF = NumBands*NumEns*2;
N = length(ts); %length of original ts

k = floor(N/(NumEns));
f = (0:k-1)/(k*delta);

ww = myWindow( k, window_id );


for n = 1:NumEns
    m1 = 1+(n-1)*k;
    m2 = n*k;
    x1(:,n)  = ts(m1:m2);
    % remove mean
    x1mean(n) = nanmean(x1(:,n));
    % fft with windowing
    Gx = fft((x1(:,n) - x1mean(n)).*ww)/k;
    %boost
    boost(n) = var(x1(:,n)) / var((x1(:,n) - x1mean(n)).*ww);
    %compute spectra
    Sx1(:,n) = Gx.*conj(Gx)*2*k*delta * boost(n); 
end

Sxtot = sum(Sx1,2);
SxEns = Sxtot/NumEns;


df = find(f>0 & f<(1/(2*delta)));
freqEns = f(df);
SxEns = SxEns(df);



% % Band Average % %
r = length(freqEns);
Bins = floor(r/(NumBands));

for p = 1:Bins
    m1 = 1+(p-1)*NumBands;
    m2 = p*NumBands;
    Sx(p) = sum(SxEns(m1:m2))/NumBands;
    freq(p) = sum(freqEns(m1:m2))/NumBands;
end

SSband = Sx;
freqBand = freq;

end