
%Distance Ratio Calculations 

ratioDT1 = [.9954 1.0204 1.0152 1.0197 1.0330 1.0265 1.02451 1.0256 1.01494 1.0185 1.0321 1.0137 1.0152 1.01818 1.0240 1.0205 1.0236 1.0206 1.0249 1.0307 1.0210 1.0237 1.0252 ]; 
numTest1 = numel(ratioDT1) + 1 ;%checks number of values in RatioDT1 
avgRatioTest1 = mean(ratioDT1); % finds the ave ratio


ratioDT2 = [ .9708 .9673 1.005 1.0132 1.0095 1.0113 1.0263 1.0226 1.0241 1.0245 1.0225 1.0260 1.0192 1.0226 1.0205 1.0233 1.0199 1.0253 1.0209 1.0238 1.0202 1.0206 1.0209 ]; 
numTest2 = numel(ratioDT2)+1 ;
avgRatioTest2 = mean(ratioDT2) ;  % finds the ave ratio

ratioDT3 = [.9478 .9696 .9950 1.0322 1.0230 1.0296 1.0282 1.0262 1.0309 1.0301 1.0268 1.0282 1.0303 1.0211 1.0240 1.0240 1.0197 1.02564 1.0216 1.0196 1.0221 1.0250 1.0221]; 
numTest3 = numel(ratioDT3)+1 ;
avgRatioTest3 = mean(ratioDT3);  % finds the ave ratio
A = transpose(ratioDT1);
B = transpose(ratioDT2);
C = transpose(ratioDT3);
tCount = transpose([1:1:23]);
%header = {'test #' 'Ratio 1' 'Ratio 2' 'Ratio 3'};
%table( A, B, C,header)
compare = [ tCount A B C];



