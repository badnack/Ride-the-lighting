% -*- mode: matlab -*-
%
% Search best NARX Neural Network
%
% Output: [network, training, outputs, errors, inputs, targets]

function [ network, training, outputs, errors, inputs, targets ] = searchBestTimeSeries( inputs, targets )

    GOAL_MSE        = 2000;
    GOAL_REGRESSION = 0.99;

    DELAYS = 2:4;
    HIDDEN_LAYER_SIZES = 10:12;

    TRAIN_RATIO      = 0.7;
    VALIDATION_RATIO = 0.15;
    TEST_RATIO       = 0.15;

    RETRAIN_ATTEMPTS = 50;


    bestTestReg   = 0;
    bestValReg    = 0;
    bestValMse    =  inf;
    bestTestMse   =  inf;

    % necessary assignements whether a network isn't found
    network           = 0;
    training          = 0 ;
    outputs           = 0;
    errors            = inf;
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

            [ in, inputStates, layerStates, tar ] = preparets( net, inputSeries, {}, targetSeries );

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
                [ net, tr ] = train( net,in,tar, inputStates,layerStates );

                % Test the Network
                out = net( in,inputStates,layerStates );
                err = gsubtract( tar, out );
                mse = perform( net, tar, out );


                xi = nnfast.getelements( in, 1 );
                ei = nnfast.getelements( err, 1 );



                inecorr = checkCorr( xi, ei, ei, 1 );
                errcorr = checkCorr( ei, ei, xi, 1 );

                % Recalculate Training, Validation and Test Performance
                testMse = perform( net,tar( :, tr.testInd),out ( :, tr.testInd ) );
                valMse = perform( net,tar( :, tr.valInd ),out( :,tr.valInd ) );
                valReg = regression( tar( :, tr.valInd ), out( :,tr.valInd ), 'one' );
                testReg = regression( tar( :, tr.testInd ),out( :,tr.testInd ), 'one' );


                if ( testMse <= ...
                     bestTestMse && testReg >= ...
                     bestTestReg &&  inecorr && ...
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
                    targets = tar;
                    inputs = in;
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
% Return TRUE if correlation values aren't bad
function valid = checkCorr( a, b, lagi, tollerance )
    BAD_STEP_TOLLERANCE = 1;
    STEPS = 20;
    corr_limit = -1;

    size = min( length(a), length(b) );
    a = a(1,1:size);
    b = b(1,1:size);
    lagi = lagi(1,1:size);


    maxlagi = min( STEPS, numtimesteps( lagi ) - 1 );
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
