clear all 
clear;clc;
close ALL %close all open figures
delete(instrfindall);
%AU = arduino('COM7','Uno' );

%%AU = arduino('COM7','Uno' );
% Init and open the serial port
%a = arduino('COM7', 'Uno','baudrate', 115200);
%a = arduino; 
serialMonitor = serial('COM7','BaudRate',115200);
fopen(serialMonitor);

%fopen(a);

%% Acquiring and Displaying Live Data
figure(1)
subplot(2,1,1) 
h = animatedline; 
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0 200];
xlabel('Elapsed time (sec)');
ylabel('Distance in cm');
title('Aquiring Live Data'); 


stop = false;
startTime = datetime('now');
% Acquisition time (min). Insert inf to disable time limit.
waitTime = .5;  %time limit on data recorded

%get the key currently pressed
key = get(gcf,'CurrentKey'); 

%Message to know status of Serial Monitor
if serialMonitor.BytesAvailable == 0 
    fprintf('Serial Monitor is open and sending distance readings to Matlab! \n');
end

% setting timer for function to stop taking data 
maxDuration = 60; % 60 second 
timer = timer('TimerFcn', 'stat=false; disp(''Time Limit for Data Acquisition has be reached!'')',... 
                 'StartDelay', maxDuration ); %30 second timer
start(timer)
k = 0;
stat=true;
while(stat==true)
  %disp('.')
  k = k + 1;
  pause(1) %1 sec
end

while  (strcmp(key, 's') == 0 &&  k == maxDuration) %this while will stop if you press the "s" key
    
    %get the key currently pressed
    key = get(gcf,'CurrentKey'); 
    
    %block until there's at least 1 byte available to read
    while serialMonitor.BytesAvailable == 0 
        
    end
    
    % Read distaance value from serial monitor
    dist = fread(serialMonitor,1);
    
    %get current elasped time for x axis
    t =  datetime('now') - startTime;
    
   % voltage = readVoltage(serialMonitor,'A3')
        
    % Add points to animation
    addpoints(h,datenum(t),dist)
    
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow   
  
end

% Output message
if (strcmp(key, 's') == 0 && k == maxDuration)
    disp('Data acquisition ended because the TIME limit has been reached')
   
    % reset timer
    k = 0;
    delete(timer);
else
    disp('Data acquisition ended because the STOP button has been pressed')
   
    % reset timer
    k = 0;
    delete(timer);
end

%% Plot the recorded data
% creatime time axis, distance array
[timeLogs,distanceLogs] = getpoints(h);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
figure(2)
plot(timeSecs,distanceLogs)
xlabel('Elapsed time (sec)')
ylabel('Distance in cm')
title('Total Recorded Data');

%% Save results to a file
% Creating Table 
T = table(timeSecs',distanceLogs','VariableNames',{'Time_sec','Distance'});

%Saving File Version through current time
outputName = 'Output_Data_Distance_';
date = datestr(now,'mm.dd.yy');
currentTime = datestr(now,'HH.MM.SS');
fileType = '.xlsx';

%Filename eg: 'Output_Data_Distance_02.21.22_17.22.49.xlsx'
filename = strcat(outputName,date,'_',currentTime,fileType);

% Delete previous file, if exists, to avoid append of data
if isfile(filename)
    delete(filename)
    fprintf('Deleted duplicate filename %s to be replaced with current filename %s\n',filename,filename)
end  

% Write table to file 
writetable(T,filename)

% Print confirmation to command line
fprintf('Results table with %g Distances measurements saved to file %s\n',...
    length(timeSecs),filename)

%% Clearing serial monitor
fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory
%fclose(a);
%delete(a);

%fclose(a); 
%delete(a); 
