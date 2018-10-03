function make_movie_gif(M,fps,fname,nrepeat)
% function make_movie_gif(M,fps,fname,nrepeat)
% a function to save an animated gif  
% 
% M- movie
% fps - frames per sec
% fname -file to be saved under (.gif)
% nrepeat - number of times to repeat (default is 0 and means no repeats)
%
% This assumes you've already made made the movie
%  Here is an example of a how to make a movie
% clear M
% figure(1)
% for jj=1:20
%    clf
%    text(.9*rand,.9*rand,int2str(jj),'fontsize',30)
%   M(jj)=getframe(gcf)
% end
%
% Once the M matrix is filled call:
% make_movie_gif(M,5,'Hrms.gif',1)
%
% NOTE: Powerpoint will only play the movie when 'nrepeat' is larger than 0
%
%Diane Foster (DLF) 2006, edit Matthieu de Schipper 2008,2009, edit Kara Koetje 2016


if nargin <4
    nrepeat=1;
end

%%% Save first and last frame seperately (handy in Presentations)
[X,MAP]=frame2im(M(1));
[X,MAP]=rgb2ind(X,256);
imwrite(X,MAP,['first_frame_' fname ],'gif','WriteMode','overwrite');

clear X MAP
[X,MAP]=frame2im(M(end));
[X,MAP]=rgb2ind(X,256);
imwrite(X,MAP,['last_frame_' fname ],'gif','WriteMode','overwrite');

%%% Save animated gif
clear X MAP
for ii=1:length(M)
    [X,MAP]=frame2im(M(ii));
    [X,MAP]=rgb2ind(X,256);
    if ii==1
        imwrite(X,MAP,fname,'gif','WriteMode','overwrite','DelayTime',1/fps,'loopcount',nrepeat);
    else
        imwrite(X,MAP,fname,'gif','WriteMode','append','DelayTime',1/fps);
    end
end

