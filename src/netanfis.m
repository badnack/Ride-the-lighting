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

% holiday Inlight
[ network, trainErrors, testErrors, checkErrors ] = searchBestAnfis( trainAnfis, checkingAnfis, testAnfis );
testErrors

% workday Energy
[ network, trainErrors, testErrors, checkErrors ] = searchBestAnfis( trainAnfisEnergy, checkingAnfisEnergy, testAnfisEnergy );
testErrors


%plot(x,y);%,x,evalfis(x,out_fis));
%legend('Training Data','ANFIS Output');
