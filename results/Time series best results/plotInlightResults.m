clear;
load 'optTimeSeries.mat'
view( netInl )

figure, plotregression( targetTrainInl, outTrainInl, 'Training', targetValInl, outValInl, ...
                        'Validation', targetTestInl, outTestInl, 'Test', ...
                        targetsInl, outputsInl, 'All')

figure, plotperform( trainInl )
figure, ploterrcorr( errorsInl )
figure, plotinerrcorr( inputsInl, errorsInl )
figure, ploterrhist( errorsTrainInl, 'train', errorsValInl, 'validation', errorsTestInl, 'test' )
