function [ y ] = channel( z,h,SNR )
%CHANNEL Summary of this function goes here
%   Detailed explanation goes here
%   An multipath AWGN channel
y = conv(z,h);
awgn(y,SNR,'measured');
end

