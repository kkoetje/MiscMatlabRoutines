%Meagan Wengrove

%use ensemble average, use hanning/boxcar window, boost, band-average 
function [SSband, freqBand, DOF, Gj] = spectrum_mew(X,NumBands,NumEns,delta,windowtype_h_or_b,varargin) %delta is the 1/f
numinputs = nargin; %optional window, boxcar or hanning



%Ensemble Average
DOF = NumBands*NumEns*2;
N = length(X(:,1)); %length of origional ts


Records = NumEns;
RecordPts = floor(N/(NumEns));
frequency = (0:N/2-1)/(N*delta);
freqEns = transpose(((0:RecordPts/2-1))/(RecordPts*delta));

k = 0;
for pp = 1:Records
    indexstart = k+1;
    indexend = k+RecordPts;
    k = indexend;
    EnsambleRecords(:,pp) = X(indexstart:indexend,1);
    ensambleavg(1,pp) = mean(EnsambleRecords(:,pp),1);
    EnsTs(:,pp) = EnsambleRecords(:,pp) - ensambleavg(1,pp);
end
%gnC = EnsambleRecords;
%Hanning Window
if numinputs >4 && windowtype_h_or_b == 'b'
    ww = boxcar(RecordPts);
elseif  numinputs >4 && windowtype_h_or_b == 'h'
    ww = hanning(RecordPts);
else 
    ww = hanning(RecordPts);
end

 dnn = 1:Records;

     djj = 1:RecordPts/2;
     gnC(:,dnn) = repmat(ww(:,1),1,Records).*EnsTs(:,dnn);
    
    varEns(1,dnn) = std(EnsTs(:,dnn)).^2;
    vargnC(1,dnn) = std(gnC(:,dnn)).^2;
    Fboost(1,dnn) = varEns(1,dnn)./vargnC(1,dnn);


%Ensemble Spectrum
    Gj(:,dnn) = fft(gnC(:,dnn))./(RecordPts);
    Aj(:,dnn) = real(Gj(:,dnn));
    Bj(:,dnn) = imag(Gj(:,dnn));

        Shatj(djj,dnn) = (Aj(djj,dnn).^2+Bj(djj,dnn).^2)*2*RecordPts*delta;

%Boost from Windowing
   SSboost(:,dnn) = Shatj(:,dnn).*repmat(Fboost(1,dnn),length(Shatj),1);


%Put Ensemble Spectra back together
    SSens(djj,1) = mean(SSboost(djj,:),2);

%Band Average
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


% 
% figure (3); EX Plotting
% semilogy(freqBand(1:end-1),SSband(1:end-1));
% hold on;
% %xlim([0 1]);
% ylim([10^-5 10^1]);
% xlabel('Frequency (Hz)');
% ylabel('Spectrum');
% title('One Sided Ensamble and Band Avg Spectrum of P5 ts for Hanning Window, 50 DOF');

% %confidence intervals 95percent for 50 DOF
% chisquarelow2=from chi square table DOF.. if want the 95 Percent interval this is the 95 percent;
% chisquarehigh2=and this is the 5 %;
% lowCI3 = DOF*(Sjhat)/(chisquarelow2); %linear intervals, will have one
% for every point on spectra
% highCI3 = DOF*(Sjhat)/(chisquarehigh2);
%               if plot on log scale, then can have only one interval (log(Sjhat) -
%               log(chi^2_DOF (alpha/2)/DOF))< log(Sj) < log(Sjhat) -
%               log(chi^2_DOF (1-alpha/2)/DOF))
% subplot(3,1,1); hold on; line([max(freqBand) max(freqBand)], [lowCI3 highCI3],'color','k'); 
% plot(max(freqBand),(lowCI3+highCI3)/2,'.k');

% 
% Somethings...
% BW = freqBand(5)-freqBand(4); %band width is equal to delta frequency
% sampleVarP5 = sampleStdev(X(:,1))^2;
% samplevarEnsP5 = avg(varP5EachEns);
% spectraldensitysum: sum(SSband)*BW; %variance in the band should the the
%                                       same as the integral under the curve of the power spectra for that band.
% spectralNoiseFloor: noiseFloor_dom_k_SS = sqrt(1/(2*delta)*SSband(end));

