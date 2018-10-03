function [ chiSqVal ] = myChiSquareValue( confidence, DOF )
%myChiSquareValue computes the chi-square value that would be found on a
%table, given a desired confidence interval and degrees of freedom.
%
%   Confidence can be entered in terms of a decimal or a percent (e.g. input
%   .95 or 95 to obtain values for 95% confidence).
%
%   Output argument chiSqVal is a 1x2 array
%       The value in the first cell is the alpha/2 value
%       The value in the second cell is the 1-alpha/2 value
%

    if confidence > 1
        alpha = (100-confidence)/100;
    elseif confidence > 100
        disp('invalid confidence input');
        return
    elseif confidence <= 0
        disp('invalid confidence input');
        return
    else
        alpha = 1 - confidence;
    end

chiSqVal(1) = chi2inv(1-(alpha/2),DOF);

chiSqVal(2) = chi2inv(1-(1-alpha/2),DOF);

end

