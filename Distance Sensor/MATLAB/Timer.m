LiveVoltage();
maxDuration = 10; % 60 second 
timerS = timer('TimerFcn', 'stat=false; disp(''Time Limit for Data Acquisition has be reached!'')',... 
                 'StartDelay', maxDuration ); %30 second timer
start(timerS)
k = 0;
stat=true;
    while(stat==true)
      %disp('.')
      k = k + 1;
      disp(k)
      pause(1) %1 sec
    end

    if(k == maxDuration)
        timelimit = k;
        k = 0;
        delete(timerS) % Always delete timer objects after using them.
    end   
    delete(timerS) % Always delete timer objects after using them.

 