function [G,cumG] = myGaussian( bins,mean,variance)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bin_size=bins(2)-bins(1);
G=zeros(length(bins),1);cumG=zeros(length(bins),1);
    for ii=1:length(bins)
        G(ii)=1/sqrt(2*pi*variance)*exp((bins(ii)-mean)^2/(-2*variance));
        cumG(ii)=sum(G(1:ii))*bin_size;

    end
end

