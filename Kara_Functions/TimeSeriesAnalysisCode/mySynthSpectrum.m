function [ g_n, G_n ] = mySynthSpectrum( N, delta, Shat_j )
% mySynthSpectrum creates a synthetic spectrum given a desired t.s. length
% (N), a sample rate (delta), and a spectrum shape (Shat_j).
%   Given the desired input arguments, the function outputs a time series
%   with the constraints of the input arguments (g_n) and the corresponding
%   Fourier transform (G_n)



C_j = sqrt(Shat_j / (2*N*delta));
C_j = C_j*10^(-3);

theta_j = rand((N/2)-1,1)*2*pi;

A_j = zeros(N,1);
B_j = zeros(N,1);

for ii = 1:N/2-1
    A_j(ii+1) = C_j(ii) .* cos(theta_j(ii));
    B_j(ii+1) = C_j(ii) .* sin(theta_j(ii));
    A_j(N-ii+1) = A_j(ii+1);
    B_j(N-ii+1) = -B_j(ii+1);
end

G_n = A_j - 1i*B_j;

g_n = ifft(G_n)*N;

end

