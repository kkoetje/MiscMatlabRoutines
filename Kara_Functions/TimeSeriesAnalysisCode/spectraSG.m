function [ f_final,S_final, confLow,confHigh,DOF ] = spectraSG( ts,delta, Nbands,Nens,window )
% computes raw spectral estimate
%%% INPUTS %%%
% ts     time series array
% delta  time step
% Nens   number of bins for ensemble averaging smoothing method
% Nbands number of bins for band averaging smoothing method
%%% OUTPUTS %%%
% f  frequency array
% S  one-sided spectra array
% confLow  lower bound of 95% confidence limit
% confHigh upper bound of 95% confidence limit
if nargin ==2
   Nens=1;
   Nbands=1;
   window='Boxcar';
elseif nargin == 4
    window='Boxcar';
end

N=length(ts); %total data points
ts2=(ts-mean(ts)*ones(N,1)).*myWindow(N,window);
K=floor(N/Nens); %number data points in subrecord

Sub=zeros(K,Nens);     %preallocate
mean_ts=zeros(1,Nens); %preallocate
G=zeros(K,Nens);       %preallocate
Sj=zeros(K,Nens);      %preallocate

for ii=1:Nens
    beg=1+(ii-1)*K;
    fin=ii*K;
    Sub(:,ii)=ts2(beg:fin);
    mean_ts(ii) = mean(Sub(:,ii));
    
    G(:,ii)=fft(Sub(:,ii)-mean_ts(ii))/K; %remove mean, compute fft
    Sj(:,ii)=G(:,ii).*conj(G(:,ii))*2*K*delta; %compute spectra
end
Sj_tot=1/Nens*sum(Sj,2);
fj=(0:(K-1))/(K*delta);
df=find(fj>0 & fj<1/(2*delta));

S=Sj_tot(df);
f=fj(df);

%%% Band Average %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_band=zeros(floor(length(S)/Nbands),1);
f_band=zeros(floor(length(S)/Nbands),1);
for jj=1:floor(length(S)/Nbands)
    m1=1+(jj-1)*Nbands;
    m2=jj*Nbands;
    S_band(jj)=1/Nbands*sum(S(m1:m2));
    f_band(jj)=1/Nbands*sum(f(m1:m2));
end
S_final=S_band*var(ts)/var(ts2);
f_final=f_band;

DOF=2*Nbands*Nens;
confLow = DOF*1/chi2inv(.975,DOF);
confHigh = DOF*1/chi2inv(.025,DOF);
end
