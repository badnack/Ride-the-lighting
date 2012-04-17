% -*- mode: matlab -*-
%
% Search best neural network
%
% Output: [network, training, outputs, errors]

function [ network, training, outputs, errors ] = searchBestFitting( inputs, targets )
    GOAL_MSE = 4000;
    GOAL_REGRESSION = 0.95;

    HIDDEN_LAYER_SIZE_TRIES = 20:25;

    TRAIN_RATIO     = 0.90;
    VALUATION_RATIO = 0.05;
    TEST_RATIO      = 0.05;

    RETRAIN_ATTEMPTS = 10;

    bestMSE = inf;
    bestReg = 0;

    for i = HIDDEN_LAYER_SIZE_TRIES
        net = fitnet( i );

        net.divideFcn = 'dividerand';
        net.divideMode = 'sample';
        net.divideParam.trainRatio = TRAIN_RATIO;
        net.divideParam.valRatio   = VALUATION_RATIO;
        net.divideParam.testRatio  = TEST_RATIO;

        net.trainFcn = 'trainlm';  % Levenberg-Marquardt
        net.performFcn = 'mse';

        % No GUI
        net.trainParam.showWindow = false;
        net.trainParam.showCommandLine = false;

        for j = 1:RETRAIN_ATTEMPTS
            disp( sprintf( 'HiddenLayerSize: %d - Attempt #%d', i, j) );
            net = init( net );

            % Train the Network
            [ net, tr ] = train( net, inputs, targets );

            % Test the Network
            out = net( inputs );
            err = gsubtract( targets, out );
            mse = perform( net, targets, out );
            reg = regression( targets, out, 'one' );

            if ( mse < bestMSE && reg > bestReg )
                disp( 'Best net found!' );
                bestMSE  = mse
                bestReg  = reg
                network  = net;
                training = tr;
                outputs  = out;
                errors   = err;

                % Goal reached
                if ( mse <= GOAL_MSE  && reg >= GOAL_REGRESSION )
                    disp('Goal reached!');
                    return
                end
            end

        end  % RETRAIN_ATEMPTS end
    end  % HIDDEN_LAYER_SIZE end
