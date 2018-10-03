function [ site_num, site_ll, data_path_vect, data_path_aqdp, data_path_tides ] = getAdcpData( source )
%getAdcpData -- Pulls adcp data from aquadopp using 
%   Detailed explanation goes here

switch source
    case 'passport'
        cd('/Volumes/KK_PASSPORT/GreatBayJune2016/Deployments/')
    case 'zip'
        cd('/Volumes/KK_ZIP/Deployments/')
    otherwise
        warning('data source unknown')
end;

d = dir;
folders = d(arrayfun(@(x) x.name(1), d) ~= '.');  % removes '.' and '..' files that appear in directory
deployment_dates = {folders.name};
[deployment_num] = listdlg('PromptString','Select a file:','ListString',deployment_dates);	% creates dialog box that lists folder names to select deployment num

switch source
    case 'passport'
        pathvect = '/Volumes/KK_PASSPORT/GreatBayJune2016/Vector/Vect_Conv_Data/';
        pathaqdp = '/Volumes/KK_PASSPORT/GreatBayJune2016/Aqdp/Aqdp_Conv_Data/';
        pathtides = '/Volumes/KK_PASSPORT/GreatBayJune2016/TidalData/';
    case 'zip'
        pathvect = '/Volumes/KK_ZIP/Vect_Conv_Data/';
        pathaqdp = '/Volumes/KK_ZIP/Aqdp_Conv_Data/';
        pathtides = '/Volumes/KK_ZIP/TidalData/';
    otherwise
        warning('data source unknown');
end;

tmps = cell2mat(deployment_dates(deployment_num));
data_path_vect =  [pathvect tmps '/DatFiles'];
data_path_aqdp = [pathaqdp tmps];
data_path_tides = [pathtides tmps];

% % cd(data_path_vect)      % path for vector .dat files
% % VectorData_str = dir('*.dat'); % list of files ending w/ .dat
% % file2loadVector = 1; % loads file equal to number in order from first to last in Vector folder
% % fnameVector = VectorData_str(file2loadVector).name;
% % 
% % distBot = 0.86; %Distance in meters Vectrino center beam is from bed

ftpoint = [43 04.3; -70 42.7];    % location of tidal data
site1 = [43 05.033; -70 52.890];  % lat lon in degree and minute form
site2 = [43 04.844; -70 52.861];
site3 = [43 03.941; -70 52.513];
site4 = [43 03.858; -70 52.482];

if deployment_num <= 2
    site_num = 1;
    site_ll = site1;
elseif deployment_num >= 3 && deployment_num <= 4
    site_num = 2;
    site_ll = site2;
elseif deployment_num == 5 
    site_num = 3;
    site_ll = site3;
elseif deployment_num > 5 && deployment_num <= 7
    site_num = 4;
    site_ll = site4;
else
    disp('Unknown Deployment Site')
end


end

