%Displacement = T.VariableNames{'Time_sec','Distance'}


Displacement = readtable('Output_Data_Distance_&_Voltage_03.11.22_19.15.05.xlsx','Sheet','Sheet1','Range','A:B');
T = Displacement;
time = T{:,1}; 
Position = hypot(T{:,1},T{:,2});
Velocity = gradient(Position)./gradient(T{:,1}); 
T2 = table(Position,Velocity, 'VariableNames',{'Position','Velocity'});
figure
plot(time,Velocity);
xlabel('Total Elasped Time');
ylabel('Velocity in m/s');
title('Velocity of Winch');