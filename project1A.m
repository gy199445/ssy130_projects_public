%% Define constants and channels
h_1 = 0.8.^(0:59);
h_2 = [0.5 zeros(1,7) 0.5];

N = 128;
N_bits = 2*N;
N_cp = 100;

% choice of channel
h = h_1;
%% Generate symbols
b = 2*randi(2,1,N_bits)-3;
%% Generate OFDM symbol
z = transmitter(b,N,N_cp);
%% Transmit OFDM symbol
% Send through channel
y = conv(h,z);
% Add noise
y = awgn(y,20,'measured');
%% OFDM decoding
% discard cyclic prefix
y = y(N_cp+1:end);

% transform back
r = fft(y(1:N));

% compute channel gain
H = fft(h, N);

% multiply received message with channel gain
s = conj(H).*r(1:N);

%estimate channel



%decode symbols
b2 = [sign(real(s)); sign(imag(s))];
b2 = b2(:)';
