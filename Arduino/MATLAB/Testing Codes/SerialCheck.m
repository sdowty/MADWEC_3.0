 % Close all open figures
clear all 
clear;clc;
close ALL 
delete(instrfindall);

%% Initialize Test Parameters
fprintf('Initialize Testing Parameter\n');
testPrompt = 'Test number (#): ';
powPrompt = 'Winch Power (%): ';
wavPrompt = 'Wave Height (m): ';

TestInput = input(testPrompt);
PowInput = input(powPrompt);
WavInput = input(wavPrompt);

T = num2str(TestInput);
P = num2str(PowInput);
H = num2str(WavInput);
% date = datestr(now,'mm.dd');
% DataFolder = strcat(date,' P', P,' W',H,' Test - ',T);
% Folder Name Ex: '04.05_P15_W0.66_Test - 1'

%% Initializing Arduino 
%arduinoObj = arduino('COM7','Uno','Libraries','Ultrasonic');
%ultrasonicObj = ultrasonic(arduinoObj,'D9','D10'); % trig D10  %echo D9
SERIAL =  serial('COM7','BaudRate',115200);
fopen(SERIAL); 
%% Acquiring and Displaying Live Data: (Distance, Voltage)

% Setting up the figures
 f1 = figure('Name','Voltage and Current');
 f1.WindowState = 'maximized';
%movegui(f1,'east','onscreen');
% Voltage and Current Plot
subplot(2,2,2) 
c = animatedline; 
cx = gca;
cx.YGrid = 'on';
%dx.YLim = [0];
xlabel('Elapsed time (sec)');
ylabel('Current in mA');
title('Aquiring Live Current Data'); 

% Voltage Plot
subplot(2,2,4) 
v = animatedline;
vx = gca;
vx.YGrid = 'on';
vx.YLim = [0 10];
xlabel('Elapsed time (sec)');
ylabel('Voltage in V');
title('Aquiring Live Voltage Data');

% Distance Plot
%f2 = figure('Name', 'Distance  Sensor');
%movegui(f2,'west','onscreen');
subplot(2,2,[1 3])
d = animatedline;
dx = gca;
dx.YGrid = 'on';
dx.YLim = [0 200];
xlabel('Elapsed time (sec)');
ylabel('Distance in cm');
title('Aquiring Live Distance Data');

% Get the key currently pressed
key = get(gcf,'CurrentKey'); 

% Setting start time for live plot
startTime = datetime('now');
while  (strcmp(key, 's') == 0 )  % Press 'S' Key to STOP Live Acquisition
    
    % get the key currently pressed
    key = get(gcf,'CurrentKey'); 
    
    % Reading from Serial Monitor
    data = fscanf(SERIAL,'%s'); 

    % String to Double conversion
    C = strsplit(data,':');
    serialData = str2double(C);
   
    % get current elasped time for x axis
    t =  datetime('now') - startTime;
           
    % Add points to animation 
    addpoints(c,datenum(t),serialData(1))    % Cuurent
    addpoints(v,datenum(t),serialData(2))     % Voltage     
    addpoints(d,datenum(t),serialData(3))    % Distance 
     
    % Update axes
    cx.XLim = datenum([t-seconds(10) t]); 
    vx.XLim = datenum([t-seconds(10) t]);
    dx.XLim = datenum([t-seconds(10) t]); 
    datetick('x','keeplimits')
    datetick('x','keeplimits')
    datetick('x','keeplimits')
    drawnow
    
end

% Output message
if (strcmp(key, 's') == 0 )
    disp('Live Data acquisition ended because the TIME limit has been reached! ')
end
fclose(SERIAL);

%% Data Acquisition (Distance, Velocity, Voltage)

% creatime time axis, Distance array
[DistTimeLogs,DistanceLogs] = getpoints(d);
DistTimeSecs = (DistTimeLogs-DistTimeLogs(1))*24*3600;

% creatime time axis, Voltage array
[VoltTimeLogs,VoltageLogs] = getpoints(v);
VoltTimeSecs = (VoltTimeLogs-VoltTimeLogs(1))*24*3600;

% creatime time axis, Current array
[CurrTimeLogs,CurrentLogs] = getpoints(c);
CurrTimeSecs = (CurrTimeLogs-CurrTimeLogs(1))*24*3600;


% Solve for Velocity by getting the slope
% Creating a Dist vs Time Table
Tv = table(DistTimeSecs',DistanceLogs','VariableNames',{'Time_sec','Distance'});
% Setting Time as the first column 
timeV = Tv{:,1};
Position = hypot(Tv{:,1},Tv{:,2});
Velocity = gradient(Position)./gradient(Tv{:,1}); 
T2 = table(Position,Velocity, 'VariableNames',{'Position','Velocity'});

% Solve for output power by getting the slope
% Creating a Dist vs Time Table

