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

%% Saving 
filename = 'bob';
filetype = '.txt';
version = 0;
conv = num2str(version);
CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB';

savefile = strcat(filename,conv,filetype);
fileD = fullfile(CurrentFolder,savefile); 

if exist(fileD, 'dir') 
    
    count = fileD.
        version = version +1;
        conv2 = num2str(version);
        verInc = strcat(filename,conv2) ;
       
    
    newsave = fullfile(CurrentFolder,verInc);
    mkdir(newsave)
   %saveas(figure(1), fullfile(newsave,'Force Meter Plot'), 'png')
    fprintf('file exist! Saved new version as %s: ',verInc);
else
   %saveas(figure(1), fullfile(n,'Force Meter Plot'), 'png') \\
   mkdir(fileD)
   fprintf('File didnt exist, so its save');
end
