%% OUTDATED -- USE mySpectra2.m INSTEAD!

function [SSband, freqBand, DOF, Gj] = mySpectra(ts, NumBands,NumEns,delta, window_id)%,windowtype_h_or_b) %,varargin) %delta is the 1/f
numinputs = nargin; %optional window, boxcar or hanning

% Ensemble Average
DOF = NumBands*NumEns*2;
N = length(ts(:,1)); %length of origional t.s.

Records = NumEns;
RecordPts = floor(N/(NumEns));
frequency = (0:N/2-1)/(N*delta);
freqEns = transpose(((0:RecordPts/2-1))/(RecordPts*delta));

k = 0;
for pp = 1:Records
    indexstart = k+1;
    indexend = k+RecordPts;
    k = indexend;
    EnsembleRecords(:,pp) = ts(indexstart:indexend,1);
    ensembleavg(1,pp) = mean(EnsembleRecords(:,pp),1);
    EnsTs(:,pp) = EnsembleRecords(:,pp) - ensembleavg(1,pp);
end


% Windowing
ww = myWindow( N, window_id );

dnn = 1:Records;

djj = 1:RecordPts/2;
gnC(:,dnn) = repmat(ww(:,1),1,Records).*EnsTs(:,dnn);

varEns(1,dnn) = std(EnsTs(:,dnn)).^2;
vargnC(1,dnn) = std(gnC(:,dnn)).^2;
Fboost(1,dnn) = varEns(1,dnn)./vargnC(1,dnn);

% Ensemble Spectrum
Gj(:,dnn) = fft(gnC(:,dnn))./(RecordPts);
Aj(:,dnn) = real(Gj(:,dnn));
Bj(:,dnn) = imag(Gj(:,dnn));

Shatj(djj,dnn) = (Aj(djj,dnn).^2+Bj(djj,dnn).^2)*2*RecordPts*delta;

% Boost from Windowing
SSboost(:,dnn) = Shatj(:,dnn).*repmat(Fboost(1,dnn),length(Shatj),1);


% Put Ensemble Spectra back together
SSens(djj,1) = mean(SSboost(djj,:),2);

% Band Average
if NumBands ~=1
    Bins = floor(RecordPts/((NumBands)*2)); %big bins
    k = 1; %To not include zero frequency
    for pp = 1:Bins-1
        indexstart = k+1; %To not include zero frequency
        indexend = k+NumBands;
        k = indexend;
        SSband(pp,1) = mean(SSens(indexstart:indexend));
        freqBand(pp,1) = mean(freqEns(indexstart:indexend));
    end
else
    SSband = SSens(1:end);
    freqBand = freqEns(1:end);
    
    if freqBand(1) == 0; % to not include zero frequency if there is no band or ensemble averaging.
        freqBand = freqBand(2:end);
        SSband = SSband(2:end);
    end
    
end

