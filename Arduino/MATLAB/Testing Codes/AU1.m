clear all 

tic;% begins timer 

delete(instrfindall);
%AU = arduino('COM7','Uno' );

%%AU = arduino('COM7','Uno' );
% Init and open the serial port
%s = arduino('COM7', 'Uno','baudrate', 115200);
serialMonitor = serial('COM7','BaudRate',9600);
fopen(serialMonitor);





close ALL; 
figure; 
x = linspace(0,toc); 




shg; %brings the figure to the front of all other windows
key = get(gcf,'CurrentKey'); %get the key currently pressed
while ( strcmp(key, 's') == 0) %this while will stop if you press the "s" key
    key = get(gcf,'CurrentKey'); %get the key currently pressed
    
    %block until there's at least 1 byte available to read
    while serialMonitor.BytesAvailable == 0 
    end
    
   
    %read and place value in the right of the graph
    y(points) = fread(serialMonitor,1);
    
    %save the value in distance without a ";" so we can read the number in
    %console
    distance = y(points)
   
    % edit just the data for the y axis on the graph. This is much, much
    % faster than ploting everything over and over again
    axis([0,(toc), 0, 255]);
    set(lh, 'YData',y);  
    xlabel('time');
    ylabel('distance in cm');
    
    % Setting a data cursor
     
  
    %request the plot to be updated
    drawnow;
 
    % store on a Table and print a 
    
end
      
close ALL %close all open figures

fclose(serialMonitor); %close serial port
delete(serialMonitor); %remove serial port from memory