% -*- mode: matlab -*-
%
% Search best NARX Neural Network
%
% Output: [network, training, outputs, errors, inputs, targets]

function [ network, training, outputs, errors, inputs, targets ] = searchBestTimeSeries( inputs, targets )

    GOAL_MSE        = 1000;
    GOAL_REGRESSION = 0.99;

    DELAYS = 2:8;
    HIDDEN_LAYER_SIZES = 10:25;

    TRAIN_RATIO      = 0.7;
    VALIDATION_RATIO = 0.15;
    TEST_RATIO       = 0.15;

    RETRAIN_ATTEMPTS = 20;

    % Prepare data
    inputSeries = tonndata( inputs, false, false );
    targetSeries = tonndata( targets, false, false );

    bestTestReg   = 0;
    bestValReg    = 0;
    bestValMse    =  inf;
    bestTestMse   =  inf;

    % necessary assignements whether a network isn't found
    network           = 0;
    training          = 0 ;
    outputs           = 0;
    errors            = inf;

    for i = HIDDEN_LAYER_SIZES
        for d = DELAYS

            % Create a Nonlinear Autoregressive Network with External Input
            inputDelays = 1:d;
            feedbackDelays = 1:d;
            hiddenLayerSize = i;
            net = narxnet( inputDelays, feedbackDelays, hiddenLayerSize );

            [ inputs, inputStates, layerStates, targets ] = preparets( net, inputSeries, {}, targetSeries );

            net.divideFcn = 'dividerand';  % Divide data randomly
            net.divideMode = 'value';  % Divide up every value
            net.divideParam.trainRatio = TRAIN_RATIO;
            net.divideParam.valRatio = VALIDATION_RATIO;
            net.divideParam.testRatio = TEST_RATIO;

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
                [ net, tr ] = train( net,inputs,targets, inputStates,layerStates );

                % Test the Network
                out = net( inputs,inputStates,layerStates );
                err = gsubtract( targets, out );
                mse = perform( net, targets, out );


                xi = nnfast.getelements( inputs, 1 );
                ei = nnfast.getelements( err, 1 );
                errcorr = checkCorr( ei, ei, 1 );
                inecorr = checkCorr( xi, ei, 1 );

                % Recalculate Training, Validation and Test Performance
                testMse = perform( net,targets( :, tr.testInd),out ( :, tr.testInd ) );
                valMse = perform( net,targets( :, tr.valInd ),out( :,tr.valInd ) );
                valReg = regression( targets( :, tr.valInd ), out( :,tr.valInd ), 'one' );
                testReg = regression( targets( :, tr.testInd ),out( :,tr.testInd ), 'one' );


                if ( valMse <= bestValMse && testMse <= ...
                     bestTestMse && testReg >= ...
                     bestTestReg && valReg >= bestValReg && inecorr && ...
                     errcorr )

                    disp( 'Best net found!' );
                    bestTestMse = testMse
                    bestValMse = valMse;
                    bestTestReg = testReg
                    bestValReg = valReg;
                    network  = net;
                    training = tr;
                    outputs  = out;
                    errors   = err;

                    % Goal reached
                    if ( testMse <= GOAL_MSE  && testReg >= GOAL_REGRESSION )
                        disp( 'Goal reached!' );
                        return
                    end


                end
            end  % end ATTEMPTS for
        end  % end DELAYS for
    end  % end HIDDEN for

end

% Check error autocorrelation
% Return TRUE if correlation values aren't too bad
function valid = checkCorr( a, b, tollerance )
    BAD_STEP_TOLLERANCE = 1;
    STEPS = 20;
    corr_limit = -1;

    maxlagi = min( STEPS, numtimesteps( b ) - 1 );
    corr = nncorr( a, b, maxlagi, 'unbiased' );
    corr = corr{1,1};


    if cell2mat( a ) == cell2mat( b ) %autocorrelation!!!
         corr_limit = corr( maxlagi + 1 ) *2 / sqrt( length(a) );
    else
        corr_limit = std( cell2mat( a ) ) * std( cell2mat( b ) ) * 2 / sqrt( length( b ) );

    end
    bad_steps = 0;
    for c = corr
        if abs( c ) > abs( corr_limit ) * tollerance
            bad_steps = bad_steps + 1;
        end
    end
    valid = true;

    if bad_steps > BAD_STEP_TOLLERANCE
        valid = false;
    end
end
