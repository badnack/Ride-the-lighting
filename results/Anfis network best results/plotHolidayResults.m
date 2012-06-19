clear;
load 'optAnfis.mat'

% holiday net
x = [1:length(test(:,1))];
figure
plot(x,test(:,3),'o',x,evalfis( test(:,1:2), bestNetworkHoliday ),'x');
xlabel('steps');
ylabel('outputs');
title(sprintf(['Holiday inlight Mse: %f'],bestMseHoliday));
legend('targets','outputs');

% workday energy
x = [1:length(testEnergy(:,1))];
figure
plot(x,testEnergy(:,3),'o',x,evalfis( testEnergy(:,1:2), bestNetworkWorkE ),'x');
xlabel('steps');
ylabel('outputs');
title(sprintf('Workday Energy Mse: %f',bestMseWorkE));
legend('targets','outputs');

%workday inlight
x = [1:length(testInlight(:,1))];
figure
plot(x,testInlight(:,3),'o',x,evalfis( testInlight(:,1:2), bestNetworkWorkInl ),'x');
xlabel('steps');
ylabel('outputs');
title( sprintf('Workday Inlight Mse: %f',bestMseWorkInl));
legend('targets','outputs');

