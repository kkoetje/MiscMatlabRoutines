%
% Given a set of images, this script writes them to an animated gif, that
% will loop repeatedly
%
% NOTE: this script expects that the files to be used in creation of the
%       gif are sequentially numbered by file name in some way
%
% --
% Author:       Ryan S. Mieras
% Affiliation:  U.S. Naval Research Laboratory
% Last Updated: February 2019
% Contact:      ryan.mieras.ctr@nrlssc.navy.mil
%

clear; clc;


%% USER INPUTS

fdir = 'path/to/images/';  % path to images
fext = '*_mean.png';  % file extension of images (NOTE: can also accept flags like '*_mean.png' or '2017*')

frame_rate = 5;  % frame rate of output gif, during playback (frames per second)

fdir_save = 'path/to/gif_output/';  % path to save the gif (path will be created if it doesn't already exist)
fname_save = 'example_gif';  % file name of the saved gif (NOTE: exclude .gif extension here)


%% Generate gif, write to file

files = dir(fullfile(fdir,fext));  % get file listing
delay = 1/frame_rate;  % delay (s) between frames, in the gif output playback

% Check for existence of output directory, and if doesn't exist, create it
if ~exist(fullfile(fdir_save), 'dir') 
    mkdir(fullfile(fdir_save));  % create directory
end

h = waitbar(0, sprintf('Writing frames to ''%s''', strrep([fname_save '.gif'],'_','\_')),'Name','Building GIF...');

for i = 1:length(files)
	
    im3d = imread(fullfile(fdir,files(i).name));
    [im,cmap] = rgb2ind(im3d,256);
    
  % Generate/save the GIF
    if i == 1
        imwrite(im,cmap,fullfile(fdir_save, [fname_save '.gif']),'gif','Loopcount',inf,     'DelayTime', delay);
    else
        imwrite(im,cmap,fullfile(fdir_save, [fname_save '.gif']),'gif','WriteMode','append','DelayTime', delay);
    end
    
    waitbar(i/length(files),h);  % update waitbar progress
	
end
close
close(h);  % close waitbar

fprintf('\n  > Saved to file: %s\n\n',fullfile(fdir_save, [fname_save '.gif']));

