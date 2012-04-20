addpath('anfis/functions');
load '../data/anfis/split/holiday/trainAnfis.csv';
load '../data/anfis/split/holiday/checkingAnfis.csv';
load '../data/anfis/split/holiday/testAnfis.csv';

load '../data/anfis/split/workday/trainAnfisEnergy.csv';
load '../data/anfis/split/workday/checkingAnfisEnergy.csv';
load '../data/anfis/split/workday/testAnfisEnergy.csv';
load '../data/anfis/split/workday/trainAnfisInlight.csv';
load '../data/anfis/split/workday/checkingAnfisInlight.csv';
load '../data/anfis/split/workday/testAnfisInlight.csv';


ITERATION = [1:5];

bestMseHoliday = inf;
bestMseWorkInl = inf;
bestMseWorkEn  = inf;

testErrorsHoliday = inf;
testErrorsWorkInl = inf;
testErrorsWorkEn  = inf;

%FIXME: save also the best files generated

for i = ITERATION
    % holiday Inlight
    [ networkHoliday, trainErrors, testErrors, checkErrors, nMF, mse ...
    ] =  searchBestAnfis( trainAnfis, checkingAnfis, testAnfis );
    if mse < bestMseHoliday
        bestMfHoliday = nMF;
        bestMseHoliday = mse;
        testErrorsHoliday = testErrors;
    end

    unix('cd ../data/anfis; ./holiday.rb');
    disp('Holidays data files re-generated');

    % workday Energy
    [ networkWorkE, trainErrors, testErrors, checkErrors, nMF, mse ...
    ] =  searchBestAnfis( trainAnfisEnergy, checkingAnfisEnergy, testAnfisEnergy );
    if mse < bestMseWorkEn
        bestMfWorkEn     = nMF;
        bestMseWorkEn    = mse;
        testErrorsWorkEn = testErrors;
    end

    % workday InLight
    [ networkWorkInl, trainErrors, testErrors, checkErrors, nMF, mse ...
    ] =  searchBestAnfis( trainAnfisInlight, checkingAnfisInlight, testAnfisInlight );
    if mse < bestMseWorkInl
        bestMfWorkInl     = nMF;
        bestMseWorkInl    = mse;
        testErrorsWorkInl = testErrors;
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
