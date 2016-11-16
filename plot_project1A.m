close all
%% compare the estimated channel with the true one
figure
subplot(2,1,1);
plot(real(H),'.-')
hold on
plot(real(H_))
xlim([1 128]);
legend({'$H(k)$','$\hat{H}(k)$'},'Interpreter','latex');
ylabel('Re');
title('Estimation of channel $h_2$, $\sigma = 0.05$', 'Interpreter', 'latex');
subplot(2,1,2);
plot(imag(H),'.-')
hold on
plot(imag(H_))
xlim([1 128]);
ylabel('Im');
xlabel('k');
%% scatter plot
figure
scatter(real(s),imag(s),'d')
hold on
scatter(real(symbol),imag(symbol))
legend({'$\hat{s}(k)$','$s(k)$'}, 'Interpreter', 'latex');
xlabel('Re');
ylabel('Im');
grid on;