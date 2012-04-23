% -*- mode: matlab -*-
% Time Series model

addpath('./time series/functions');
unix('cd ../data/time\ series; ./energy.rb');
unix('cd ../data/time\ series; ./inlight.rb');

load '../data/time series/inputEnergy.csv';
load '../data/time series/targetEnergy.csv';

load '../data/time series/inputInlight.csv';
load '../data/time series/targetInlight.csv';


[ net, train, outputs, errors, inputs, targets ] = searchBestTimeSeries( inputEnergy, targetEnergy );

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
