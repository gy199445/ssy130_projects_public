function [ z ] = transmitter( bits,N,N_cp )
%TRANSMITTER Summary of this function goes here
%   Detailed explanation goes here
symbol = bits2sym(bits); %corresponds to s[n]
z = ifft(symbol,N);
% add cp, length = L_cp
z = [z(end-N_cp+1:end) z];
end

