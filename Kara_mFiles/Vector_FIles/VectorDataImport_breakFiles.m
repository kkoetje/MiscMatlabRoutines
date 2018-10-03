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
    path = ('/Users/meaganwengrove/Documents/Sync/MegaPEX/Data/Vector_NRL');
    cd(path);
    dat=dir('*.dat');
    sen=dir('*.sen');
    freq_inst = 64;

for zz=3:4 %length of dir
    cd(path)
    clearvars -except zz dat sen path freq_inst;
    close all;
    clc;
    %cd ('/Volumes/MEGAPEX_1/Vector_UNH/Converted'); %Path to raw data
    Vector_UNH.freq_inst = freq_inst;
    
    w = dat(zz);
       fname = w.name;
       dat1 = load(fname);
    
    b = sen(zz);
       fname2 = b.name;
       sen1 = load(fname2);
       indvDays = unique(sen1(:,2)); 
       numData = hist(sen1(:,2),length(indvDays),'values');
       %numData = hist(sen1(1:41649,2),length(indvDays),'values'); %number of data points for sen file in each day
       startSen = 1;
       endSen = numData(1);
       startDat = 1;
       endDat = endSen*Vector_UNH.freq_inst;
       
       for kk = 1:length(indvDays)
           Vector_UNH.Time = sen1(startSen:endSen,1:6); %month,day,year,hr,min,sec
           Vector_UNH.Heading = sen1(startSen:endSen,11);%          (deg)
           Vector_UNH.Pitch = sen1(startSen:endSen,12);%         (deg)
           Vector_UNH.Roll = sen1(startSen:endSen,13);%          (deg)
           Vector_UNH.SoundSpeed = sen1(startSen:endSen,10);%                (counts)
           Vector_UNH.Temp = sen1(startSen:endSen,14);%                (counts)
  
               Vector_UNH.Ensemble_counter = dat1(startDat:endDat,2);
               Vector_UNH.Velocity_East = dat1(startDat:endDat,3);%          (m/s)
               Vector_UNH.Velocity_North = dat1(startDat:endDat,4);%         (m/s)
               Vector_UNH.Velocity_Up = dat1(startDat:endDat,5);%          (m/s)
               Vector_UNH.Amp_1 = dat1(startDat:endDat,6);%                (counts)
               Vector_UNH.Amp_2 = dat1(startDat:endDat,7);%                (counts)
               Vector_UNH.Amp_3 = dat1(startDat:endDat,8);%                (counts)
               Vector_UNH.SNR_1 = dat1(startDat:endDat,9);%                   (dB)
               Vector_UNH.SNR_2 = dat1(startDat:endDat,10);%                   (dB)
               Vector_UNH.SNR_3 = dat1(startDat:endDat,11);%                   (dB)
               Vector_UNH.Correlation_1 = dat1(startDat:endDat,12);%             (%)
               Vector_UNH.Correlation_2 = dat1(startDat:endDat,13);%             (%)
               Vector_UNH.Correlation_3 = dat1(startDat:endDat,14);%             (%)
               Vector_UNH.Pressure = dat1(startDat:endDat,15);%                       (dbar)
               Vector_UNH.Checksum = dat1(startDat:endDat,18);%                      (1=failed)
               
               ydSen = date_to_yearday(Vector_UNH.Time(:,3),Vector_UNH.Time(:,1),Vector_UNH.Time(:,2),Vector_UNH.Time(:,4),Vector_UNH.Time(:,5),Vector_UNH.Time(:,6));
               cntr =1;
               for nn = 1:length(ydSen)
                   for mm = 1:Vector_UNH.freq_inst;
                       ydDat(cntr) = ydSen(nn)+mm*((1/Vector_UNH.freq_inst)/60/60/24);
                       cntr = cntr+1;
                   end
                   
               end
               Vector_UNH.ydSen = ydSen;
               Vector_UNH.ydDat = ydDat;
        
        fnameStore = strcat(fname(1:6),'_',num2str(sen1(startSen,1)),num2str(sen1(startSen,2)),num2str(sen1(startSen,3)),'.mat')
        cd (path) %Path where you want to save data
        save(fnameStore,'Vector_UNH','-v7.3')
        
            if kk<length(indvDays)-1
               startSen = endSen+1;
               endSen = endSen+numData(kk+1);
               startDat = endDat+1;
               endDat = endSen*64;
            else
               startSen = endSen+1;
               endSen = length(sen1);
               startDat = endDat+1;
               endDat = length(dat1);
            end
                
       end
       
