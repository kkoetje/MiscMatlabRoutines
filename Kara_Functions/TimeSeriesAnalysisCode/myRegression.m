%function [ ymod, alpha, skill ] = myRegression( y, x, M )
function [ ymod, alpha ] = myRegression( y, x, M )
% myRegression computes the multi-variate regression of ...........
% Data will be filtered with a 3 std. dev. tolerance, with filtered data 
% replaced with NaN's.
%
%   Inputs:
%       y ............. true data
%       x ............. model vectors
%       M ............. the number of model vectors
%                       For a linear regression M = 2
%                       For a 2nd degree polynomial regression, M = 3, etc.
%   Outputs:
%       ymod .............. true data
%       alpha ............. model coefficients
%       skill ............. the correlation squared of the true data and
%                           the model data

N = length(y); 

D = zeros(M,M);


%% Create D matrix
for k = 1 : M;
    for m = 1 : M;
        ng = 0;
        for n = 1 : N;
            if ( ~isnan(y(n))   &&   ~isnan(x(n,k))   &&   ~isnan(x(n,m)));
                D(k,m) = D(k,m) + x(n,k)*x(n,m);
                ng = ng + 1;
            end
        end
        D(k,m) = D(k,m)/ng;
    end
end


%% Create inverted D matrix
Dinv = inv(D);


%% Create Z matrix
z = zeros(M,1);

for m = 1 : M;
    ng = 0;
    for n = 1 : N;
        if ( ~isnan(y(n))   &&   ~isnan(x(n,m)))
            ng = ng + 1;
            z(m) = z(m) + y(n)*x(n,m);
        end
    end
    z(m) = z(m)/ng;
end


%% Create A matrix
A = zeros(M,1);

for k = 1 : M;
    for m = 1:M;
        A(k) = A(k) + Dinv(k,m)*z(m);
    end
end

alpha = A;

%% Create the model
ymod = zeros(N,1);

for n = 1 : N;
    for m = 1 : M;
        ymod(n) = ymod(n) + A(m)*x(n,m);
    end
end



end

