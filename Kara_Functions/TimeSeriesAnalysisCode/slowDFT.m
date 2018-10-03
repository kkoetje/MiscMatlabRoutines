function [ Gf, f ] = slowDFT( g , delta , N )
%This function computes the slow Discrete Fourier Transform (slow DFT)
% %   inputs:     delta           sampling interval
% %               N               numer of data points (total observations)
% %               ntime           time steps
% %               g          input function (array)
% %
% %   outputs:    Gf              transformed input function
% %               f               transformed frequency 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=1;
for freqloop = -(N-1)/2:delta:(N-1)/2
    fn = freqloop/(N*delta); %sampling frequencies
    Gsum = 0; %initialize G
    for timeloop = -(N-1)/2:delta:(N-1)/2
        % Transform
        t=timeloop*delta;
        Gsum = Gsum + g(timeloop+(N-1)/2+1)*exp(-1i*2*pi*fn*t);
    end
    Gf(count) = 1/N*Gsum;
    f(count) = fn;
    count=count+1;
    clear Gsum
end


end