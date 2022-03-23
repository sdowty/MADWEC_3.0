%% In Class 15 Problem 3
% By: Antz-Lee Francois
clear all; clc;

%% Data Calculations

% Flag for saving plots.  Make true when final version
FINAL = 0;
%FINAL = 1;

% Define passband and stopband edges
omegap = 2*pi*200; % Pass Band -  Rad/sec
omegas = 2*pi*150; % Stop Band -  Rad/sec 

% Define passband and stopband ripples
% 0.98 <= |H(jw)| <= 1.02   ==> Pass Band 
%         |H(jw)| <= .02    ==> Stop Band 
delta1 = 0.02;
delta2 = 0.02;

% Find passband and stopband edges in dB
Rp = -20*log10(1-delta1);
Rs = -20*log10(delta2);

% Find filter order and frequency parameter
[Nbw,omeganbw] = buttord(omegap,omegas,Rp,Rs,'s');

% Find parameters for the filter frequency response
[bbw,abw] = butter(Nbw,omeganbw,'s');

% Find frequency response
omega = 2*pi*linspace(0,2000,4096);
Hbw = freqs(bbw,abw,omega);

%% Plotting 
figure(1)
%subplot(211)
plot(omega/(2*pi),abs(Hbw))
xlabel('Frequency (Hz)')
ylabel('|H(j\omega)|')
title('Frequency Response for Butterworth Filter')
axis([0 400 0 1+delta1])

if FINAL
print -deps class15exampleHjw.eps
end

figure(2)
subplot(211)
plot(omega/(2*pi),abs(Hbw))
axis([0 omegap/(2*pi) 1-delta1 1+delta1]);
xlabel('Frequency (Hz)')
ylabel('|H(j\omega)|')
title('Detail of passband for Butterworth Filter')

subplot(212)
plot(omega/(2*pi),abs(Hbw))
axis([omegas/(2*pi) max(omega)/(2*pi) 0 delta2]);
xlabel('Frequency (Hz)')
ylabel('|H(j\omega)|')
title('Detail of stopband for Butterworth Filter')

if FINAL
print -deps class15exampleHjwpbsb.eps
end

