function [] = print_all_figs( filePath, fileType, fileResolution )
%% export all figures as jpeg


if nargin == 0
    filePath = pwd;
    fileType = '-djpeg';
    fileResolution = '-r400';
elseif nargin == 1
    fileType = '-djpeg';   % alternate fileType could be '-dpdf'
    fileResolution = '-r400';
elseif nargin == 2
    fileResolution = '-r400';
end

figs = findobj(0,'type','figure');  %search for and sort all figures in ascending order
figNum = [figs.Number];
[~,figIndex] = sort(figNum);
figSort = figs(figIndex);

cd(filePath)

for k = 1:length(figSort)
    print(figSort(k), fileType, fileResolution, sprintf('fig%d.jpg',k))
end

end

