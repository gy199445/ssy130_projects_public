function [ H_hat, symbol ] = OFDM_equalization( y,pn_symbol,N,N_cp )
%OFDM_DECODE Summary of this function goes here
%   Detailed explanation goes here
%   return equalized symbol (zero forcing), requires synchronization first
%   return the estimated channel frequency response
%   y: the received training symbol and the data symbol
%   pn_symbol: training symbol
%   N: FFT length
%   N_cp: length of cp
%   H: estimated channel
%   symbol: equalized data symbol
%Training symbol
y_train = y(N_cp+1:N_cp+128);
%Data symbol  
y_data = y((N_cp+128)+N_cp+1:(N_cp+128)+N_cp+128);
%estimate channel
H_hat = fft(y_train,N)./(pn_symbol+eps);% avoid dividing zero
%equalization (zero forcing)
symbol = fft(y_data)./H_hat;
end

