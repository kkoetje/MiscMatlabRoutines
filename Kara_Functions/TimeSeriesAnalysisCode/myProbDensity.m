function [ myPDF, bins, myCPDF ] = myProbDensity(g, binSize , binRange)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% binRange = 1;
% binSize = .05;

mu = myMean(g);
N = length(g);
% M = floor(((mu + binRange) - (mu - binRange)) / binSize);

myCPDF = [];
myPDF = [];

m = 0;

nanCount = 0;
for ii = 1:N
    if isnan(g(ii)) == 1;
        nanCount = nanCount + 1;
    end
end



for x = mu - binRange : binSize : mu + binRange
    m = m + 1;
    dx1 = x - binSize/2;
    dx2 = x + binSize/2;
    k = 0;
    
    for n = 1:N
        if isnan(g(n)) == 1;
           continue
        else
            if g(n)>dx1 && g(n)<=dx2
                k = k+1;
                
            end
        end
    end
    
    myPDF(m) = k;
    
    if m == 1
        myCPDF(m) = myPDF(m);
    else
        myCPDF(m) = myCPDF(m-1) + myPDF(m);
    end
end

bins = mu - binRange : binSize : mu + binRange;
numGood = N - nanCount;

myPDF = myPDF/numGood/binSize;
myCPDF = myCPDF/numGood;

end

