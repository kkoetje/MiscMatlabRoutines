function [ p ] = bisection(f,a,b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%function p = bisection(f,a,b)

% provide the equation you want to solve with R.H.S = 0 form. 
% Write the L.H.S by using inline function
% Give initial guesses.
% Solves it by method of bisection.



if f(a)*f(b)>0 
    disp('Wrong choice bro')
else
    p = (a + b)/2;
    err = abs(f(p));
    while err > 1e-7
   if f(a)*f(p)<0 
       b = p;
   else
       a = p;          
   end
    p = (a + b)/2; 
   err = abs(f(p));
    end
end
    

end

