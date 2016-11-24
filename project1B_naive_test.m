%% Define constants and channels
N = 64;
N_bits = 2*N;

% length of cyclic prefix, dependent on channel (20% safety margin)
N_cp = 32;

%PN code as pilot:
L_PN = N_bits;
PN_init_cond = [0 1 0 1 0 0 0 1];
PN_Polynomial = [8 2 0];
pn = pn_gen(L_PN,PN_init_cond,PN_Polynomial);
% Generate symbols for PN sequence
pn_symbol = bits2sym(pn);

%% Generate symbols
bits = randsrc(1,N_bits,[0 1]);
%the previous function is actually generating -1 and 1, they are not bits.
symbol = bits2sym(bits);
bits = (bits == 1);
%% Generate OFDM symbol
%make the process of generating OFDM symbol clear
z_data = OFDM_gen(symbol,N,N_cp);
pn_ofdm = OFDM_gen(pn_symbol,N,N_cp);
z = [pn_ofdm z_data]; %pack the training symbol to message

%% Interpolate OFDM symbol
% Upsample
R = 8; %
N_z = length(z);
zu = zeros(1,N_z*R);
zu(1:R:end) = z;
% Design a LP interpolation filter
B = firpm(63,2*[0 0.5/R 0.5/R*1.6 1/2],[1 1 0 0]);
zi = conv(zu,B);
% zi is now the interpolated signal

%% Modulate OFDM symbol
fs = 16000;
fcm = 4000;
n = (0:length(zi)-1);
zm = zi.*exp(1i*2*pi*fcm/fs*n);

% Make signal real
zmr = real(zm);

%% Transmit OFDM symbol
sigma = 0; % noise level
ytrans = simulate_audio_channel(zmr, sigma);

% Detect start of transmission, get OFDM package
eps = 1E-4; %energy threshold
start_of_signal = find(abs(ytrans) > eps,1);
end_of_signal = length(ytrans) - find(abs(flipud(ytrans)) > eps, 1);

% get signal
yrec = ytrans(start_of_signal:end_of_signal)';
%yrec = zmr;

%% Demodulate OFDM symbol
n = (0:length(yrec)-1);
yib = yrec.*exp(-1i*2*pi*fcm/fs*n);

%% Decimate OFDM symbol
yi = conv(yib,B);
% yi is now a lowpass signal

D = 8; % Same as upsampling rate!!
y = yi(1:D:end);

%% OFDM decoding (channel unknown)
[H_, symbol_] = OFDM_equalization(y,pn_symbol,N,N_cp);
bits_ = sym2bits(symbol_);