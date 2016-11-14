function [ H, symbol ] = OFDM_equalization( y,pn_symbol,N,N_cp )
%OFDM_DECODE Summary of this function goes here
%   Detailed explanation goes here
%   return equalized symbol, assume perfect sync
%   y: the received training symbol and the data symbol
%   pn_symbol: training symbol
%   N: FFT length
%   N_cp: length of cp
%   H: estimated channel
%   symbol: equalized data symbol
y = y(N_cp+1:end);
% transform back
r = fft(y(1:128),N);
% compute channel gain
H = fft(h, N);
% multiply received message with channel gain
s = conj(H).*r;
%estimate channel
H_hat = fft(pn_y(N_cp+1:end),N)./pn_symbol;
%equalization (assume channel unknow)
s_channel_unknown = r./H_hat;
%decode symbols
bits_ = sym2bits(s_channel_unknown);
diff_bits = sum(bits - bits_);%difference in bits
disp(diff_bits)
end

