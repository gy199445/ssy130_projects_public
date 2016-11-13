%% Define constants and channels
h_1 = 0.8.^(0:59);
h_2 = [0.5 zeros(1,7) 0.5];

N = 128;
N_bits = 2*N;
N_cp = 100;

% choice of channel
h = h_1;
%PN code as pilot:
L_PN = 128;
PN_init_cond = [0 1 0 1 0 0 0 1];
PN_Polynomial = [8 2 0];
pn = pn_gen(256,PN_init_cond,PN_Polynomial);
%% Generate symbols
bits = randsrc(1,N_bits,[0 1]);
%the previous function is actually generating -1 and 1, they are not bits.
symbol = bits2sym(bits);
% Generate symbols for PN sequence
pn_symbol = bits2sym(pn);
%% Generate OFDM symbol
%make the process of generating OFDM symbol clear 
z = OFDM_gen(symbol,N,N_cp);
pn_ofdm = OFDM_gen(pn_symbol,N,N_cp);
%% Transmit OFDM symbol
y = channel(z,h,20);
pn_y = channel(pn_ofdm,h,20);
%% OFDM decoding
% discard cyclic prefix
y = y(N_cp+1:end);

% transform back
r = fft(y,N);

% compute channel gain
H = fft(h, N);

% multiply received message with channel gain
s = conj(H_hat).*r;

%estimate channel
H_hat = fft(pn_y(N_cp+1:end),N)./pn_symbol;
%compare real and estimated channel
figure
plot(real(H))
hold on
plot(real(H_hat))
legend('real(H)','real(H_hat)')
figure
plot(imag(H))
hold on
plot(imag(H_hat))
legend('imag(H)','imag(H_hat)')
%equalization (assume channel unknow)
s_channel_unknown = r./H_hat;
%decode symbols
bits_ = sym2bits(s_channel_unknown);
diff_bits = sum(bits - bits_);%difference in bits
disp(diff_bits)