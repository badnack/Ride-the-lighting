clear
load 'OptUsingTestNoOutliers.mat'
view ( net )
figure, plotperform( train )
figure, plotregression( targetTrain, outTrain,'Training',targetVal,outVal, ...
                        'Validation', targetTest, outTest, 'Test', ...
                        targetAll', outputs, 'All')

figure, ploterrhist( errorsTrain, 'train', errorsVal, 'validation', errorsTest, 'test' )
