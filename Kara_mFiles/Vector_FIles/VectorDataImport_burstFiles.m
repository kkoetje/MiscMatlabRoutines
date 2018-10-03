clc;
%clear all;

%% fileType = 'VEA';

% 
% for zz=1:127 %length of dir
%     clearvars -except zz;
%     close all;
%     clc;
%     cd ('/home/mwengrove/Desktop/Irene_VectorVEAFiles'); %Path to raw data
%     dum=dir;
%  
%     w = dum(zz);
%     letters = length(w.name);
%     if letters == 43 && strcmp(w.name(41:43), 'vea') == 1
%        fname = w.name;
%        fname2 = w.name(1:letters-4);
%       
%        VectorData = importdata(fname);
%       
%        cd ('/home/mwengrove/Desktop/Irene_VectorVEAFiles/Vector_Irene_MAT') %Path where you want to save data
%     save(fname2,'VectorData')
%     else
%     end
% end
% 
% 
% %VectorDatFile = importdata('Vector_2011_165_02_64_100.dat'); Format for
% %file name
% 
% %Format of VectorData files
% 
% % % VEA Headers
% % 1 - Month
% % 2 - Day
% % 3 - Year
% % 4 - Hr
% % 5 - Min
% % 6 - Sec
% % 7 - ?
% % 8 - Error Code
% % 9 - ?
% % 10 - Battery Voltage (V)
% % 11 - Speed of Sound (m/s)
% % 12 - Heading (deg)
% % 13 - Pitch (deg)
% % 14 - Roll (deg)
% % 15 - Pressure (dBar)
% % 16 - Temp
% % 17 - Analogue Imput 1
% % 18 - Analogue Imput 2
% % 19 - Vel X (m/s)
% % 20 - Vel Y (m/s)
% % 21 - Vel Z (m/s)
% % 22 - Amplitude (1)
% % 23 - Amplitude (2)
% % 24 - Amplitude (3)
% % 25 - Correlation 1 (%)
% % 26 - Correlation 2 (%)
% % 27 - Correlation 3 (%)


%% %'DAT';
    % cd('/Users/karak/Documents/UNH/GreatBayAug2015/Data/Vector/ConvertedFiles/219c')
   % dat=dir('*.dat');
    
    sen = dir('*.sen');
       fname2 = sen.name;
       sen1 = load(fname2);
       %startSen = 1;
       freq_inst = 32; %measuring at 32 hz

       
       
main = ('/Users/karak/Documents/UNH/GreatBayAug2015/Data/Vector/ConvertedFiles/');  %calls on main directory containing data files
       
directoryNames =  struct2cell(dir('/Users/karak/Documents/UNH/GreatBayAug2015/Data/Vector/ConvertedFiles/*c'))';  %creates array of cells containing all files in directory ending in 'c'
       
for kk=1:length(directoryNames);
    myFile(kk,1) = fullfile(main,directoryNames(kk)); 
end


