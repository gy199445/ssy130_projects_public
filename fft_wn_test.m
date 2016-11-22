N = 1000;

sigma = 0.1;
N_it = 1000;

FFT_mag_w_avg = zeros(1,N);

for i = 1:N_it
    w = 1/sqrt(2)*sigma*(randn(1,N) + 1i*randn(1,N));
    FFT_mag_w = abs(fft(w));
    FFT_mag_w_avg = FFT_mag_w_avg + FFT_mag_w;
end
FFT_mag_w_avg = FFT_mag_w_avg./N_it;
plot(FFT_mag_w_avg);