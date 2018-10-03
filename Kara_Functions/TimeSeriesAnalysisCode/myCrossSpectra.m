function [Sx, Sy, Co, Qu, freq, phase, coh2, DOF] = myCrossSpectra(ts1,ts2,NumBands,NumEns,delta, window_id)%,windowtype_h_or_b) %,varargin) %delta is the 1/f

% %test
% load 'waveData.mat'
% ts1 = eta_p(1,:);
% ts2 = eta_p(4,:);
% NumBands = 5;
% NumEns = 1;
% delta = 1/6;
% window_id = 'boxcar';
% %


% ts must be vertical
% Check if ts is horizontal. If so, transpose to a vertical array.
if size(ts1,1) == 1
    ts1 = ts1';
end
if size(ts2,1) == 1
    ts2 = ts2';
end
% Make sure ts have same length
if length(ts1)-length(ts2) ~= 0
    disp('ts1 and ts2 must have the same time vector')
end


% % Ensemble Average % %
DOF = NumBands*NumEns*2;
N = length(ts1); %length of original ts1

k = floor(N/(NumEns));
f = (0:k)/(k*delta);

ww = myWindow( k, window_id );

% Initialize sum variables
SmSx = 0;
SmSy = 0; 
SmCo = 0;
SmQu = 0;

for n = 1:NumEns
    m1 = 1+(n-1)*k;
    m2 = n*k;
    x1 = ts1(m1:m2);
    x2 = ts2(m1:m2);
    % remove mean
    % fft with windowing
    Gx = fft((x1 - myMean(x1)).*ww)/k;
    Gy = fft((x2 - myMean(x2)).*ww)/k;
    % ensemble spectra
    Sx1 = 2*k*delta.*(Gx).*(conj(Gx));
    Sy1 = 2*k*delta.*(Gy).*(conj(Gy));
    % co and quad spectra
    Co1 = (real(Gx).*real(Gy) + imag(Gx).*imag(Gy)).*2*k*delta;
    Qu1 = (real(Gy).*imag(Gx) - real(Gx).*imag(Gy)).*2*k*delta;
    % sum ensembles
    SmSx = SmSx + Sx1;
    SmSy = SmSy + Sy1;
    SmCo = SmCo + Co1;
    SmQu = SmQu + Qu1;
end

% normalize by number of ensembles
SxEns = SmSx/NumEns;
SyEns = SmSy/NumEns;
CoEns = SmCo/NumEns;
QuEns = SmQu/NumEns;

% isolate frequencies between 0 and Nyquist
df = find(f>0 & f<(1/(2*delta)));
freqEns = f(df);
SxEns = SxEns(df);
SyEns = SyEns(df);
CoEns = CoEns(df);
QuEns = QuEns(df);

% % Band Average % %
r = length(freqEns);
Bins = floor(r/(NumBands));

for p = 1:Bins
    m1 = 1+(p-1)*NumBands;
    m2 = p*NumBands;
    Sx(p) = myMean(SxEns(m1:m2));
    Sy(p) = myMean(SyEns(m1:m2));
    freq(p) = myMean(freqEns(m1:m2));
    Co(p) = myMean(CoEns(m1:m2));
    Qu(p) = myMean(QuEns(m1:m2));
end

coh2 = real((Co.^2 + Qu.^2) ./ (Sx.*Sy));
phase = atan2(-Qu,Co);

end