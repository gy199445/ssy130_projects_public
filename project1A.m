%% Define constants and channels
%h_1 = 0.8.^(0:59);
%h_2 = [0.5 zeros(1,7) 0.5];
N_bits = 256;
N_cp = 8;
h_test = [0.8 0 0.15 0.05];%use this as demo
%% Generate symbols
b = randi(2,1,N_bits)-1;
%% Generate OFDM symbol
[z,s] = transmitter(b,N_cp);
%% Transmit OFDM symbol
y = conv(h_test,z);
%y = awgn(conv(z,h_test),20,'measured');
%% OFDM decoding
r = fft(y);
%remove cp
r = r(N_cp+1:N_cp+128);
%channel estimation (known this time)
H_test = fft(h_test,N_bits/2);
%equlization
r_ = r.*conj(H_test);
b_hat = symbol_decode(r_);
% plot(real(r_))
% hold on
% plot(real(s))