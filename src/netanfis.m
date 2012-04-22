addpath('anfis/functions');

% generates the necessary files
unix('cd ../data/anfis; ./holiday.rb');
unix('cd ../data/anfis; ./workday.rb');

% loads necessary data files
load '../data/anfis/holiday/train.csv';
load '../data/anfis/holiday/checking.csv';
load '../data/anfis/holiday/test.csv';

load '../data/anfis/workday/trainEnergy.csv';
load '../data/anfis/workday/checkingEnergy.csv';
load '../data/anfis/workday/testEnergy.csv';

load '../data/anfis/workday/trainInlight.csv';
load '../data/anfis/workday/checkingInlight.csv';
load '../data/anfis/workday/testInlight.csv';


ITERATIONS = [1:100];

bestMseHoliday = inf;
bestMseWorkInl = inf;
bestMseWorkE  = inf;


for i = ITERATIONS

    % holiday Inlight
    disp( sprintf( ['\nHOLIDAY INLIGHT: Attempt #%d'], i ) );
    [ network, nMF, mse ] =  searchBestAnfis( train, checking, test );
    if mse < bestMseHoliday
        bestMfHoliday = nMF;
        bestMseHoliday = mse;
        bestNetworkHoliday = network;
        bestNmfHoliday = nMF;
        % save also the file found!
        unix(['mv ../data/anfis/holiday/*.csv ' ...
              '../data/anfis/holiday/best\ data\']);
    end
    unix('cd ../data/anfis; ./holiday.rb');

    % workday Energy
    disp( sprintf( ['\nWORKDAY ENERGY: Attempt #%d'], i ) );
    [ network, nMF, mse ] =  searchBestAnfis( trainEnergy, checkingEnergy, testEnergy );
    if mse < bestMseWorkE
        bestMfWorkEn     = nMF;
        bestMseWorkE    = mse;
        bestNetworkWorkE = network;
        bestNmfWorkEn = nMF;

        % save also the file found!
        % FIXME: find a best method
        unix(['mv ../data/anfis/workday/*Energy.csv ' ...
              '../data/anfis/workday/best\ data\']);
    end

    % workday InLight
    disp( sprintf( ['\nWORKDAY INLIGHT: Attempt #%d'], i ) );
    [ network, nMF, mse ] =  searchBestAnfis( trainInlight, checkingInlight, testInlight );
    if mse < bestMseWorkInl
        bestMfWorkInl  = nMF;
        bestMseWorkInl = mse;
        bestNetworkWorkInl = network;
        bestNmfInlEn = nMF;

        % save also the file found!
        % FIXME: find a best method
        unix(['mv ../data/anfis/workday/*Inlight.csv ' ...
              '../data/anfis/workday/best\ data\']);
    end
    unix('cd ../data/anfis; ./workday.rb');

end

% PLOTS tests
testplot( bestNetworkHoliday, test, sprintf('Holiday inlight Mse: %f',bestMseHoliday));
testplot( bestNetworkWorkE, testEnergy, sprintf('Workday Energy Mse: %f',bestMseWorkE));
testplot( bestNetworkWorkInl, testInlight, sprintf('Workday Inlight Mse: %f',bestMseWorkInl));
