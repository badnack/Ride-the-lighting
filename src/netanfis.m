addpath('anfis/functions');
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

testErrorsHoliday = inf;
testErrorsWorkInl = inf;
testErrorsWorkEn  = inf;

for i = ITERATION

    % holiday Inlight
     disp( sprintf( ['Searching anfis network to estimate holiday inlight. Attempt #%d'], i ) );
    [ networkHoliday, trainErrors, testErrors, checkErrors, nMF, mse ...
    ] =  searchBestAnfis( trainAnfis, checkingAnfis, testAnfis );
    if mse < bestMseHoliday
        bestMfHoliday = nMF;
        bestMseHoliday = mse;
        testErrorsHoliday = testErrors;

        % save also the file found!
        unix(['cd ../data/anfis/split/holiday; mv train.csv ' ...
              'bestTrain.csv']);
        unix(['cd ../data/anfis/split/holiday; mv test.csv ' ...
              'bestTest.csv']);
        unix(['cd ../data/anfis/split/holiday; mv checking.csv ' ...
              'bestChecking.csv']);

    end

    unix('cd ../data/anfis; ./holiday.rb');
    disp('Holidays data files re-generated');

    % workday Energy
    disp( sprintf( ['Searching anfis network to estimate workday energy. Attempt #%d'], i ) );
    [ networkWorkE, trainErrors, testErrors, checkErrors, nMF, mse ...
    ] =  searchBestAnfis( trainAnfisEnergy, checkingAnfisEnergy, testAnfisEnergy );
    if mse < bestMseWorkEn
        bestMfWorkEn     = nMF;
        bestMseWorkEn    = mse;
        testErrorsWorkEn = testErrors;
        % save also the file founad!
        unix(['cd ../data/anfis/split/workday; mv trainEnergy.csv ' ...
              'bestTrainEnergy.csv']);
        unix(['cd ../data/anfis/split/workday; mv testEnergy.csv ' ...
              'bestTestEnergy.csv']);
        unix(['cd ../data/anfis/split/workday; mv checkingEnergy.csv ' ...
              'bestCheckingEnergy.csv']);
    end

    % workday InLight
    disp( sprintf( ['Searching anfis network to estimate workday inlight. Attempt #%d'], i ) );
    [ networkWorkInl, trainErrors, testErrors, checkErrors, nMF, mse ...
    ] =  searchBestAnfis( trainAnfisInlight, checkingAnfisInlight, testAnfisInlight );
    if mse < bestMseWorkInl
        bestMfWorkInl     = nMF;
        bestMseWorkInl    = mse;
        testErrorsWorkInl = testErrors;
        % save also the file founad!
        unix(['cd ../data/anfis/split/workday; mv trainInlight.csv ' ...
              'bestTrainInlight.csv']);
        unix(['cd ../data/anfis/split/workday; mv testInlight.csv ' ...
              'bestTestInlight.csv']);
        unix(['cd ../data/anfis/split/workday; mv checkingInlight.csv ' ...
              'bestCheckingInlight.csv']);
    end

    unix('cd ../data/anfis; ./workday.rb');
    disp('Workdays data files re-generated');

end

% print values
bestMfWorkInl
bestMseWorkInl
testErrorsWorkInl

bestMfWorkEn
bestMseWorkEn
testErrorsWorkEn

bestMfHoliday
bestMseHoliday
testErrorsHoliday


%plot(x,y);%,x,evalfis(x,out_fis));
%legend('Training Data','ANFIS Output');
