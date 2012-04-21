addpath('anfis/functions');

% generates the necessary files
unix('cd ../data/anfis; ./holiday.rb');
unix('cd ../data/anfis; ./workday.rb');

% loads necessary data files
load '../data/anfis/split/holiday/train.csv';
load '../data/anfis/split/holiday/checking.csv';
load '../data/anfis/split/holiday/test.csv';

load '../data/anfis/split/workday/trainEnergy.csv';
load '../data/anfis/split/workday/checkingEnergy.csv';
load '../data/anfis/split/workday/testEnergy.csv';

load '../data/anfis/split/workday/trainInlight.csv';
load '../data/anfis/split/workday/checkingInlight.csv';
load '../data/anfis/split/workday/testInlight.csv';


ITERATION = [1:5];

bestMseHoliday = inf;
bestMseWorkInl = inf;
bestMseWorkEn  = inf;


for i = ITERATION

    % holiday Inlight
    disp( sprintf( ['\nHOLIDAY INLIGHT: Attempt #%d'], i ) );
    [ network, nMF, mse ] =  searchBestAnfis( train, checking, test );
    if mse < bestMseHoliday
        bestMfHoliday = nMF;
        bestMseHoliday = mse;
        bestNetworkHoliday = network;

        % save also the file found!
        unix(['mv ../data/anfis/split/holiday/*.csv ' ...
              '../data/anfis/split/holiday/best\ data\']);
    end
    unix('cd ../data/anfis; ./holiday.rb');

    % workday Energy
    disp( sprintf( ['\nWORKDAY ENERGY: Attempt #%d'], i ) );
    [ network, nMF, mse ] =  searchBestAnfis( trainEnergy, checkingEnergy, testEnergy );
    if mse < bestMseWorkEn
        bestMfWorkEn     = nMF;
        bestMseWorkEn    = mse;
        bestNetworkWorkE = network;

        % save also the file found!
        % FIXME: find a best method
        unix(['mv ../data/anfis/split/workday/*Energy.csv ' ...
              '../data/anfis/split/workday/best\ data\']);
    end

    % workday InLight
    disp( sprintf( ['\nWORKDAY INLIGHT: Attempt #%d'], i ) );
    [ network, nMF, mse ] =  searchBestAnfis( trainInlight, checkingInlight, testInlight );
    if mse < bestMseWorkInl
        bestMfWorkInl  = nMF;
        bestMseWorkInl = mse;
        bestNetworkWorkInl = network;

        % save also the file found!
        % FIXME: find a best method
        unix(['mv ../data/anfis/split/workday/*Inlight.csv ' ...
              '../data/anfis/split/workday/best\ data\']);
    end
    unix('cd ../data/anfis; ./workday.rb');

end

% PLOTS tests

% holiday
x = [1:length(test(:,1))];
str = sprintf('Holiday inlight Mse: %f',bestMseHoliday);
figure
plot(x,test(:,3),'o',x,evalfis( test(:,1:2), bestNetworkHoliday ),'x');
xlabel('steps');
ylabel('outputs');
title(str);
legend('targets','outputs');
bestMfHoliday


%workday energy
x = [1:length(testEnergy(:,1))];
str = sprintf('Workday Energy Mse: %f',bestMseWorkEn);
figure
plot(x,testEnergy(:,3),'o',x,evalfis( testEnergy(:,1:2), bestNetworkWorkE ),'x');
xlabel('steps');
ylabel('outputs');
title(str);
legend('targets','outputs');
bestMfWorkEn


%workday Inlight
x = [1:length(testInlight(:,1))];
str = sprintf('Workday Inlight Mse: %f',bestMseWorkInl);
figure
plot(x,testInlight(:,3),'o',x,evalfis( testInlight(:,1:2), bestNetworkWorkInl ),'x');
xlabel('steps');
ylabel('outputs');
title(str);
legend('targets','outputs');
bestMfWorkInl
