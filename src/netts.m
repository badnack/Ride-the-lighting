% -*- mode: matlab -*-
% Time Series model

addpath('./functions');
load '../data/inputAll.csv';
load '../data/targetAll.csv';

[ net, train, outputs, errors, inputs ] = searchBestTimeSeries( inputAll, targetAll );

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(train)
figure, plottrainstate(train)
% figure, plotregression(targetAll',outputs)
% figure, plotresponse(targetAll,outputs)
figure, ploterrcorr(errors)
figure, plotinerrcorr(inputs,errors)
