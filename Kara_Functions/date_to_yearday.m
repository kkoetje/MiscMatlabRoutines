function [yrday]=date_to_yearday(yr,mo,da,hr,mi,se);

%function [yrday]=date_to_yearday(yr,mo,da,hr,mi,se);
% 
% This routine will determine the yearday  from as little as year, month, day.
% the hour minute and second values are optional 
% ie. date_to_yearday(1997,10,29)=302

if nargin<6, 	se=0;	end
if nargin<5, 	mi=0;	end
if nargin<4, 	hr=0;	end

if yr==0, 	yr=1997;  end

yrday=datenum(yr,mo,da,hr,mi,se)-datenum(yr-1,12,31);

return
