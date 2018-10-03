function [ W_s, Re, C_d, Dstar, thetaCrit, ustarCrit, delta_smooth ] = Settling_ShieldsCrit_Calc( d_s, tol, rho_s, rho_w, v_k )
% CALCULATION OF SETTLING VELOCITY
% Calculates settling velocity using density, viscosity, and particle diameter inputs.  
% Settling velocity is dependent on the Reynold's number (via drag coeff.),
% so must be solved iteratively.  
% This method is valid for spheres in water for the diameter range .00063cm to 1.0cm
%  
%   Inputs: 
%        - d_s   : diameter of particle, m
%        - tol   : 1E-6; % error tolerance
%        - rho_s : density of sediment particle, kg/m^3, quartz = 2650
%        - rho_w : density of surrounding fluid, kg/m^3, seawater = 1024, freshwater = 1000
%        - v_k   : kinematic viscosity, m^2/s, dependent on temp and salinity for seawater
%
%
% Created by K. Koetje 12/13/2015
% Updated by K. Koetje 2/15/2017

switch nargin
    case 1
        tol = 1E-6; % error tolerance
        rho_s = 2650; % kg/m^3, quartz
        rho_w = 1024; % kg/m^3, seawater
        v_k = 0.9686E-6; % kinematic viscosity (m^2/s), based on avg. temp of 22 C and salinity of 3%, used table found at ww.unisense.com/files/PDF/Diverse/Seawater%20&%20Gases%20table.pdf
    case 2
        rho_s = 2650; % kg/m^3, quartz
        rho_w = 1024; % kg/m^3, seawater
        v_k = 0.9686E-6; % kinematic viscosity (m^2/s), based on avg. temp of 22 C and salinity of 3%, used table found at ww.unisense.com/files/PDF/Diverse/Seawater%20&%20Gases%20table.pdf
    otherwise
        disp('Enter more input arguments')
end

g = 9.81;  % m/s^2
s = rho_s/rho_w;

W_s = zeros(size(d_s));

for ii = 1:length(d_s);
    C_d_guess = 1E4; % guess for drag coeff.
    err = 1;
    count = 1;
    
    while err > tol
        W_s(ii) = sqrt((4*((s)-1)*g*d_s(ii))/(3*C_d_guess));  % settling velocity, m/s
        Re(ii) = W_s(ii)*d_s(ii)/v_k;  % reynold's number
        C_d(ii) = 1.4 + 36/Re(ii); % drag coeff.
        err = abs(C_d_guess - C_d(ii));
        C_d_guess = C_d(ii);
        count = count + 1;
        if count > 1000;
            disp('error: too many interations')  % safety check, in case iterations exceed reasonable number
            break
        end
    end
    
end

%% Compute critical shields using Soulsby & Whithouse (1997)

Dstar = d_s * ((g*(s-1))/ (v_k^2))^(1/3);
thetaCrit = 0.24/Dstar + 0.055*(1-exp(-0.02*Dstar));

ustarCrit = sqrt(thetaCrit*(s-1)*g*d_s);
delta_smooth = (11.6*v_k)/ustarCrit;
end

