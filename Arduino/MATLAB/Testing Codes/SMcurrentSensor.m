clear all 
delete(instrfindall);
%AU = arduino('COM7','Uno' );

%%AU = arduino('COM7','Uno' );
% Init and open the serial port
%s = arduino('COM7', 'Uno','baudrate', 115200);
serialMonitor = serial('COM7','BaudRate',9600);
fopen(serialMonitor);




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
    
   %block until there's at least 1 byte available to read
    while serialMonitor.BytesAvailable == 0 
    end

   current =  fread(serialMonitor,1);

    
    
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



%% Clearing serial monitor
fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory