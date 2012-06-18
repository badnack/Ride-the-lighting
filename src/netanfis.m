clear
addpath('anfis/functions');

% generates the necessary files
load '../data/anfis/holiday/train.csv';
load '../data/anfis/holiday/checking.csv';
load '../data/anfis/holiday/test.csv';
load '../data/anfis/workday/trainEnergy.csv';
load '../data/anfis/workday/checkingEnergy.csv';
load '../data/anfis/workday/testEnergy.csv';
load '../data/anfis/workday/trainInlight.csv';
load '../data/anfis/workday/checkingInlight.csv';
load '../data/anfis/workday/testInlight.csv';


ITERATIONS = [1:50];

bestMseHoliday = inf;
bestMseWorkInl = inf;
bestMseWorkE  = inf;

bestErrHoliday = inf;
bestErrWorkInl = inf;
bestErrWorkE   = inf;

% holiday Inlight
disp( sprintf( ['\nHOLIDAY INLIGHT: Attempt #%d'], i ) );
[ network, nMF, mse, err ] =  searchBestAnfis( train, checking, test );
if mse < bestMseHoliday
    disp( sprintf( ['Best values found - MSE #%d'], mse ) );
    bestMfHoliday = nMF;
    bestMseHoliday = mse;
    bestErrHoliday = err;
    bestNetworkHoliday = network;
    bestNmfHoliday = nMF;
end

disp( sprintf( ['MSE #%d'], bestMseHoliday ) );

% workday Energy
disp( sprintf( ['\nWORKDAY ENERGY: Attempt #%d'], i ) );
[ network, nMF, mse,err ] =  searchBestAnfis( trainEnergy, checkingEnergy, testEnergy );
if mse < bestMseWorkE
    disp( sprintf( ['Best values found - MSE #%d'], mse ) );
    bestMfWorkEn     = nMF;
    bestMseWorkE     = mse;
    bestErrWorkE     = err;
    bestNetworkWorkE = network;
    bestNmfWorkEn = nMF;
end
disp( sprintf( ['MSE #%d'], bestMseWorkE ) );

% workday InLight
disp( sprintf( ['\nWORKDAY INLIGHT: Attempt #%d'], i ) );
[ network, nMF, mse,err ] =  searchBestAnfis( trainInlight, checkingInlight, testInlight );
if mse < bestMseWorkInl
    disp( sprintf( ['Best values found - MSE #%d'], mse ) );
    bestMfWorkInl  = nMF;
    bestMseWorkInl = mse;
    bestErrWorkInl = err;
    bestNetworkWorkInl = network;
    bestNmfInlEn = nMF;

end
disp( sprintf( ['MSE #%d'], bestMseWorkInl ) );

bestErrHoliday
bestErrWorkE
bestErrWorkInl
% PLOTS tests
testplot( bestNetworkHoliday, test, sprintf('Holiday inlight Mse: %f',bestMseHoliday));
testplot( bestNetworkWorkE, testEnergy, sprintf('Workday Energy Mse: %f',bestMseWorkE));
testplot( bestNetworkWorkInl, testInlight, sprintf('Workday Inlight Mse: %f',bestMseWorkInl));
