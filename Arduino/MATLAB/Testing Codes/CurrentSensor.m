
% Initial Conditions

clear all 
clear;clc;
%close ALL 
delete(instrfindall);

% Initializing Arduino 
arduinoObj = arduino('COM7','Uno','Libraries','Ultrasonic');

% Defining analog pin
analogPin = 'A2';  %A2
Vref = 350; % from Calibration
sensitivity = 1 / 0.264;  % 1000mA per 264mV 
% Take the average of 500 times
averageValue = 10; 
sensorValue = 0;
RefVal = 5.0; 


%% Vref Initial Calibration 
   % Set Reading pins as open and run code to measure voltage 
   % from the analog pin that the arduino is reading from the current sensor 
   
%{
key = get(gcf,'CurrentKey'); 
while (strcmp(key, 'c') == 0)
    % get the key currently pressed
    key = get(gcf,'CurrentKey'); 
    
    for i = 0:1:averageValue
        sensorValue = sensorValue +  readVoltage(arduinoObj,'A1'); 
        pause(.002)
    end
    sensorValue = sensorValue / averageValue; 
  
    voltage = sensorValue * 1000; 
    fprintf('Calibrated Vref Value: %fmV\n ',voltage)
    pause(.250)
end

%}
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
    
   for i = 0:1:averageValue
        sensorValue = sensorValue +  readVoltage(arduinoObj,'A1'); 
        pause(.002)
   end
   Vrefchek = readVoltage(arduinoObj,'A1')* 1000.00
    sensorValue = sensorValue / averageValue; 
   % sensorValue = readVoltage(arduinoObj,'A1'); 
%unitValue = (RefVal / 1024) *1000; 
voltage = 1000 * sensorValue; % in mV

current = (voltage - Vref) * sensitivity;
fprintf('initialValue: %fmV\n ',voltage);
fprintf('current: %f mA\n', current);
  % Reset the sensorValue for the next reading
  %sensorValue = 0;
  % Read it once per second
   % pause(.25)  
    
    
    
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



