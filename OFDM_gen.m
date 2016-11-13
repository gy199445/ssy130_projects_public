function [ z ] = OFDM_gen( symbol,N,N_cp )
%   OFDM_gen Summary of this function goes here
%   Detailed explanation goes here
%   Generate OFDM symbol from QPSK symbols and add cyclic prefix
%   N:number of sub-carriers
%   N_cp:length of the cyclic prefix
z = ifft(symbol,N);
z = [z(end-N_cp+1:end) z];
end

