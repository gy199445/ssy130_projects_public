function [ y ] = channel( z,h,sigma,delay )
%CHANNEL Summary of this function goes here
%   Detailed explanation goes here
%   An multipath AWGN channel
y = conv(z,h);
y_len = length(y);
w = 1/sqrt(2)*sigma*(randn(1,y_len) + 1i*randn(1,y_len));%noise
y = y+w;

% add delay to channel, simulating synchronization delay
if delay < 0
    y = [zeros(1,-delay) y(1:end+delay)];
else
    y = circshift(y,[0, -delay]);
end
end