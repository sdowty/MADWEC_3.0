clear all
%setting arduino to port output from pc 
AU = arduino('COM7','Uno', 'Libraries', 'Ultrasonic' );


% Creating Ultrasonic sensor with trigger pin D12 & Echo pin D13
sensor = ultrasonic(AU,'D12', 'D13');  

% Measuring Time 
%t = readTravelTime(sensor); 
%distCM = (0.340.*t)/2 
%sprintf('Current Distance in cm: %.2f \n', distCM)

% Measuring Distance 
DistRead = readDistance(sensor);  %Read in meters 

%Distance conversion to cm and inch
cmDist = DistRead *100;    
inchDist = DistRead *39.3700787;
fprintf('Distance in cm: %.2f \n', DistRead);
fprintf('Distance in cm: %.2f \n', cmDist);
fprintf('Distance in cm: %.2f \n', inchDist);
%clear sensor ; 
%clear AU;
%}