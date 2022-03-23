%=================================================================
% Creates a real time graph from 1 data received from serial
% Each data packet should be 1 single byte
% Change the COM name to the one you want in the function serial()
%=================================================================

% delete all serial ports from memory 
% important, if you the code is stopped without closing and deleting the
% used COM, you need to do this to open it again
clear all 
delete(instrfindall);
%AU = arduino('COM7','Uno' );

%%AU = arduino('COM7','Uno' );
% Init and open the serial port
%s = arduino('COM7', 'Uno','baudrate', 115200);
serialMonitor = serial('COM7','BaudRate',115200);

fopen(serialMonitor);



points = 100; %number of points on the graph at all times
data_period = 50; %data period in milliseconds 
%x will be the time axis. The time between points is defined by
%"data_period"
x = linspace(-points*data_period, 0, points);

%y will hold the distance, for now all values will be 0 and will have the
%size defined by "points"
y = linspace(0,0,points);

% Setting Operating Frequency 
Fs = 40000;   %40KHz
dT = 1/Fs;



%close all open figures
close ALL
% draw a area graph with parameter x and y. Save the return value so we can
% edit the graph later. You can use "plot" instead of "area", I just liked
% the aspect better.
figure;
lh = area(x,y);



%tic;
% set the x and y axis limits to [0, points*data_period] and [0, 255]
% respectively

% axis([0,-points*data_period, 0, 255]);
    
axis([-points*data_period, 0, 0, 100]);
shg; %brings the figure to the front of all other windows
%waitTime = 5;   
key = get(gcf,'CurrentKey'); %get the key currently pressed
while ( strcmp(key, 's') == 0) %this while will stop if you press the "s" key
    key = get(gcf,'CurrentKey'); %get the key currently pressed
    
    %block until there's at least 1 byte available to read
    while serialMonitor.BytesAvailable == 0 
    end
    
    %push the all the values to the left of the graph 
    for k = 1:1:points-1
       y(k) = y(k+1);
       
     
    end
    
    %read and place value in the right of the graph
    y(points) = fread(serialMonitor,1);
    
   % Tx = ((1:length(y(points)))-1).*dT; 
    
    
    %save the value in distance without a ";" so we can read the number in
    %console
    distance = y(points)
     
    % edit just the data for the y axis on the graph. This is much, much
    % faster than ploting everything over and over again
   % axis([0,(toc), 0, 255]);
    set(lh, 'YData',y);  
   % set(Tx, 'YData',y);
  
    xlabel('time');
    ylabel('distance in cm');
    
       
       
       
       
       
       
       
   
     
  
    %request the plot to be updated
    drawnow;
 
    % store on a Table and print a 
    
end
      
close ALL %close all open figures

fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory
