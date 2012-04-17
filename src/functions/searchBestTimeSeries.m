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

            valid = checkErrcorr( errors )
        end
    end

end

% Check error autocorrelation
% Return true if autocorrelation not too bad
function valid = checkErrcorr(e)
    STEPS = 20;
    corr = nncorr( e, e, STEPS, 'unbiased' );
    corr = corr{1,1};
    corr_zero = nncorr( e, e, 0, 'unbiased' );
    corr_zero = corr_zero{1,1}
    maxlagi = min( STEPS, numtimesteps(e) - 1 );
    corr_limit = corr( maxlagi+1 )*2 / sqrt( length(e) );
    
    bad_steps = 0;
    for c = corr
        if c > corr_limit*1.5
            bad_steps = bad_steps + 1
        end
    end
    valid = true;
    if bad_steps > 1
        valid = false;
    end
end
