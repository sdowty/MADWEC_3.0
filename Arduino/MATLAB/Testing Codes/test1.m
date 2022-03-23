  
clear all 
delete(instrfindall);
% Init and open the serial port
serialMonitor = serial('COM7','BaudRate',115200);
fopen(serialMonitor);
%close all open figures
close ALL
time = now; 
loop = 120;
dist = 0;

%% Setting up figure 

plotHandle = plot(time,dist, 'Marker','.');

hold on; 
    ylim([0 100]);
    xlim([min(time) max(time + 0.001)]); 
    xlabel('Time');
    ylabel('Distance');
    title('Real Time Data');
    shg;

%%
dist(1) = 0;
time(1) = 0; 
count = 2;
k = 1;
key = get(gcf,'CurrentKey'); %get the key currently pressed
while ( strcmp(key, 's') == 0) %this while will stop if you press the "s" key
    key = get(gcf,'CurrentKey'); %get the key currently pressed
    
    %block until there's at least 1 byte available to read
    while serialMonitor.BytesAvailable == 0 
    end
    
    %push the all the values to the left of the graph 
   % for k = 1:1:points-1
       %y(k) = y(k+1);
      
   % end
   
  while ~isequal(count,loop) 
    k=k+1;  
    % sets Max number of data points 
    if k==25   
        fclose(serialMonitor);
        delete(serialMonitor);
        close ALL;
        clear serialMonitor;
        serialMonitor = serial('COM7','BaudRate',115200);
        fopen(serialMonitor);
        k=0;
        %Input function to generate data outputs in CSV/EXCEL 
        
    
    end
   %storing serial data in distance
    dist(count) = fread(serialMonitor,1); 
    %setting time for x-axis
    time(count) = count; 
    
    
    set(plotHandle,'YData',dist,'XData',time);
    datetick('x','SS:FFF');
    timeInterval = 0.5; %time between each data point
    pause(timeInterval); 
    count = count +1; 
    
  end
  
end
%% Save results to a file

T = table(time,dist,'VariableNames',...
    {'Time_s','Distance in cm'});
filename = 'DSoutputs.xls';

% Delete previous file, if exists, to avoid append of data
if exist(filename,'file')
    delete(filename)
end

% Write table to file
writetable(T,filename)

% Print confirmation to command line
winopen(filename)
fprintf('Results table with %g distance and time measurements saved to file %s\n',...
    length(time),filename)

%% Clean up the serial port
fclose(serialMonitor);
delete(serialMonitor);
clear serialMonitor;
close ALL %close all open figures

fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory
