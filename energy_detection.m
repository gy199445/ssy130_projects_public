function [ start ] = energy_detection( yrec,threshold )
%ENERGY_DETECTION Summary of this function goes here
%   Detailed explanation goes here
%   determine the starting index of the received signal
%   yrec -> the received signal
%   threshold -> the normalized energy threshold of start
%   start -> starting index of the received signal
l_yrec = length(yrec);
avg_yrec_engergy = sum(abs(yrec).^2)/l_yrec;
yrec = yrec/avg_yrec_engergy;%normalize the energy
start = 1;
while (yrec(start)<=threshold)
    start = start + 1;
end
start = start - 50;
%the equalization tolerates negative delay only
end

