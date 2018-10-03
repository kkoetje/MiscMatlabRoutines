function [ wts ] = myWindow( N, window_id )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

switch window_id
    case 'boxcar'
        wts = ones(N,1);
    case 'bartlett'
        
        if rem(N,2) ~=0 %odd
            M = N-1;
            count=0;
            for  ii=0:M/2
                count=count+1;
                wts(count,1)=2*ii/M;
            end
            for ii=1+M/2:M
                count=count+1;
                wts(count,1)=2-2*ii/M;
            end
        else %even
            M=N;
            count=0;
            for  ii=0:M/2-1
                count=count+1;
                wts(count,1)=2*ii/M;
            end
            for ii=1+M/2:M
                count=count+1;
                wts(count,1)=2-2*ii/M;
            end
        end
        
    case 'hanning'
        wts = hanning(N);


        %     case 'welch'
        %         wts =
        
end

