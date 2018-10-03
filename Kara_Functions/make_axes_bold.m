function[] = make_axes_bold(ynum,xnum,xgap,ygap,yntxtblk)
%function[hax] = make_axes_2d(xnum,ynum,xgap,ygap,yntxtblk)
%       This function will make num axes with the standard text 
%       block at the bottom if yntxtblk==1
set(gcf,'color','w')
%clf
if nargin<3, xgap=.05; elseif length(xgap)==0, xgap=.05; end
if nargin<4, ygap=.1;  elseif length(ygap)==0, ygap=.1;  end
if nargin<5, yntxtblk=0; end

set(gcf,'DefaultTextFontName','Arial');
%set(gcf,'DefaultTextUnits','normalized');
set(gcf,'DefaultAxesFontName','Arial');
set(gcf,'DefaultLineMarkerSize',7);
set(gcf,'DefaultAxesFontWeight','bold');
set(gcf,'DefaultTextFontWeight','bold');
set(gcf,'DefaultTextFontSize',14);
set(gcf,'DefaultAxesFontSize',14);


%
%	make num axes
%

if yntxtblk==1, y=0.2; else, y=.1; end
hgt=(1-(ynum-1)*ygap-y-.1)/ynum;
wid=(1-(xnum-1)*xgap-.2)/xnum;
x=0.1;
for i=1:xnum;,
for j=1:ynum;
rect=[x y wid hgt];

 hax(i,j)=axes('position',rect);
hold on;
 y=y+hgt+ygap;
end
if yntxtblk==1, y=0.2; else, y=.1; end
 x=x+wid+xgap;
end
%
%	add text blocks
%
if yntxtblk==1,
hax(xnum,ynum+1)=axes('position',[0.05 0.05 0.85 0.1]);
set(hax(xnum,ynum+1),'Visible','off')
end




