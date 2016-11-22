close all
%% compare the estimated channel with the true one
figure
subplot(2,1,1);
plot(abs(H),'.-')
hold on
plot(abs(H_))
xlim([1 128]);
legend({'$H(k)$','$\hat{H}(k)$'},'Interpreter','latex');
ylabel('|H|');
title('Estimation of channel $h_1$, $\sigma = 0.05$', 'Interpreter', 'latex');
subplot(2,1,2);
plot(angle(H),'.-')
hold on
plot(angle(H_))
xlim([1 128]);
ylabel('\angle H [rad]');
xlabel('k');
%% scatter plot
figure
scatter(real(symbol),imag(symbol),'d')
hold on
scatter(real(s),imag(s))
legend({'$\hat{s}(k)$','$s(k)$'}, 'Interpreter', 'latex');
xlabel('Re');
ylabel('Im');
grid on;