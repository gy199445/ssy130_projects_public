function [ y ] = channel( z,h,sigma,delay )
%CHANNEL Summary of this function goes here
%   Detailed explanation goes here
%   An multipath AWGN channel
y = conv(z,h);
y_len = length(y);
w = 1/sqrt(2)*sigma*(randn(1,y_len) + 1i*randn(1,y_len));%noise
y = y+w;
if delay>0
    y = y(delay+1:end);
else
    y = [zeros(1,delay) y];
end
end

