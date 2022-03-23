% Close all open figures
clear all 
clear;clc;
close ALL 
delete(instrfindall);

% Initializing Arduino 
arduinoObj = arduino('COM7','Uno','Libraries','Ultrasonic');
ultrasonicObj = ultrasonic(arduinoObj,'D10','D9'); % trig D10  %echo D9

%% Acquiring and Displaying Live Data: (Distance, Voltage)

% Setting up the figures
figure(1)

% Distance Plot
subplot(2,1,1) 
d = animatedline; 
dx = gca;
dx.YGrid = 'on';
dx.YLim = [0 200];
xlabel('Elapsed time (sec)');
ylabel('Distance in cm');
title('Aquiring Live Distance Data'); 

% Velocity Plot
subplot(2,1,2) 
v = animatedline;
vx = gca;
vx.YGrid = 'on';
vx.YLim = [0 10];
xlabel('Elapsed time (sec)');
ylabel('Voltage in V');
title('Aquiring Live Voltage Data');

% Get the key currently pressed
key = get(gcf,'CurrentKey'); 

% Setting start time for live plot
startTime = datetime('now');
while  (strcmp(key, 's') == 0 )  % Press 'S' Key to STOP Live Acquisition
    
    % get the key currently pressed
    key = get(gcf,'CurrentKey'); 
    
    % Getting Values
    distance = readDistance(ultrasonicObj) * 100;  % Distance 
    voltage = readVoltage(arduinoObj,'A0');        % Voltage 
    
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
    
    
    % Update axes
    dx.XLim = datenum([t-seconds(15) t]); 
    vx.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    datetick('x','keeplimits')
    drawnow
    
end

% Output message
if (strcmp(key, 's') == 0 )
    disp('Live Data acquisition ended because the TIME limit has been reached! ')
   
else
    disp('Live Data acquisition ended because the STOP button has been pressed! ')
end
%% Data Acquisition (Distance, Velocity, Voltage)

% creatime time axis, Distance array
[DistTimeLogs,DistanceLogs] = getpoints(d);
DistTimeSecs = (DistTimeLogs-DistTimeLogs(1))*24*3600;

% creatime time axis, Voltage array
[VoltTimeLogs,VoltageLogs] = getpoints(v);
VoltTimeSecs = (VoltTimeLogs-VoltTimeLogs(1))*24*3600;

% Solve for Velocity by getting the slope
% Creating a Dist vs Time Table
T = table(DistTimeSecs',DistanceLogs','VariableNames',{'Time_sec','Distance'});
% Setting Time as the first column 
time = T{:,1};
Position = hypot(T{:,1},T{:,2});
Velocity = gradient(Position)./gradient(T{:,1}); 
T2 = table(Position,Velocity, 'VariableNames',{'Position','Velocity'});

%% Plotting Total Data

% Setting Second Figure
figure(2)
% Plotting Distance vs. Time
subplot(3,1,1)
plot(DistTimeSecs,DistanceLogs)
xlabel('Elapsed time (sec)')
ylabel('Distance in cm')
title('Total Recorded Distance Data');

% Plotting Velocity vs. Time
subplot(3,1,2)
plot(time,Velocity);
xlabel('Total Elasped Time');
ylabel('Velocity in m/s');
title('Velocity of Winch') ;

% Plotting Voltage vs. Time
subplot(3,1,3)
plot(VoltTimeSecs,VoltageLogs)
xlabel('Elapsed time (sec)')
ylabel('Distance in cm')
title('Total Recorded Voltage Data');


%% Save results to a file
% Creating Table 
Final_T = table(DistTimeSecs',DistanceLogs',Velocity,VoltageLogs','VariableNames',{'Time_sec','Distance','Velocity','Voltage'});

% Saving File Version through current time
outputName = 'Output_Data_Dx_Vms_V_';
date = datestr(now,'mm.dd.yy');
currentTime = datestr(now,'HH.MM.SS');
fileType = '.xlsx';

% Filename eg: 'Output_Data_Distance_02.21.22_17.22.49.xlsx'
filename = strcat(outputName,date,'_',currentTime,fileType);


% Establishing Current Folder Location
CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Distance Sensor\MATLAB'; %Input Desired/Current Folder Location
DataOutput = 'Data Output';
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
        length(DistTimeSecs),filename)   
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
        length(DistTimeSecs),filename)   
    
    % Print Folder Location confirmation to command line
    fprintf('\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
    fprintf(['Folder: "%s" was NOT found in directory, so a new folder: "%s" was created! \n'...
            'File: "%s" was saved to folder: "%s" \n'],DataOutput,DataOutput,filename,DataOutput)
    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
end


