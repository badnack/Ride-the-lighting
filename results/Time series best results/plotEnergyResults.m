clear;
load 'optTimeSeries.mat'
view(netE)

figure, plotregression( targetTrainE, outTrainE,'Training',targetValE,outValE, ...
                        'Validation', targetTestE, outTestE, 'Test', ...
                        targetsE, outputsE, 'All')


figure, plotperform( trainE )
figure, ploterrcorr( errorsE )
figure, plotinerrcorr( inputsE, errorsE )
figure, ploterrhist( errorsTrainE, 'train', errorsValE, 'validation', errorsTestE, 'test' )
