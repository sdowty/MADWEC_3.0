clear ALL;
close ALL;
clc;clear;
delete(instrfindall);
%AU = arduino('COM7','Uno' );

%%AU = arduino('COM7','Uno' );
% Init and open the serial port
%s = arduino('COM7', 'Uno','baudrate', 115200);
serialMonitor = serial('COM7','BaudRate',9600);
fopen(serialMonitor);




%% Data Acquisition 
figure(1)
% Current Plot
c = animatedline; 
cx = gca;
cx.YGrid = 'on';
cx.YLim = [0 500];
xlabel('Elapsed time (sec)');
ylabel('Current');
title('Aquiring Live Current Data'); 


key = get(gcf,'CurrentKey');

% Setting start time for live plot
startTime = datetime('now');
while (strcmp(key, 's') == 0 ) 
    key = get(gcf,'CurrentKey');
    
   %block until there's at least 1 byte available to read
    while serialMonitor.BytesAvailable == 0 
    end

   current =  fread(serialMonitor,1);
   
     %get current elasped time for x axis
    t =  datetime('now') - startTime;
           
    % Add points to animation
    addpoints(c,datenum(t),current)     %current

    % Update axes
    cx.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow
    sensorValue = 0;
end
% Output message
if (strcmp(key, 's') == 0 )
    disp('Live Data acquisition ended because the TIME limit has been reached! ')
   
else
    disp('Live Data acquisition ended because the STOP button has been pressed! ')
end
%% Data Acquisition (Current)

% creatime time axis, Current array
[CurrentTimeLogs,CurrentLogs] = getpoints(c);
CurrentTimeSecs = (CurrentTimeLogs-CurrentTimeLogs(1))*24*3600;


%% Plotting Total Data

% Setting Second Figure
figure(2)

% Plotting Current vs. Time
plot(CurrentTimeSecs,CurrentLogs)
xlabel('Elapsed time (sec)')
ylabel('Current in cm')
title('Total Recorded Current Data');

%% Save results to a file
% Creating Table 
Final_T = table(CurrentTimeSecs',CurrentLogs','VariableNames',{'Time_sec','Current'});

% Saving File Version through current time
outputName = 'Output_Data_AMPS_';
date = datestr(now,'mm.dd.yy');
currentTime = datestr(now,'HH.MM.SS');
fileType = '.xlsx';

% Filename eg: 'Output_Data_Distance_02.21.22_17.22.49.xlsx'
filename = strcat(outputName,date,'_',currentTime,fileType);


% Establishing Current Folder Location
CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB\Data Output'; %Input Desired/Current Folder Location
DataOutput = 'Current Data Outputs';
FolderDestination = fullfile(CurrentFolder,DataOutput);

% New Folder Destination
% C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Distance Sensor\MATLAB\Data Output

% If the folder exist, Save file in it
if exist(FolderDestination, 'dir') 

    % Delete previous file, if exists, to avoid append of data
    if isfile(fullfile(FolderDestination,filename))
        delete(fullfile(FolderDestination,filename))
        fprintf('Deleted duplicate filename %s to be replaced with current filename "%s"\n\n',filename,filename)
    end  
    
    % Write table to file and save it to folder location
    writetable(Final_T, fullfile(FolderDestination,filename))
    
    % Print Data confirmation to command line
    fprintf('\nResulting Table: \n %g Measurements of Distances, Velocity & Voltage  \nSaved to file:\n "%s"\n',...
        length(CurrentTimeSecs),filename)   
    % Print Folder Location confirmation to command line
    fprintf(['\nFolder: "%s" was found in directory. \n'...
            'File: "%s" was saved to folder: "%s" \n'],DataOutput,filename,DataOutput)
        
else % If the folder doesn't exist, create it.
   
    % Creating Folder Directory
    mkdir(FolderDestination);

    % Delete previous file, if exists, to avoid append of data
    if isfile(fullfile(FolderDestination,filename))
        delete(fullfile(FolderDestination,filename))
        fprintf('Deleted duplicate filename %s to be replaced with current filename "%s"\n\n',filename,filename)
    end  
    
    % Write table to file and save it to folder location
    writetable(Final_T, fullfile(FolderDestination,filename))
    
    % Print Data Confirmation to command line
    fprintf('\nResulting Table: \n %g Measurements of Distances, Velocity & Voltage  \nSaved to file:\n "%s"\n',...
        length(CurrentTimeSecs),filename)   
    
    % Print Folder Location confirmation to command line
    fprintf('\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
    fprintf(['Folder: "%s" was NOT found in directory, so a new folder: "%s" was created! \n'...
            'File: "%s" was saved to folder: "%s" \n'],DataOutput,DataOutput,filename,DataOutput)
    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
end





%% Clearing serial monitor
fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory