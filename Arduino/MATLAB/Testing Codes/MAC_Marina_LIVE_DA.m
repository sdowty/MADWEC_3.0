%% MADWEC 3.0 - Live Data Acquisition
% Script uses an Arduino (Uno) microcontroller to test an array of sensors with such as:
% (1) Current Sensor (10A MAX),(2) Voltage Sensor (11x attenuation),(3) HC- SR04 Distance Sensor 
% The script plots live data from the sensors until a stop button (s) is pressed using 
% the key board. After the live acquisition, post procress functions measures Velocity
% and Output Power. The script creates a main folder that saves test runs in sub folders 
% that contains the following:
% (1) saved data on a excel spreadsheet, (2) saved figures, (3) Comment Text File 


%% Close all open figures
clear all 
clear;clc;
close ALL 
delete(instrfindall);

%% Initialize Test Parameters
    fprintf('-------Initialize Testing Parameters-------\n');
    fprintf('***After wave height..WAIT TILL WINCH MOVES! then Press Enter*** \n');
    
    testPrompt = 'Test number (#): ';
    powPrompt = 'Winch Power (%): ';   
    wavPrompt = 'Wave Height (m): ';

    TestInput = input(testPrompt);
    PowInput = input(powPrompt);
    WavInput = input(wavPrompt);
    

    T = num2str(TestInput);
    P = num2str(PowInput);
    H = num2str(WavInput);

    % Folder Name Output: '04.05_P15_W0.66_Test - 1'

%% Team COM PORTS
    % Mac/Os COM Port - Marina
    % Distance Sensor - '/dev/cu.usbmodem1301'
    % Current Sensor - '/dev/cu.usbmodem1101'

    % PC/Windows COM PORT - Antz-Lee 
    % Distance Sensor - 'COM9'
    % Current Sensor - 'COM8' 

    % PC/Windows COM PORT - Spencer
    % Distance Sensor - 'COM4'
    % Current Sensor - 'COM3' 
    
%% Initializing Arduino 
% COM ports change from computer to computer
% Check by going to the Command Window and entering: 
% arduino() 
% press enter
% change the COM PORT

    % Distance Sensor 
        arduinoObj = arduino('/dev/cu.usbmodem1301','Uno','Libraries','Ultrasonic');
        ultrasonicObj = ultrasonic(arduinoObj,'D9','D10'); % trig D9 %echo D10
    % Current Sensor 
        currentSM = serial('/dev/cu.usbmodem1101','BaudRate',9600);
        fopen(currentSM); 
%% Acquiring and Displaying Live Data: (Distance, Voltage)

    % Setting up the figures
        f1 = figure('Name','Voltage and Current');
        f1.WindowState = 'maximized';

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
    
    % Acquisition time (min). Insert inf to disable time limit.
        waitTime = 2;
        waitTime = duration(0,waitTime,0);
        
    % Starting time for Clock   
        t = datetime('now') - startTime;
        
% Live Acquisition Readings
    while ((strcmp(key, 's') == 0 ) && t < waitTime ) % Press 'S' Key to STOP Live Acquisition
     % get the key currently pressed
        key = get(gcf,'CurrentKey'); 

     % Getting Values
        distance = readDistance(ultrasonicObj) * 100; % Distance 
        voltage = readVoltage(arduinoObj,'A0') * 11; % Voltage 
        curSM = fscanf(currentSM,'%s');

     % Convert String from SERIAL MONITOR to Double
        current = str2double(curSM);
        
     % Get current elasped time for x axis
        t = datetime('now') - startTime;
        
     % Add points to animation
        addpoints(d,datenum(t),distance) % Distance 
        addpoints(v,datenum(t),voltage)  % Voltage 
        addpoints(c,datenum(t),current)  % Current
     % Update axes
        dx.XLim = datenum([t-seconds(20) t]);   
        vx.XLim = datenum([t-seconds(20) t]);
        cx.XLim = datenum([t-seconds(20) t]);
        datetick('x','keeplimits')
        datetick('x','keeplimits')
        datetick('x','keeplimits')
        drawnow
    end


% Output message
    if (strcmp(key, 's') == 0 )
        disp('\n ***Live Data acquisition ended because the TIME limit has been reached!***')
    else
        disp('\n ***Live Data acquisition ended because the STOP button has been pressed!***')

    end
%% Data Acquisition Logs (Distance, Velocity, Voltage, Current, Power)

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
        V = Tp{:,2};
        I = Tp{:,3};
        Output_Power = (V) .* (I); 
        T2 = table(timeP,Output_Power, 'VariableNames',{'time','Output Power'});

%% Plotting Total Data Aqcuistion 
    % Minimize figure 1 
        f1.WindowState = 'minimized'; 
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
        subplot(2,3,[3 6])
        plot(timeP,Output_Power) %Magnitude removes the Negative on the graphs
        xlabel('Elapsed time (sec)')
        ylabel('Power in mW')
        title('Total Recorded Power Data');
        
%% Team Folder Locations 
    % Antz-Lee 
        % 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Arduino\MATLAB'
    % Marina
        % '/Users/marinameehan/Downloads/MATLAB 2022'
    % Spencer 
        %

%% Save results to a file
    % Creating Table 
        Final_T = table(DistTimeSecs',DistanceLogs',Velocity,VoltageLogs',CurrentLogs',Output_Power,'VariableNames',{'Time_sec','Distance','Velocity','Voltage','Current','Output Power'});

    % Saving File Version through current time
        date = datestr(now,'mm.dd.yy');
        currentTime = datestr(now,'HH.MM.SS');
        fileType = '.xlsx';

    % Filename eg: '04.05 P15 W0.66 Test - 1.xlsx'
        filename = strcat(date,' P', P,'%',' W',H,'m',' Test - ',T,fileType);
        SvDataFolder = strcat(date,' P', P,'%',' W',H,'m',' Test - ',T);
    % Folder Name Ex: '04.05 P15 W0.66 Test - 1'

    % Establishing Current Folder Location
        CurrentFolder = '/Users/marinameehan/Downloads/MATLAB 2022' ;% Input Desired/Current Folder Location
        MsDataFolder = 'Data Acquistion';
        MsFolderLoc = fullfile(CurrentFolder,MsDataFolder); 
        SvFolderLoc = fullfile(MsFolderLoc,SvDataFolder);

    
% If the folder exist, Save file in it
    if exist(MsFolderLoc, 'dir') 
        % Creating Folder Directory
            mkdir(SvFolderLoc);
        % Write table to file and save it to folder location
            writetable(Final_T, fullfile(SvFolderLoc,filename))
        % Saving Figure to folder Location
            saveas(figure(2), fullfile(SvFolderLoc,'Total Data Aqcuisation Screen Shot'), 'png')
            
        % Creating Comments Folder Location
            comments = fullfile(SvFolderLoc, 'Comments.txt');
        % Saving Comments 
            fopen(comments,'w');
            
        % Print Data confirmation to command line
            fprintf('\nFolder Location: "C:..../%s" was found in directory. \n',SvDataFolder);
            fprintf('Resulting Table: \n %g Measurements of Distances, Velocity, Voltage, Current, and Output Power \n',...
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
            
        % Creating Comments Folder Location
            comments = fullfile(SvFolderLoc, 'Comments.txt');
        % Saving Comments 
            fopen(comments,'w');
            
        % Print Folder Location confirmation to command line
            fprintf('\n !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n')
            fprintf('Folder: "C:.../%s" was NOT found in directory, so a new folder: "%s" was created! \n',...
            MsDataFolder,MsDataFolder);
            fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n\n')
        % Print Data confirmation to command line
            fprintf('Folder Location: "C:.../%s" was found in directory. \n',SvDataFolder);
            fprintf('Resulting Table: \n %g Measurements of Distances, Velocity, Voltage, Current, and Output Power \n',...
            length(DistTimeSecs));
            fprintf('Saved to file:\n "%s"\n',filename);
        % Print Folder Location confirmation to command line
            fprintf('File: "%s" was saved to folder: "%s" \n',filename,SvDataFolder)
    end

%% Clearing serial monitor
    fclose(currentSM); %close serial port
    delete(currentSM); %remove serial port from memory