Tp= table(VoltTimeSecs',VoltageLogs',CurrentLogs','VariableNames',{'Time_sec','Distance','Current'});
% Setting Time as the first column 
timeP = Tp{:,1};
V  = Tp{:,2};
I = Tp{:,3};
Output_Power = gradient(V) .* gradient(I); 
T2 = table(timeP,Output_Power, 'VariableNames',{'time','Output Power'});

%% Plotting Total Data

% Setting Second Figure
f2 = figure('Name', 'Total Distance & Velocity Plot');
f2.WindowState = 'maximized';
% Plotting Distance vs. Time
subplot(2,3,1)
plot(DistTimeSecs,DistanceLogs)
xlabel('Elapsed time (sec)')
ylabel('Distance in cm')
title('Total Recorded Distance Data');

% Plotting Velocity vs. Time
subplot(2,3,4)
plot(timeV,Velocity);
xlabel('Total Elasped Time');
ylabel('Velocity in cm/s');
title('Velocity of Winch') ;



%figure('Name', 'Total Voltage & Current Plot' )
% Plotting Voltage vs. Time
subplot(2,3,2)
plot(VoltTimeSecs,VoltageLogs)
xlabel('Elapsed time (sec)')
ylabel('Voltage in (V)')
title('Total Recorded Voltage Data');

% Plotting Current vs. Time
subplot(2,3,5)
plot(CurrTimeSecs,CurrentLogs)
xlabel('Elapsed time (sec)')
ylabel('Current in mA')
title('Total Recorded Current Data');

% Plotting Output Power vs. Time
%figure(5)
subplot(2,3,[3 6])
plot(timeP,Output_Power)  %Magnitude removes the Negative  on the graphs
xlabel('Elapsed time (sec)')
ylabel('Power in mW')
title('Total Recorded Power Data');


%% Save results to a file
% Creating Table 
Final_T = table(DistTimeSecs',DistanceLogs',Velocity,VoltageLogs','VariableNames',{'Time_sec','Distance','Velocity','Voltage'});

% Saving File Version through current time
date = datestr(now,'mm.dd.yy');
currentTime = datestr(now,'HH.MM.SS');
fileType = '.xlsx';

% Filename eg: '04.05 P15 W0.66 Test - 1.xlsx'
filename = strcat(date,' P', P,'%',' W',H,'m',' Test - ',T,fileType);


SvDataFolder = strcat(date,' P', P,'%',' W',H,'m',' Test - ',T);
% Folder Name Ex: '04.05 P15 W0.66 Test - 1'

% Establishing Current Folder Location
CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB'; %Input Desired/Current Folder Location
MsDataFolder = 'Data Acquistion';
MsFolderLoc = fullfile(CurrentFolder,MsDataFolder);  
SvFolderLoc = fullfile(MsFolderLoc,SvDataFolder);
% Individual Data Folders THat will have Excel Sheets and Figures
%DataFolder = strcat(outputName,date,CurrentTime);

% New Folder Destination
% C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Distance Sensor\MATLAB\Data Output


comments = fullfile(SvFolderLoc, 'Comments.txt');

% If the folder exist, Save file in it
if exist(MsFolderLoc, 'dir') 
   %{
    % Delete previous Folder, if exists, to avoid append of data
    if isfile(fullfile(SvFolderLoc,filename))
        delete(fullfile(SvFolderLoc,filename))
        %duplicate = strcat(SvDataFolder, 'COPY');
        fprintf('Duplicate filename "%s" found! File Deleted!\n\n',filename)
    end  
    %}
    % Creating Folder Directory
    mkdir(SvFolderLoc);
    
    % Write table to file and save it to folder location
    writetable(Final_T, fullfile(SvFolderLoc,filename))
    % Saving Figure to folder Location
     saveas(figure(2), fullfile(SvFolderLoc,'Total Data Aqcuisation Screen Shot'), 'png')
     % Saving Comments Txt file
     fopen(comments,'w');
   %  fclose(comments);
    % Print Data confirmation to command line
    fprintf('\n\nFolder Location: "C:..../%s" was found in directory. \n',SvDataFolder);
    fprintf('Resulting Table: \n %g Measurements of Distances, Velocity, Voltage, Current, and Output Power  \n',...
        length(DistTimeSecs));
    fprintf('Saved to file:\n "%s"\n',filename);
    % Print Folder Location confirmation to command line
    fprintf('File: "%s" was saved to folder: "%s" \n',filename,SvDataFolder)
        
else % If the folder doesn't exist, create it.
   
    % Creating Folder Directory
    mkdir(SvFolderLoc);
    
    % Write table to file and save it to folder location
    writetable(Final_T, fullfile(SvFolderLoc,filename))
    % Saving Figure to folder Location
    saveas(figure(2), fullfile(SvFolderLoc,'Total Data Aqcuisation Screen Shot'), 'png')
  
    % Print Folder Location confirmation to command line
    fprintf('\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
    fprintf('Folder: "C:.../%s" was NOT found in directory, so a new folder: "%s" was created! \n',...
            MsDataFolder,MsDataFolder);
    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n\n')
    
    % Print Data confirmation to command line
    fprintf('Folder Location: "C:.../%s" was found in directory. \n',SvDataFolder);
    fprintf('Resulting Table: \n %g Measurements of Distances, Velocity, Voltage, Current, and Output Power  \n',...
        length(DistTimeSecs));
    fprintf('Saved to file:\n "%s"\n',filename);
    % Print Folder Location confirmation to command line
    fprintf('File: "%s" was saved to folder: "%s" \n',filename,SvDataFolder)
         
end

%% Clearing serial monitor
fclose(SERIAL); %close serial port
delete(SERIAL); %remove serial port from memory