for zz=1:length(myFile) %loops through each file in 'directoryNames'
    cd(char(myFile(zz)))
    clearvars -except zz dat startSen sen1 freq_inst directoryNames myFile;
    close all;
    clc;
    %cd ('/Volumes/MEGAPEX_1/Vector_UNH/Converted'); %Path to raw data

    dat=dir('*.dat');
    
   for yy=1:length(dat); 
    w = dat(yy);
       fname = w.name;
       %fname = char(fullfile(myFile(zz),w.name));
       dat1 = load(fname);
    
    %sen data that corresponds to dat data
       lendat = length(dat1(:,1)); 
       pts_sen = lendat/freq_inst;
       %endSen = startSen+pts_sen-1;
       
           Vector_UNH.Time = sen1(:,1:6); %month,day,year,hr,min,sec
           Vector_UNH.Heading = sen1(:,11);%          (deg)
           Vector_UNH.Pitch = sen1(:,12);%         (deg)
           Vector_UNH.Roll = sen1(:,13);%          (deg)
           Vector_UNH.SoundSpeed = sen1(:,10);%                (counts)
           Vector_UNH.Temp = sen1(:,14);%                (counts)
  
               Vector_UNH.Ensemble_counter = dat1(:,2);
               Vector_UNH.Velocity_East = dat1(:,3);%          (m/s)
               Vector_UNH.Velocity_North = dat1(:,4);%         (m/s)
               Vector_UNH.Velocity_Up = dat1(:,5);%          (m/s)
               Vector_UNH.Amp_1 = dat1(:,6);%                (counts)
               Vector_UNH.Amp_2 = dat1(:,7);%                (counts)
               Vector_UNH.Amp_3 = dat1(:,8);%                (counts)
               Vector_UNH.SNR_1 = dat1(:,9);%                   (dB)
               Vector_UNH.SNR_2 = dat1(:,10);%                   (dB)
               Vector_UNH.SNR_3 = dat1(:,11);%                   (dB)
               Vector_UNH.Correlation_1 = dat1(:,12);%             (%)
               Vector_UNH.Correlation_2 = dat1(:,13);%             (%)
               Vector_UNH.Correlation_3 = dat1(:,14);%             (%)
               Vector_UNH.Pressure = dat1(:,15);%                       (dbar)
               Vector_UNH.Checksum = dat1(:,18);%                      (1=failed)
               
               
               ydSen = date_to_yearday(Vector_UNH.Time(:,3),Vector_UNH.Time(:,1),Vector_UNH.Time(:,2),Vector_UNH.Time(:,4),Vector_UNH.Time(:,5),Vector_UNH.Time(:,6));
               cntr =1;
               for nn = 1:length(ydSen)
                   for mm = 1:freq_inst;
                       ydDat(cntr) = ydSen(nn)+mm*((1/freq_inst)/60/60/24);
                       cntr = cntr+1;
                   end
               end
               Vector_UNH.ydSen = ydSen;
               Vector_UNH.ydDat = ydDat;
               
               fnameStore = strcat(fname(1:end-4),'.mat');
               %cd ('/Users/meaganwengrove/Documents/Sync/MegaPEX/Data/Vector_UNH/MatFiles') %Path where you want to save data
               save(fnameStore,'Vector_UNH','-v7.3')
               
               %startSen = endSen+1;
                
   end
   
end

       
       
       
% Format for .dat and .sen files
% [C:\Users\Cstl\MegaPex\Vector_UNH\UNHV_102.dat]
%  1   Burst counter
%  2   Ensemble counter                 (1-65536)
%  3   Velocity (Beam1|X|East)          (m/s)
%  4   Velocity (Beam2|Y|North)         (m/s)
%  5   Velocity (Beam3|Z|Up)            (m/s)
%  6   Amplitude (Beam1)                (counts)
%  7   Amplitude (Beam2)                (counts)
%  8   Amplitude (Beam3)                (counts)
%  9   SNR (Beam1)                      (dB)
% 10   SNR (Beam2)                      (dB)
% 11   SNR (Beam3)                      (dB)
% 12   Correlation (Beam1)              (%)
% 13   Correlation (Beam2)              (%)
% 14   Correlation (Beam3)              (%)
% 15   Pressure                         (dbar)
% 16   Analog input 1
% 17   Analog input 2
% 18   Checksum                         (1=failed)
% 
% ---------------------------------------------------------------------
% [C:\Users\Cstl\MegaPex\Vector_UNH\UNHV_102.sen]
%  1   Month                            (1-12)
%  2   Day                              (1-31)
%  3   Year
%  4   Hour                             (0-23)
%  5   Minute                           (0-59)
%  6   Second                           (0-59)
%  7   Error code
%  8   Status code
%  9   Battery voltage                  (V)
% 10   Soundspeed                       (m/s)
% 11   Heading                          (degrees)
% 12   Pitch                            (degrees)
% 13   Roll                             (degrees)
% 14   Temperature                      (degrees C)
% 15   Analog input
% 16   Checksum                         (1=failed)



