clc;
clear all;

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

for zz=7:7 %length of dir
    clearvars -except zz;
    close all;
    clc;
    %cd ('/Volumes/MEGAPEX_1/Vector_UNH/Converted'); %Path to raw data
    cd('/Users/meaganwengrove/Documents/Sync/MegaPEX/Data/Vector_UNH/Converted')
    dat=dir('*.dat');
    sen=dir('*.sen');
 
    w = dat(zz);
       fname = w.name;
       dat1 = load(fname);
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
      
      
    
    sen=dir('*.sen');
    b = sen(zz);
       fname2 = b.name;
       sen1 = load(fname2);
       Vector_UNH.Time = sen1(:,1:6); %month,day,year,hr,min,sec
       Vector_UNH.Heading = sen1(:,11);%          (deg)
       Vector_UNH.Pitch = sen1(:,12);%         (deg)
       Vector_UNH.Roll = sen1(:,13);%          (deg)
       Vector_UNH.SoundSpeed = sen1(:,10);%                (counts)
       Vector_UNH.Temp = sen1(:,14);%                (counts)

        cd ('/Volumes/MEGAPEX_1/Vector_UNH/MatFiles') %Path where you want to save data
        save(fname,'Vector_UNH','-v7.3')
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

%%
% ax(1) = subplot(2,1,1);
% plot(time,Vector_UNH.Pressure); hold on;
% ax(2) = subplot(2,1,2);
% plot(time,Vector_UNH.Velocity_East); hold on;
% plot(time,Vector_UNH.Velocity_North,'r');
% plot(time,Vector_UNH.Velocity_Up,'g');
% linkaxes([ax(1) ax(2)], 'x');

%[SSband, freqBand, DOF, Gj] = spectrum_mew(Vector_UNH.Velocity_East(7039000:8975000),10,1,1/64);