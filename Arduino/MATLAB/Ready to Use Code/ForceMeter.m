clc;clear; close all;
%% Initialize Test Parameters
testNumber = 01;
TestNumStr = int2str(testNumber);
date = datestr(now,'mm.dd');
WinchPower = '15%'; % Set Winch Power Percentage
WaveHeight = '0.66m';
DataFolder = strcat(date,' P',WinchPower,' W',WaveHeight,' Test -',TestNumStr);
% Folder Name Ex: '04.05_P15_W0.66_Test1'


%% Reading Force Meter from Matlab File 
 
Folderlocation = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB\Data Output\Force Sensor Outputs';
filename = '02_22_2022_0.66m.xlsx';
Filelocation = fullfile(Folderlocation,filename);

%% Data Acquisation 
ForceReadings = readtable(Filelocation,'Sheet','in','Range','A4:C1000');
ForceReadings(:,2) = []; %Disregard B Culumn
time = ForceReadings{:,1};
forceN = ForceReadings{:,2};


figure('Name','Force Meter Plot');
plot(time,forceN); 
xlabel('Total Elasped Time');
ylabel('Force in Newtons'); 
title('Force Meter Readins');


%% Creating New Folder

CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB'; %Input Desired/Current Folder Location
DataAcquisition = 'Data Acquasition';  
MasterFolderDestination = fullfile(CurrentFolder,DataAcquisition); 

% Output folder
SlaveFolderDestination = fullfile(MasterFolderDestination,DataFolder);
VerUpdate = testNumber + 1;
Ver2Str = int2str(VerUpdate);
FolderVerUpdate =strcat(date,' P',WinchPower,' W',WaveHeight,' Test ',Ver2Str);
VerFolderUpd = fullfile(MasterFolderDestination,FolderVerUpdate);

%{
list=dir(MasterFolderDestination);
for m=length(list):-1:5
  
  [~,name,ext]=fileparts(list.name{m});
  basename=name(1:end-1);             % strip the last two (numeric) characters 
  basenumb=str2num(name(end-1):end);  % convert the numeric characters 
  newnum=basenumb+1;                  % and increment it
  copyfile(list(m).name,fullfile([basename num2str(newnum,'%02d')],ext));
end
%}


% If the Main folder exist, Save file in it
if exist(MasterFolderDestination, 'dir') 

    % if Output Folder exist, to update
    if exist(SlaveFolderDestination, 'dir') 
        mkdir(VerFolderUpd);
        saveas(figure(1), fullfile(VerFolderUpd,'Force Meter Plot'), 'png')
        fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
        fprintf('Data Folder: %s exits! \nSaving new Folder as: %s', DataFolder, FolderVerUpdate);
        
    else % If the folder doesn't exist, create it.
        
        saveas(figure(1), fullfile(SlaveFolderDestination,'Force Meter Plot'), 'png') 
        fprintf('No Duplicate Folder! \nSaving output data in: %s', DataFolder);
    end
    
else % If the folder doesn't exist, create it.
   
    % Creating Folder Directory
    mkdir(SlaveFolderDestination);
    saveas(figure(1), fullfile(SlaveFolderDestination,'Force Meter Plot'), 'png')
    fprintf('Data Acquisition Folder doesnt exist! Folder created!\n');
    fprintf('Output Data Saved in: %s', DataFolder);
end



