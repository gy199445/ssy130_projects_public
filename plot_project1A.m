%% compare the estimated channel with the true one
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
%% scatter plot
figure
scatter(real(symbol),imag(symbol))
hold on
scatter(real(s_channel_unknown),imag(s_channel_unknown),'d')
