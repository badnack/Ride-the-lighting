% -*- mode: matlab -*-
%
% Search best NARX Neural Network
%
% Output: [network, training, outputs, errors, inputs, targets]

function [ network, training, outputs, errors, inputs, targets ] = searchBestTimeSeries( inputs, targets )
    DELAYS = 2:8;
    HIDDEN_LAYER_SIZES = 20:25;

    TRAIN_RATIO     = 0.90;
    VALUATION_RATIO = 0.05;
    TEST_RATIO      = 0.05;

    RETRAIN_ATTEMPTS = 10;

    % Prepare data
    inputSeries = tonndata( inputs, false, false );
    targetSeries = tonndata( targets, false, false );

    for i = HIDDEN_LAYER_SIZES
        for d = DELAYS

            % Create a Nonlinear Autoregressive Network with External Input
            inputDelays = 1:d;
            feedbackDelays = 1:d;
            hiddenLayerSize = i;
            net = narxnet( inputDelays, feedbackDelays, hiddenLayerSize );

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
                disp( sprintf( ['HiddenLayerSize: %d - Delay: 1:%d - Attempt #%d'], i, d, j) );
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

                errcorr = checkCorr( errors, errors, 1.2 )
                inecorr = checkCorr( inputs, errors, 15 ) % FIXME: tollerance too high!

                if inecorr && errcorr
                    disp( 'Best net found!' );
                    return
                end
            end  % end ATTEMPTS for
        end  % end DELAYS for
    end  % end HIDDEN for

end

% Check error autocorrelation
% Return TRUE if correlation values aren't too bad
function valid = checkCorr( a, b, tollerance )
    STEPS = 20;
    size = min( length(a), length(b) );
    a = a(1,1:size);
    b = b(1,1:size);
    corr = nncorr( a, b, STEPS, 'unbiased' );
    corr = corr{1,1};
    corr_zero = nncorr( a, b, 0, 'unbiased' );
    corr_zero = corr_zero{1,1}
    maxlagi = min( STEPS, numtimesteps(a) - 1 );
    corr_limit = corr( maxlagi+1 )*2 / sqrt( length(a) );

    bad_steps = 0;
    for c = corr
        if abs(c) > abs(corr_limit)*tollerance
            bad_steps = bad_steps + 1
        end
    end
    valid = true;
    if bad_steps > 1
        valid = false;
    end
end
