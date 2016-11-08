%% Define constants and channels
h_1 = 0.8.^(0:59);
h_2 = [0.5 zeros(1,7) 0.5];
QPSK_constellation = [1+1j -1+1j 1-1j -1-1j]/(2^0.5);
N_bits = 256;
N_cp = 8;
h_test = [0.8 0 0.15 0.05];
%% Generate symbols
b = randi(2,1,N_bits)-1;
%% Generate OFDM symbol
z = transmitter(b,N_cp);
%% Transmit OFDM symbol
y = conv(h_test,z);
y = awgn(conv(z,h_test),20,'measured');
%% OFDM decoding
