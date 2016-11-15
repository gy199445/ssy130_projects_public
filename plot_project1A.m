close all
%% compare the estimated channel with the true one
figure
plot(real(H),'.-')
hold on
plot(real(H_))
legend('real(H)','real(H\_)')
figure
plot(imag(H),'.-')
hold on
plot(imag(H_))
legend('imag(H)','imag(H\_)')
%% scatter plot
figure
scatter(real(symbol),imag(symbol))
hold on
scatter(real(symbol_),imag(symbol_),'d')
legend('transmitted','received')