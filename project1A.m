%% Define constants and channels
h_1 = 0.8.^(0:59);
h_2 = [0.5 zeros(1,7) 0.5];
N = 128;
N_bits = 2*N;

sigma = 0.01;%noise level
% choice of channel
h = h_1;

% length of cyclic prefix, dependent on channel (20% safety margin)
N_cp = floor(1.2*length(h));

%PN code as pilot:
L_PN = 256;
PN_init_cond = [0 1 0 1 0 0 0 1];
PN_Polynomial = [8 2 0];
pn = pn_gen(L_PN,PN_init_cond,PN_Polynomial);
% Generate symbols for PN sequence
pn_symbol = bits2sym(pn);
delay = 10;
%number of iterations
N_it = 1;
%bit error counters for each iterations
bits_err_known_ch = zeros(1,N_it);
bits_err_unknow_ch = zeros(1,N_it);
for i=1:N_it
    %% Generate symbols
    bits = randsrc(1,N_bits,[0 1]);
    %the previous function is actually generating -1 and 1, they are not bits.
    symbol = bits2sym(bits);
    %% Generate OFDM symbol
    %make the process of generating OFDM symbol clear
    z = OFDM_gen(symbol,N,N_cp);
    pn_ofdm = OFDM_gen(pn_symbol,N,N_cp);
    pn_z = [pn_ofdm z]; %pack the training symbol to message
    %% Transmit OFDM symbol
    y = channel(z,h,sigma,delay);%known channel
    pn_y = channel(pn_z,h,sigma,delay);%unknown channel
    %% OFDM decoding (channel known)
    % discard cyclic prefix
    y = y(N_cp+1:N_cp+128);
    
    % transform back
    r = fft(y,N);
    
    % compute channel gain
    H = fft(h, N);
    
    % multiply received message with channel gain
    s = conj(H).*r;
    
    %decode symbols
    bits_ = sym2bits(s);
    bits_err_known_ch(i) = sum(abs(bits - bits_));%difference in bits
    %% OFDM decoding (channel unknown)
    [H_, symbol_] = OFDM_equalization(pn_y,pn_symbol,N,N_cp);
    bits_ch_unknown = sym2bits(symbol_);
    bits_err_unknow_ch(i) = sum(abs(bits - bits_ch_unknown));%difference in bits
end
N_total_bits = N_it*N_bits;
total_error_unknown_ch = sum(bits_err_unknow_ch);
total_error_known_ch = sum(bits_err_known_ch);
fprintf('%d bits transmitted, %d error in total, BER %.4f (channel known)',N_total_bits,total_error_known_ch,total_error_known_ch/N_total_bits);
fprintf('\n%d bits transmitted, %d error in total, BER %.4f (channel unknown)',N_total_bits,total_error_unknown_ch,total_error_unknown_ch/N_total_bits);