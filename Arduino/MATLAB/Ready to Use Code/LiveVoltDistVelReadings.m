% Close all open figures
clear all 
clear;clc;
close ALL 
delete(instrfindall);

% Initializing Arduino 
% COM ports change from computer to computer
% Check by going to the Command Window and entering: 
% arduino()   
% press enter
%change t
arduinoObj = arduino('COM9','Uno','Libraries','Ultrasonic');
ultrasonicObj = ultrasonic(arduinoObj,'D9','D10'); % trig D9  %echo D10

currentSM =  serial('COM8','BaudRate',9600);

fopen(currentSM); 
%% Acquiring and Displaying Live Data: (Distance, Voltage)

% Setting up the figures
figure(1)

% Distance Plot
%subplot(3,1,1) 
d = animatedline; 
dx = gca;
dx.YGrid = 'on';
dx.YLim = [0 200];
xlabel('Elapsed time (sec)');
ylabel('Distance in cm');
title('Aquiring Live Distance Data'); 

% Voltage Plot
figure(2)
subplot(2,1,1) 
v = animatedline;
vx = gca;
vx.YGrid = 'on';
%vx.YLim = [0 10];
xlabel('Elapsed time (sec)');
ylabel('Voltage in V');
title('Aquiring Live Voltage Data');

%figure(3)
% Current Plot
subplot(2,1,2) 
c = animatedline;
cx = gca;
cx.YGrid = 'on';
%cx.YLim = [0 500];
xlabel('Elapsed time (sec)');
ylabel('Current in mA')
title('Aquiring Live Current Data');

% Get the key currently pressed
key = get(gcf,'CurrentKey'); 

% Setting start time for live plot
startTime = datetime('now');

% Distance Readings
while  (strcmp(key, 's') == 0 )  % Press 'S' Key to STOP Live Acquisition
    
    % get the key currently pressed
    key = get(gcf,'CurrentKey'); 
      
    %block until there's at least 1 byte available to read
  %  while currentSM.BytesAvailable == 0 
        
   % end
  
    % Getting Values
    distance = readDistance(ultrasonicObj) * 100;  % Distance 
    voltage = readVoltage(arduinoObj,'A0') * 11;   % Voltage 
    current = fread(currentSM,1) ;           % Current
    %current = fscanf(currentSM, '%f');
    %current = fread(currenSM, 1, 'float=>long');
    
   %{ 
    % Create median for incoming Distance Value
   for i = 0:1:iterations
       dist = readDistance(ultrasonicObj) * 100;  % Distance 
       distance = distance + dist;
   end 
    
   % distance = distance/iterations; 
       %{  Notes:
          - Issue is that the Iterations take too long in the while loop 
          - Need to find a way to keep the iterations without making loop slow
       %} 
   %}
    
    %get current elasped time for x axis
    t =  datetime('now') - startTime;
           
    % Add points to animation
    addpoints(d,datenum(t),distance)    % Distance 
    addpoints(v,datenum(t),voltage)     % Voltage 
    addpoints(c,datenum(t),current)     % Current
    
    % Update axes
    dx.XLim = datenum([t-seconds(10) t]); 
    vx.XLim = datenum([t-seconds(10) t]);
    cx.XLim = datenum([t-seconds(10) t]);
    datetick('x','keeplimits')
    datetick('x','keeplimits')
    datetick('x','keeplimits')
    drawnow
    
end


% Output message
if (strcmp(key, 's') == 0 )
    disp('Live Data acquisition ended because the TIME limit has been reached! ')
   % close all;
   
else
    disp('Live Data acquisition ended because the STOP button has been pressed! ')
   % close all; 
end
%% Data Acquisition (Distance, Velocity, Voltage)

% creatime time axis, Distance array
[DistTimeLogs,DistanceLogs] = getpoints(d);
DistTimeSecs = (DistTimeLogs-DistTimeLogs(1))*24*3600;

% creatime time axis, Voltage array
[VoltTimeLogs,VoltageLogs] = getpoints(v);
VoltTimeSecs = (VoltTimeLogs-VoltTimeLogs(1))*24*3600;

% creatime time axis, Current array
[CurrTimeLogs,CurrentLogs] = getpoints(c);
CurrTimeSecs = (CurrTimeLogs-CurrTimeLogs(1))*24*3600;


