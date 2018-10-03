function n=closest(value,array,approachflag)
% CLOSEST Finds index of element closest to given value
%
% CLOSEST(VALUE,ARRAY) returns the index of the element in ARRAY (must
% be 1D column vector) which is closest to VALUE in an absolute
% sense. If VALUE is a 1D column vector, the returned vector is the
% closest index for each element of VALUE.
%
% CLOSEST(VALUE,ARRAY,APPROACHFLAG) returns the index of the element
% in ARRAY which is closest to VALUE according to the option specified
% by APPROACHFLAG.  The APPROACHFLAG options are:
% 
%   APPROACHFLAG =-2  approaching from the left
%                     i.e. closest, but not greater or equal
%   APPROACHFLAG =-1  approaching from the left
%                     i.e. closest, but not greater
%   APPROACHFLAG = 0  in an absolute sense
%   APPROACHFLAG = 1  approaching from the right
%                     i.e. closest, but not less
%   APPROACHFLAG = 2  approaching from the right
%                     i.e. closest, but not less or equal
%
% If APPROACHFLAG does not equal 0, it is possible that the condition
% cannot be met when VALUE exceeds the range of ARRAY.  If this is the
% case, NaN is returned.
%
% If VALUE=NaN, NaN is returned
%
% Example:
%        a=[2 3 4 5]'
%           closest(3,a,-2) returns 1
%           closest([3.4 4.2]',a,-1) returns [2 3]
%           closest(3.4,a,0) returns 2
%           closest([3.4 6]',a,1) returns [3 NaN]
%           closest(3,a,2) returns 3

% Matt Brennan 3/2/00

if nargin<2
  error('Requires two input arguments')
elseif nargin==2
  approachflag=0;
end  

if (size(array,2)~=1 | length(size(array))>2)
  error('ARRAY is not 1D column vector')
end

if (size(value,2)~=1 | length(size(value))>2)
  error('VALUE is not 1D column vector')
end

switch approachflag
 case -2
  for i=1:length(value)
    diffs=array-value(i);
    diffs(diffs>=0)=NaN;
    if all(isnan(diffs))
      n(i)=NaN;
    else
      [junk,n(i)]=min(abs(diffs));
    end
  end
 case -1
  for i=1:length(value)
    diffs=array-value(i);
    diffs(diffs>0)=NaN;
    if all(isnan(diffs))
      n(i)=NaN;
    else
      [junk,n(i)]=min(abs(diffs));
    end
  end
 case 0
  for i=1:length(value)
    diffs=array-value(i);
    [junk,n(i)]=min(abs(diffs));
  end
 case 1
  for i=1:length(value)
    diffs=array-value(i);
    diffs(diffs<0)=NaN;
    if all(isnan(diffs))
      n(i)=NaN;
    else
      [junk,n(i)]=min(diffs);
    end
  end
 case 2
  for i=1:length(value)
    diffs=array-value(i);
    diffs(diffs<=0)=NaN;
    if all(isnan(diffs))
      n(i)=NaN;
    else
      [junk,n(i)]=min(diffs);
    end
  end
 otherwise
  error('APPROACHFLAG option not recognized')
end

% replace n(i) w/NaN for value(i)=NaN or value(i)=Inf
n=n+value'-value';  

return