end

break

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
% plot(Vector_UNH.Pressure); hold on;
% ax(2) = subplot(2,1,2);
% plot(Vector_UNH.Velocity_East); hold on;
% plot(Vector_UNH.Velocity_North,'r');
% plot(Vector_UNH.Velocity_Up,'g');
% linkaxes([ax(1) ax(2)], 'x');

%[SSband, freqBand, DOF, Gj] = spectrum_mew(Vector_UNH.Velocity_East(7039000:8975000),10,1,1/64);

%% YearDay Calc if didn't work in main code


path = ('/Users/meaganwengrove/Documents/Sync/MegaPEX/Data/Vector_NRL');
    cd(path);
Vec_mat = dir('*.mat'); 
for kk = 1:length(Vec_mat)

    clearvars -except kk Vec_mat
     file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder

    load(Vec_mat(file2loadVec).name);          
               

           %ydSen = date_to_yearday(Vector_UNH.TimeCorrect(:,1),Vector_UNH.TimeCorrect(:,2),Vector_UNH.TimeCorrect(:,3),Vector_UNH.TimeCorrect(:,4),Vector_UNH.TimeCorrect(:,5),Vector_UNH.TimeCorrect(:,6));
               cntr =1;
               for nn = 1:length(Vector_UNH.ydSen)
                   for mm = 1:Vector_UNH.freq_inst;
                       ydDat(cntr) = Vector_UNH.ydSen(nn)+mm*((1/Vector_UNH.freq_inst)/60/60/24);
                       cntr = cntr+1;
                   end
               end
               
               %Vector_UNH.ydSen = ydSen;
               Vector_UNH.ydDat = ydDat;
    
    fnameStore = Vec_mat(kk).name;
               save(fnameStore,'Vector_UNH','-v7.3')
end

%% clean up data

path = ('/Users/meaganwengrove/Documents/Sync/MegaPEX/Data/Vector_NRL');
    cd(path);
Vec_mat = dir('*.mat'); 


for kk = 1:length(Vec_mat)

     file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder

    load(Vec_mat(file2loadVec).name);
    
    [Vector_UNH.cVelocity_East,Vector_UNH.cVelocity_North,Vector_UNH.cVelocity_Up,inuv,inw]=cleanup_adv([Vector_UNH.Velocity_East, Vector_UNH.Velocity_North, Vector_UNH.Velocity_Up],[Vector_UNH.SNR_1, Vector_UNH.SNR_2,Vector_UNH.SNR_3],[Vector_UNH.Correlation_1, Vector_UNH.Correlation_2,Vector_UNH.Correlation_3],Vector_UNH.freq_inst,0,1,1,1);
       Vector_UNH.cVelocity_East = medfilt1(Vector_UNH.cVelocity_East,5);
       Vector_UNH.cVelocity_North = medfilt1(Vector_UNH.cVelocity_North,5);
       Vector_UNH.cVelocity_Up = medfilt1(Vector_UNH.cVelocity_Up,5);
    
    fnameStore = Vec_mat(kk).name;
               save(fnameStore,'Vector_UNH','-v7.3')
end
               
%% Plotting

Vec_mat = dir('*.mat'); 

for kk = 1:length(Vec_mat)-1

     file2loadVec = kk; % loads file equal to number in order from first to last in Aquadopp folder
Vec_mat(file2loadVec).name
    load(Vec_mat(file2loadVec).name);

plot(Vector_UNH.ydDat,Vector_UNH.cVelocity_East,'b')
hold on
plot(Vector_UNH.ydDat,Vector_UNH.cVelocity_North,'r')
plot(Vector_UNH.ydDat,Vector_UNH.cVelocity_Up,'g')

file2loadVec = kk+1; % loads file equal to number in order from first to last in Aquadopp folder
Vec_mat(file2loadVec).name
    load(Vec_mat(file2loadVec).name);

plot(Vector_UNH.ydDat,Vector_UNH.cVelocity_East,'c')
hold on
plot(Vector_UNH.ydDat,Vector_UNH.cVelocity_North,'m')
plot(Vector_UNH.ydDat,Vector_UNH.cVelocity_Up,'y')

pause
clf

end
