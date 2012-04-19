addpath('anfis/functions');
load '../data/anfis/trainAnfis.csv';
load '../data/anfis/checkingAnfis.csv';
load '../data/anfis/testAnfis.csv';

[ network, trainErrors, testErrors, checkErrors ] = searchBestAnfis( trainAnfis, checkingAnfis, testAnfis );
testErrors

%plot(x,y);%,x,evalfis(x,out_fis));
%legend('Training Data','ANFIS Output');
