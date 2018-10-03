function [Lr,Cr,Cgr,sigma]=find_L_disper(h,T)
% 
% function [Lr,Cr,Cgr,Lo,kr,sigma]=find_L_disper(h,T)
% ____________________________________________
% With this function, you can get the value of L (wavelength), k (wave number),
% sigma(angular frequency), using different solutions of the dispersion equation.
%
% Inputs:
%            h = water depth (m)
%            T = wave period (s)
%
% Outputs:
%            kr = wave number with Newton-Rhapson (1/m)
%            Lr = wavelength with Newton-Rhapson (m)
%            sigma = angular frequency (1/T)
%
% Syntax :
%             [Lr,kr,sigma]=disper(h,T)
%
% Example:    [Lr,kr,sigma]=disper(3.05,5)
%
% Notes: 
%            In the command window you can see the different
%            values which were computed, using different equations
% 
% Referents:
%              Darlymple, R.G. and Dean R.A. (1999). Water Wave Mechanics
%              for Engineers and Scientist. World Scientific.
%              Singapure.
%              Fenton,J.D and Mckee,W.D.(1990). On calculating the lengths
%              of water waves. Coastal Engineering 14, 499-513p.
%
% Programming: Gabriel Ruiz Martinez 2006. Modified by DLF, KMK 2015
% _______________________________________________________

% Test value
% T = 10; 
% h = 2.5; 
x0 =0.0001;   

if sign(h) == -1
       h = -h;
end

% *********** Solving dispersion equation, using Newton-Rapshon **********
sigma_2 = ((2*pi)/T)^2;
Gamma = (sigma_2*h)/9.81;

con = 1;

if x0 ~= 0
    x(con) = x0;
    x(con+1) = x(con) - ( ( Gamma - (x(con) * tanh(x(con)))) / ...
               ((-x(con)*(sech(x(con)))^ 2)-tanh(x(con))));
    while abs( x(con+1) - x(con) ) > 0.00001
            x(con+2) = x(con+1) - ( ( Gamma - (x(con+1) * tanh(x(con+1)))) / ...
                       ((-x(con+1)*(sech(x(con+1)))^ 2)-tanh(x(con+1))));
            con = con + 1;
    end
    kr = x(con)/h;
    Lr = (2*pi)/kr;
    sigma = sqrt(sigma_2);
    Cr = Lr/T;
    nr =0.5*(1+((2*kr*h)/sinh(2*kr*h)));
    Cgr = nr * Cr;
    
else
    disp('WARNING !!!! You cannot run the function with x0 = 0,Try with other value');
    kr = 0;
    Lr = 0;
end
% ******************************************************

% *********** Solving dispersion equation, using Lo aproximation **********
Lo = (9.81*T^2)/(2*pi);
La = Lo * (tanh(((2*pi)*((sqrt(h/9.81))/T))^(3/2)))^(2/3);
ka = ( 2 * pi ) /La;
Ca = La/T;
na =0.5*(1+((2*ka*h)/sinh(2*ka*h)));
Cga = na * Ca;
ea = (abs(Lr-La)/abs(Lr))*100;
% ******************************************************