% Solve for Velocity by getting the slope
% Creating a Dist vs Time Table
Tv = table(DistTimeSecs',DistanceLogs','VariableNames',{'Time_sec','Distance'});
% Setting Time as the first column 
timeV = Tv{:,1};
Position = hypot(Tv{:,1},Tv{:,2});
Velocity = gradient(Position)./gradient(Tv{:,1}); 
T2 = table(Position,Velocity, 'VariableNames',{'Position','Velocity'});

% Solve for output power by getting the slope
% Creating a Dist vs Time Table

Tp= table(VoltTimeSecs',VoltageLogs',CurrentLogs','VariableNames',{'Time_sec','Distance','Current'});
% Setting Time as the first column 
timeP = Tp{:,1};
V  = Tp{:,2};
I = Tp{:,3};
Output_Power = gradient(V) .* gradient(I); 
T2 = table(timeP,Output_Power, 'VariableNames',{'time','Output Power'});

%% Plotting Total Data

% Setting Second Figure
figure(3)
% Plotting Distance vs. Time
subplot(2,1,1)
plot(DistTimeSecs,DistanceLogs)
xlabel('Elapsed time (sec)')
ylabel('Distance in cm')
title('Total Recorded Distance Data');

% Plotting Velocity vs. Time
subplot(2,1,2)
plot(timeV,Velocity);
xlabel('Total Elasped Time');
ylabel('Velocity in cm/s');
title('Velocity of Winch') ;



figure(4)
% Plotting Voltage vs. Time
subplot(2,1,1)
plot(VoltTimeSecs,VoltageLogs)
xlabel('Elapsed time (sec)')
ylabel('Voltage in (V)')
title('Total Recorded Voltage Data');

% Plotting Current vs. Time
subplot(2,1,2)
plot(CurrTimeSecs,CurrentLogs)
xlabel('Elapsed time (sec)')
ylabel('Current in mA')
title('Total Recorded Current Data');

% Plotting Output Power vs. Time
figure(5)
plot(timeP,Output_Power)  %Magnitude removes the Negative  on the graphs
xlabel('Elapsed time (sec)')
ylabel('Power in mW')
title('Total Recorded Power Data');


%% Save results to a file
% Creating Table 
Final_T = table(DistTimeSecs',DistanceLogs',Velocity,VoltageLogs','VariableNames',{'Time_sec','Distance','Velocity','Voltage'});

% Saving File Version through current time
outputName = 'Output_Data_DVI_';
date = datestr(now,'mm.dd.yy');
currentTime = datestr(now,'HH.MM.SS');
fileType = '.xlsx';

% Filename eg: 'Output_Data_Distance_02.21.22_17.22.49.xlsx'
filename = strcat(outputName,date,'_',currentTime,fileType);


% Establishing Current Folder Location
CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB'; %Input Desired/Current Folder Location
DataOutput = 'Data Output';
FolderDestination = fullfile(CurrentFolder,DataOutput);  

% Individual Data Folders THat will have Excel Sheets and Figures
%DataFolder = strcat(outputName,date,CurrentTime);

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
        length(DistTimeSecs),filename)   
    % Print Folder Location confirmation to command line
    fprintf(['\nFolder: "%s" was found in directory. \n'...
            'File: "%s" was saved to folder: "%s" \n'],DataOutput,filename,DataOutput)
        
else % If the folder doesn't exist, create it.
   
    % Creating Folder Directory
    mkdir(fullfile(FolderDestination,DataFolder));

    % Delete previous file, if exists, to avoid append of data
    if isfile(fullfile(FolderDestination,filename))
        delete(fullfile(FolderDestination,filename))
        fprintf('Deleted duplicate filename %s to be replaced with current filename "%s"\n\n',filename,filename)
    end  
    
    % Write table to file and save it to folder location
    writetable(Final_T, fullfile(FolderDestination,filename))
    
    % Print Data Confirmation to command line
    fprintf('\nResulting Table: \n %g Measurements of Distances, Velocity & Voltage  \nSaved to file:\n "%s"\n',...
        length(DistTimeSecs),filename)   
    
    % Print Folder Location confirmation to command line
    fprintf('\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
    fprintf(['Folder: "%s" was NOT found in directory, so a new folder: "%s" was created! \n'...
            'File: "%s" was saved to folder: "%s" \n'],DataOutput,DataOutput,filename,DataOutput)
    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
end

%% Clearing serial monitor
fclose(currentSM); %close serial port
delete(currentSM); %remove serial port from memory

