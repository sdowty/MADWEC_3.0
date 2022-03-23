% Script to test a bundle of 5 DHT22 sensors with an Arduino (Uno)
% microcontroller. Acquire data from the sensors until a stop button is
% pressed on the board or a time limit is reached. Plot last 10 minutes of
% live data during acquisition, the entire data set after the acquisition,
% and save these data on a spreadsheet.


clear all 
delete(instrfindall);

instrreset
clear
clc

% Acquisition time (min). Insert inf to disable time limit.
waitTime = 10;

%%% Acquire and display live data

% Open serial communication
 s = serial('COM7','BaudRate',115200);
 fopen(s);
 
 points = 100;
 idn = linspace(0,0,points);
 
figure
color = ['b'];
for i = 1:1
    h(i) = animatedline('Color',color(i),'LineWidth',2);
end
axh = gca;
axh.YGrid = 'on';
axh.YLim = [0 400];
xlabel('Time')
ylabel('Distance (%)')
legend('Distance measured')



stop = false;
waitTime = duration(0,waitTime,0);
startTime = datetime('now');
t = datetime('now') - startTime;

while ~stop && t < waitTime
    
    % Read data from serial port
   
    idn(points) = fread(s);
    fclose(s);
    
    % Separate data
    C = idn;
    
    % Display data in MATLAB command window
    serialData = C;
    
    % Humidity correction factor from measurement of sensor 5
    corrData = serialData;
    % First acquisition should be without correction. For the first time leave lines 66 to 68 commented. I have used an external tool to verify temperature and humidity readings and it appeared that sensor number 5 read both correctly in several condition. I have written the humCorr.m function to fix the other sensors readings from the value of sensor 5. If interested in correction, manipulate humCorr.m function and/or the following lines according to your needs.
    %for i = 1:4
    %   corrData(i) = serialData(i) * humCorr(serialData(5),i);
    %end
    
    disp(corrData)
    
    % Get current time
    t = datetime('now') - startTime;
       
    % Add points to animation (humidity data)
    for i = 1:1
        addpoints(h(i),datenum(t),corrData(i))
    end
    
    % Update axes
    axh.XLim = datenum([t-seconds(600) t]);
    datetick('x','keeplimits')
    drawnow
    
    
    
    % Check stop condition from serial monitor
    if corrData == 999
        stop = true;
    end
end

% Output message
if stop
    disp('Data acquisition ended because the STOP button has been pressed')
else
    disp('Data acquisition ended because the TIME limit has been reached')
end

%%% Plot the recorded data

for i = 1:1
    [~,humLogs(i,:)] = getpoints(h(i));
    [timeLogs,tempLogs(i,:)] = getpoints(h(i));
end
timeSecs = (timeLogs-timeLogs(1))*24*3600;

figure
subplot(1,2,1)
plot(timeSecs,humLogs,'LineWidth',2)
grid on
ax = gca;
ylim([round(ax.YLim(1)-2), round(ax.YLim(2)+2)])
xlabel('Elapsed time (s)')
ylabel('Distance')



