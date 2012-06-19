% -*- mode: matlab -*-
% Time Series model

clear;
addpath('./time series/functions');
unix('cd ../data/time\ series; ./energy.rb');
unix('cd ../data/time\ series; ./inlight.rb');

load '../data/time series/inputEnergy.csv';
load '../data/time series/targetEnergy.csv';

load '../data/time series/inputInlight.csv';
load '../data/time series/targetInlight.csv';


[ netE, trainE, outputsE, errorsE, inputsE, targetsE ] = searchBestTimeSeries( inputEnergy, targetEnergy );

errorsTrainE = errorsE( :, trainE.trainInd );
errorsValE   = errorsE( :, trainE.valInd );
errorsTestE  = errorsE( :, trainE.testInd );

% value to save to plot regressions
targetTrainE = targetsE( :, trainE.trainInd );
targetValE   = targetsE( :, trainE.valInd );
targetTestE  = targetsE( :, trainE.testInd );

outTestE  = outputsE( :, trainE.testInd );
outValE   = outputsE( :, trainE.valInd );
outTrainE = outputsE( :, trainE.trainInd );

% View the Network
view(netE)

% Plots
% Uncomment these lines to enable various plots.
figure, plotregression( targetTrainE, outTrainE,'Training',targetValE,outValE, ...
                        'Validation', targetTestE, outTestE, 'Test', ...
                        targetsE, outputsE, 'All')

figure, plotperform( trainE )
figure, plottrainstate( trainE )
figure, plotresponse( targetsE, outputsE )
figure, ploterrcorr( errorsE )
figure, plotinerrcorr( inputsE, errorsE )
figure, ploterrhist( errorsTrainE, 'train', errorsValE, 'validation', errorsTestE, 'test' )


[ netInl, trainInl, outputsInl, errorsInl, inputsInl, targetsInl ] = searchBestTimeSeries( inputInlight, targetInlight );

errorsTrainInl = errorsInl( :, trainInl.trainInd );
errorsValInl   = errorsInl( :, trainInl.valInd );
errorsTestInl  = errorsInl( :, trainInl.testInd );

% value to save to plot regressions
targetTrainInl = targetsInl( :, trainInl.trainInd );
targetValInl   = targetsInl( :, trainInl.valInd );
targetTestInl  = targetsInl( :, trainInl.testInd );

outTestInl  = outputsInl( :, trainInl.testInd );
outValInl   = outputsInl( :, trainInl.valInd );
outTrainInl = outputsInl( :, trainInl.trainInd );

% View the Network
view( netInl )

% Plots
% Uncomment these lines to enable various plots.
figure, plotregression( targetTrainInl, outTrainInl, 'Training', targetValInl, outValInl, ...
                        'Validation', targetTestInl, outTestInl, 'Test', ...
                        targetsInl, outputsInl, 'All')

figure, plotperform( trainInl )
figure, plottrainstate( trainInl )
figure, plotresponse( targetsInl, outputsInl )
figure, ploterrcorr( errorsInl )
figure, plotinerrcorr( inputsInl, errorsInl )
figure, ploterrhist( errorsTrainInl, 'train', errorsValInl, 'validation', errorsTestInl, 'test' )
