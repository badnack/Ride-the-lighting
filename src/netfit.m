% -*- mode: matlab -*-
% Neural network fitting

addpath('./functions');
load '../data/inputAll.csv';
load '../data/targetAll.csv';

[ net, train, outputs, errors ] = searchBestFitting( inputAll', targetAll' );

errorsTrain = errors(:, train.trainInd)
errorsVal   = errors(:, train.valInd)
errorsTest  = errors(:, train.testInd)

view ( net )
figure, plotperform( train )
figure, plotregression( targetAll', outputs )
figure, ploterrhist( errorsTrain, 'train', errorsVal, 'validation', errorsTest, 'test' )