% %% fix f...ing time
% Vec_mat = dir('*.mat'); % list of files ending w/
% cc = 1;
% yd_Sen(1) = date_to_yearday(2015,2,4,10,0,0); %this is when Vector started.. something is wrong with the way the time stamps got divided in the burst files.. so need to fix. 
% hrcntr=10; %start hour for first file
% daycntr = 4; %start day for first file
% monthcntr = 2; %start month for first file
% second = repmat(0:59,1,45)';
% year = repmat(2015,1,2700)';
% 
% minute = zeros(60,1);
% num = 1;
% for qq = 1:44;
%     mindum(:,1) = repmat(num,1,60);
%     num = num+1;
%     minute = vertcat(minute,mindum);
% end
% 
% %fix Vector_UNH.Time
% for kk = 1:length(Vec_mat)
%     file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder
% 
%     load(Vec_mat(file2loadVec).name);
%     
%     day = repmat(daycntr,1,2700)';
%     hour = repmat(hrcntr,1,2700)';
%     month = repmat(monthcntr,1,2700)';
%     
%     Vector_UNH.TimeCorrect = [year,month,day,hour,minute,second];
%     
%     hrcntr = hrcntr+1;
%     if hrcntr == 24;
%         hrcntr = 0;
%         daycntr = daycntr+1;
%     end
%     if daycntr == 29; %28 days in Feb, if it exceeds then change.
%         daycntr = 1;
%         monthcntr = 3;
%     end
% 
%     fnameStore = Vec_mat(kk).name;
%     save(fnameStore,'Vector_UNH','-v7.3')
%     
% end
% 
% 
% for kk = 1:length(Vec_mat)
% 
%      file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder
% 
%     load(Vec_mat(file2loadVec).name);
%     
%     %[Vector_UNH.cVelocity_East,Vector_UNH.cVelocity_North,Vector_UNH.cVelocity_Up,inuv,inw]=cleanup_adv([Vector_UNH.Velocity_East, Vector_UNH.Velocity_North, Vector_UNH.Velocity_Up],[Vector_UNH.SNR_1, Vector_UNH.SNR_2,Vector_UNH.SNR_3],[Vector_UNH.Correlation_1, Vector_UNH.Correlation_2,Vector_UNH.Correlation_3],freq_inst,upwardlooking,use_snr,use_corr,use_phase);
%                
%                
% 
%            ydSen = date_to_yearday(Vector_UNH.TimeCorrect(:,1),Vector_UNH.TimeCorrect(:,2),Vector_UNH.TimeCorrect(:,3),Vector_UNH.TimeCorrect(:,4),Vector_UNH.TimeCorrect(:,5),Vector_UNH.TimeCorrect(:,6));
%                cntr =1;
%                for nn = 1:length(ydSen)
%                    for mm = 1:freq_inst;
%                        ydDat(cntr) = ydSen(nn)+mm*((1/freq_inst)/60/60/24);
%                        cntr = cntr+1;
%                    end
%                end
%                
%                Vector_UNH.ydSen = ydSen;
%                Vector_UNH.ydDat = ydDat;
%     
%     fnameStore = Vec_mat(kk).name;
%                save(fnameStore,'Vector_UNH','-v7.3')
% end
% 
% %% clean up data
% 
% Vec_mat = dir('*.mat'); 
% 
% for kk = 1:length(Vec_mat)
% 
%      file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder
% 
%     load(Vec_mat(file2loadVec).name);
%     
%     %[Vector_UNH.cVelocity_East,Vector_UNH.cVelocity_North,Vector_UNH.cVelocity_Up,inuv,inw]=cleanup_adv([Vector_UNH.Velocity_East, Vector_UNH.Velocity_North, Vector_UNH.Velocity_Up],[Vector_UNH.SNR_1, Vector_UNH.SNR_2,Vector_UNH.SNR_3],[Vector_UNH.Correlation_1, Vector_UNH.Correlation_2,Vector_UNH.Correlation_3],freq_inst,0,1,1,1);
%        Vector_UNH.cVelocity_East = medfilt1(Vector_UNH.cVelocity_East,5);
%        Vector_UNH.cVelocity_North = medfilt1(Vector_UNH.cVelocity_North,5);
%        Vector_UNH.cVelocity_Up = medfilt1(Vector_UNH.cVelocity_Up,5);
%     
%     fnameStore = Vec_mat(kk).name;
%                save(fnameStore,'Vector_UNH','-v7.3')
% end
%                
% %% Plotting
% for kk = 1:length(Vec_mat)
% 
%      file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder
% 
%     load(Vec_mat(file2loadVec).name);
% 
% plot(Vector_UNH.ydDat,Vector_UNH.Velocity_East,'b')
% hold on
% plot(Vector_UNH.ydDat,Vector_UNH.Velocity_North,'r')
% plot(Vector_UNH.ydDat,Vector_UNH.Velocity_Up,'g')
% 
% end
% 
% % ax(1) = subplot(2,1,1);
% % plot(Vector_UNH.Pressure); hold on;
% % ax(2) = subplot(2,1,2);
% % plot(Vector_UNH.Velocity_East); hold on;
% % plot(Vector_UNH.Velocity_North,'r');
% % plot(Vector_UNH.Velocity_Up,'g');
% % linkaxes([ax(1) ax(2)], 'x');
% 
% %[SSband, freqBand, DOF, Gj] = spectrum_mew(Vector_UNH.Velocity_East(7039000:8975000),10,1,1/64);