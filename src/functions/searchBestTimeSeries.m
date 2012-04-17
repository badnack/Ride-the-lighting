% -*- mode: matlab -*-
%
% Search best NARX Neural Network
%
% Output: [network, training, outputs, errors]

function [ network, training, outputs, errors ] = searchBestTimeSeries( inputs, targets )
    GOAL_MSE = 4000;
    GOAL_REGRESSION = 0.95;

    HIDDEN_LAYER_SIZES = 20:20;

    TRAIN_RATIO     = 0.90;
    VALUATION_RATIO = 0.05;
    TEST_RATIO      = 0.05;

    RETRAIN_ATTEMPTS = 1;

    bestMSE = inf;
    bestReg = 0;

    % Prepare data
    inputSeries = tonndata( inputs, false, false );
    targetSeries = tonndata( targets, false, false );

    for i = HIDDEN_LAYER_SIZES
        % Create a Nonlinear Autoregressive Network with External Input
        inputDelays = 1:4;
        feedbackDelays = 1:4;
        hiddenLayerSize = 20;
        net = narxnet( inputDelays, feedbackDelays, i );

        [inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

        net.divideFcn = 'dividerand';  % Divide data randomly
        net.divideMode = 'value';  % Divide up every value
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;

        net.trainFcn = 'trainlm';  % Levenberg-Marquardt
        net.performFcn = 'mse';  % Mean squared error

        % No GUI
        net.trainParam.showWindow = false;
        net.trainParam.showCommandLine = false;

        net.plotFcns = {'plotperform','plottrainstate','plotresponse', 'ploterrcorr', 'plotinerrcorr'};

        for j = 1:RETRAIN_ATTEMPTS
            disp( sprintf( 'HiddenLayerSize: %d - Attempt #%d', i, j) );
            net = init( net );

            % Train the Network
            [net,tr] = train(net,inputs,targets,inputStates,layerStates);

            % Test the Network
            out = net(inputs,inputStates,layerStates);
            err = gsubtract(targets,out);
            mse = perform(net,targets,out)

            % Recalculate Training, Validation and Test Performance
            trainTargets = gmultiply(targets,tr.trainMask);
            valTargets = gmultiply(targets,tr.valMask);
            testTargets = gmultiply(targets,tr.testMask);
            trainPerformance = perform(net,trainTargets,out)
            valPerformance = perform(net,valTargets,out)
            testPerformance = perform(net,testTargets,out)

            network  = net;
            errors   = err;
            outputs  = out;
            training = tr;
            % errcorr( errors );
        end
    end

end

% Error autocorrelation
function [ max_cor lim_cor ] = errcorr(e)
  numSignals = length(e);

  maxlag = 0;
  ymin = 0;
  ymax = 0;
  confint = 0;
  for i=1:numSignals
    ei = nnfast.getelements(e{i}, 7.0);
    maxlagi = min(20,numtimesteps(ei)-1);
    maxlag = max(maxlag,maxlagi);
    corr = nncorr(ei,ei,maxlagi,'unbiased');
    corr = corr{1,1};
    confint = confint + corr(maxlagi+1)*2/sqrt(length(ei));
    ymin = min(ymin,min(corr));
    ymax = max(ymax,max(corr));
  end
  xlim = [-maxlag-1 maxlag+1];
  confint = confint / numSignals;
  ylim = [min(-confint,ymin) max(confint,ymax)];
  ylim = ylim + ((ylim(2)-ylim(1))*0.1*[-1 1]);
  lim_cor = confint;
  max_cor = 0;
  disp(abs(corr(31)));
  for i=1:length(corr)
      if(corr(i) ~= ymax)

        if(abs(corr(i)) > max_cor)
            max_cor = abs(corr(i));
        end
      end
  end
end
