function [ coh2Sig, phaseCI ] = Hw12_crossSpecPlots( ts1, ts2, ts_time, numEns, numBand, Fstat, window_id, CI_text_yn )

% CI_text_yn gives the option to include confidence interval annotations to
% each set of error bars.  
% Input 'y' to include text, 'n' to not include text.

delta = ts_time(2)-ts_time(1);

% [SSband1, freqBand1, DOF, Gj] = mySpectra2(ts1,numBand,numEns,delta, window_id);
% [SSband2, freqBand2, DOF, Gj] = mySpectra2(ts2,numBand,numEns,delta, window_id);


[Sx, Sy, co, quad, freq, phase, coh2, DOF] = myCrossSpectra(ts1,ts2,numBand,numEns,delta, window_id);
phase = rad2deg(phase);


figure;
make_axes_bold(1,1)
orient tall
clf

subplot(3,1,1)
semilogy(freq, Sx,'LineWidth',2)
hold on
semilogy(freq, Sy,'LineWidth',2)
grid on
% add legend in main script
xlabel('Frequency (Hz)')
ylabel('Spectral Density') %may need to change units in main script
ylim([1E-5 20])

subplot(3,1,2)
plot(freq,coh2,'LineWidth',2)
ylabel('Squared Coherence')
xlabel('Frequency (Hz)')
grid on

% Significance level
coh2Sig = Fstat / ((DOF-2)/2 + Fstat);
hold on
h1 = hline(coh2Sig);
set(h1, 'LineWidth',1.75)
text(.725*freq(end),coh2Sig+.3,['95% Significance Level: ' num2str(coh2Sig)])

subplot(3,1,3)
plot(freq,phase,'o','LineWidth',2)
ylim([-180 180])
hold on
ylabel(['Phase (' sprintf('%c', char(176)) ')'])
xlabel('Frequency (Hz)')
grid on

% Make error bars
sigPts = find(coh2>coh2Sig);  %find indices of significant points
phaseCI = asind( (2/(DOF-2)) .* (1-coh2(sigPts))./(coh2(sigPts)) .* Fstat );

plot(freq(sigPts),phase(sigPts),'o','MarkerFaceColor',[1 0 0],'MarkerEdgeColor','none')
errBar(1,:) = phase(sigPts)-phaseCI;
errBar(2,:) = phase(sigPts)+phaseCI;


for k = 1:length(sigPts)
    line([freq(sigPts(k)) freq(sigPts(k))],[errBar(1,k) errBar(2,k)],'LineWidth',1.5,'Color',[1 0 0])
    if CI_text_yn == 'y'
        text(freq(sigPts(k))+.02,phase(sigPts(k)), ['95% CI: ±' num2str(phaseCI(k)) sprintf('%c', char(176))] );
    end
end

end

