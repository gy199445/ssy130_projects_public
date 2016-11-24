%% load data
%bits -> information bits (128)
%symbol -> information symbol (64)
%z_data -> ofdm info symbol
%pn_ofdm -> training pn ofdm symbol
%pn_symbol -> training pn symbol
%z = [pn_ofdm z_data]
%noise level
sigma = 0;
load('transmitting.mat')
N_cp = 32;
threshold = 0.5;
N_it = 1;
N_bits = 128;
%% Up-sampling
% z is the original baseband signal
N = length(z);
NN = 2^14; % Number of frequency grid points
f = (0:NN-1)/NN;
semilogy(f,abs(fft(z,NN))) % Check transform
xlabel('relative frequency f/fs');
%% Now upsample
R = 8; %
zu = zeros(N*R,1);
zu(1:R:end) = z;
semilogy(f,abs(fft(zu,NN))) % Check transform
xlabel('normalized frequency f/fs');
%% Design a LP interpolation filter
B = firpm(63,2*[0 0.5/R 0.5/R*1.6 1/2],[1 1 0 0]);
zi = conv(zu,B);
% zi is now the interpolated signal
figure(1)
plot([real(zi) imag(zi)])
figure(2)
semilogy(f,abs([fft(zu,NN) fft(zi,NN) fft(B.',NN)]) ) % Check transforms
legend('Up-sampled z_u','Interpolated after LP filtering','LP-filter')
xlabel('relative frequency f/fs');
%% Modulation
fs = 16000;
fcm = 4000;
F = (0:NN-1)/NN*fs;
n = (0:length(zi)-1)';
zm = zi.*exp(1i*2*pi*fcm/fs*n);
semilogy(F,abs([fft(zi,NN) fft(zm,NN) ]) ) % Check transforms
legend('Interpolated','Modulated')
xlabel('Frequency (Hz)');
%% Make signal real
zmr = real(zm);
semilogy(F,abs([fft(zi,NN) fft(zm,NN) fft(zmr,NN) ]) ) % Check transforms
legend('Interpolated','Modulated','Real and modulated')
xlabel('Frequency (Hz)');
%% Demodulation
fs = 16000;
fcm = 4000;
F = (0:NN-1)/NN*fs;
n = (0:length(zi)-1)';
yrec = simulate_audio_channel(zmr,sigma); % The received real valued signal
%truncate the received signal by energy detection
offset = energy_detection(yrec,threshold);
yrec = yrec(offset+1:end);
yib = yrec.*exp(-1i*2*pi*fcm/fs*(0:length(yrec)-1)');
semilogy(F,abs([fft(yrec,NN) fft(yib,NN)])) % Check transforms
legend('Modulated','Demodulated')
xlabel('Frequency (Hz)');
yi = conv(yib,B);
% yi is now a lowpass signal
figure(2)
semilogy(f,abs([fft(yib,NN) fft(yi,NN) fft(B.',NN)]) ) % Check transforms
legend('Demodulated','after LP filtering','LP-filter')
xlabel('relative frequency f/fs');
%% Down-sampling
D = 8; % Same as upsampling rate!!
y = yi(1:D:end);
semilogy(f,abs(fft(y,NN))) % Check transforms
%% Check in time domain
plot(real(y))
%% channel estimation and equalization
[H_, symbol_] = OFDM_equalization(y,pn_symbol,64,N_cp);
bits_ch_unknown = sym2bits(symbol_);
%print results
bits_err_unknown_ch = sum(abs(bits-bits_ch_unknown));
N_total_bits = N_it*N_bits;
total_error_unknown_ch = sum(bits_err_unknown_ch);
fprintf('%d bits transmitted, %d error in total, BER %.4f (channel unknown)',N_total_bits,total_error_unknown_ch,total_error_unknown_ch/N_total_bits);