clear all 
delete(instrfindall);
%AU = arduino('COM7','Uno' );

%%AU = arduino('COM7','Uno' );
% Init and open the serial port
%s = arduino('COM7', 'Uno','baudrate', 115200);
serialMonitor = serial('COM7','BaudRate',115200);

fopen(serialMonitor);




figure
h = animatedline; 
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0 200];

stop = false;
startTime = datetime('now');

while ~stop
dist = fread(serialMonitor,1);
 
    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(h,datenum(t),dist)
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow   
    
end
%% Plot the recorded data
[timeLogs,distanceLogs] = getpoints(h);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
figure
plot(timeSecs,distanceLogs)
xlabel('Elapsed time (sec)')
ylabel('Distance in cm')
%% Smooth out readings with moving average filter
smoothedDist = smooth(distanceLogs,25);
DistanceMax = smoothedDist + 2*9/5;
DistanceMin = smoothedDist - 2*9/5;

figure
plot(timeSecs,distanceLogs, timeSecs,DistanceMax,'r--',timeSecs,DistanceMin,'r--')
xlabel('Elapsed time (sec)')
ylabel('Temperature in cm')
hold on 


%% Clearing serial monitor
close ALL %close all open figures

fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory