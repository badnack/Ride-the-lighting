% -*- mode: matlab -*-
% Neural network fitting

addpath('./functions');
load '../data/inputAll.csv';
load '../data/targetAll.csv';

[ net, train, outputs, errors ] = searchBestFitting( inputAll', targetAll' );

errorsTrain = errors(:, train.trainInd);
errorsVal   = errors(:, train.valInd);
errorsTest  = errors(:, train.testInd);

% value to save to plot regressions
targetTrasp  = targetAll';

targetTrain = targetTrasp(:,train.trainInd);
targetVal = targetTrasp(:,train.valInd);
targetTest = targetTrasp(:,train.testInd);

outTest  = outputs(:,train.testInd);
outVal   = outputs(:,train.valInd);
outTrain = outputs(:,train.trainInd);

view ( net )
figure, plotperform( train )
figure, plotregression( targetTrain, outTrain,'training',targetVal,outVal, ...
                        'Valuation', targetTest, outTest, 'Test', ...
                        targetAll', outputs, 'All')

figure, ploterrhist( errorsTrain, 'train', errorsVal, 'validation', errorsTest, 'test' )
