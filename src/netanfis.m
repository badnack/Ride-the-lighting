addpath('anfis/functions');

% generates the necessary files
setNewAnfisValues;

ITERATIONS = [1:50];

bestMseHoliday = inf;
bestMseWorkInl = inf;
bestMseWorkE  = inf;

bestErrHoliday = inf;
bestErrWorkInl = inf;
bestErrWorkE   = inf;

for i = ITERATIONS

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
        % save also the file found!
        unix(['mv ../data/anfis/holiday/*.csv ' ...
              '../data/anfis/holiday/best\ data\']);
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

        % save also the file found!
        % FIXME: find a best method
        unix(['mv ../data/anfis/workday/*Energy.csv ' ...
              '../data/anfis/workday/best\ data\']);
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

        % save also the file found!
        % FIXME: find a best method
        unix(['mv ../data/anfis/workday/*Inlight.csv ' ...
              '../data/anfis/workday/best\ data\']);
    end
    disp( sprintf( ['MSE #%d'], bestMseWorkInl ) );    
    setNewAnfisValues;
end

bestErrHoliday
bestErrWorkE
bestErrWorkInl
% PLOTS tests
testplot( bestNetworkHoliday, test, sprintf('Holiday inlight Mse: %f',bestMseHoliday));
testplot( bestNetworkWorkE, testEnergy, sprintf('Workday Energy Mse: %f',bestMseWorkE));
testplot( bestNetworkWorkInl, testInlight, sprintf('Workday Inlight Mse: %f',bestMseWorkInl));
