% -*- mode: matlab -*-
% Neural network fitting

addpath('./functions');
load '../data/inputAll.csv';
load '../data/targetAll.csv';

[ net, train, outputs, errors ] = searchBestFitting( inputAll', targetAll' );

view ( net )
figure, plotperform( train )
figure, plotregression( targetAll', outputs )
figure, ploterrhist( errors )
