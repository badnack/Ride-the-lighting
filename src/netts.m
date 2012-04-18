% -*- mode: matlab -*-
% Time Series model

addpath('./time series/functions');
load '../data/inputAll.csv';
load '../data/targetAll.csv';

[ net, train, outputs, errors, inputs, targets ] = searchBestTimeSeries( inputAll, targetAll );

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(train)
figure, plottrainstate(train)
figure, plotregression(targets,outputs)
figure, plotresponse(targets,outputs)
figure, ploterrcorr(errors)
figure, plotinerrcorr(inputs,errors)
