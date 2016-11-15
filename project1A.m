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

%% Generate training sequence
b_train = 2*randi(2,1,N_bits)-3;
s_train = bits2sym(b_train);

%% Generate OFDM symbols
z = transmitter(b,N,N_cp);
z_train = transmitter(b_train,N,N_cp);

%% Transmit OFDM symbol
% Send through channel
y = conv(h,z);
y_train = conv(h,z_train);

% Add noise
y = awgn(y,20,'measured');
y_train = awgn(y_train, 20, 'measured');

%% OFDM decoding
% discard cyclic prefix
y = y(N_cp+1:end);
y_train = y_train(N_cp+1:end);

% transform back
r = fft(y,N);
r_train = fft(y_train,N);

%estimate channel
H = r_train./s_train;

% compute channel gain
%H = fft(h, N);

% multiply received message with channel gain
s = conj(H).*r;

%decode symbols
b2 = [sign(real(s)); sign(imag(s))];
b2 = b2(:)';