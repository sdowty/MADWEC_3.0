
%setting arduino to port output from pc 
AU = arduino('com4','uno', 'Libraries', 'JRodrigoTech/HCSR04' ); 
% Creating Ultrasonic sensor with trigger pin D2 & Echo pin D3
sensor = addon(AU, 'JRodrigoTech/HCSR04', 'D2', 'D3'); 

% Measuring Time 
t = readTravelTime(sensor); 
distCM = (0.340.*t)/2; 
sprintf('Current Distance in cm: %.2f \n', distCM);

% Measuring Distance 
DistRead = readDistance(sensor); 
sprintf('Distance in cm: %.2f \n', DistRead); 

clear sensor ; 
clear a;
