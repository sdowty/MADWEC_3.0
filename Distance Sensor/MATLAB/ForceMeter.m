

%% Reading Force Meter from Matlab File 
%[time] = xlsread('02_22_2022_0.66m.xlsx','A5:A');
%[forceN] = xlsread('02_22_2022_0.66m.xlsx','C5:A');
ForceReadings = readtable('02_22_2022_0.66m.xlsx','Sheet','in','Range','A4:C1000');
ForceReadings(:,2) = []; %Disregard B Culumn
time = ForceReadings{:,1};
forceN = ForceReadings{:,2};


figure
plot(time,forceN); 
xlabel('Total Elasped Time');
ylabel('Force in Newtons'); 
title('Force Meter Readins');
%}