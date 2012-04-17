% -*- mode: matlab -*-
%
% Search best neural network
%
% Output: [network, training, outputs, errors]

function [ network, training, outputs, errors ] = searchBestFitting( inputs, targets )
    GOAL_MSE = 1000;
    GOAL_REGRESSION = 0.99;

    HIDDEN_LAYER_SIZE_TRIES = 10:26;

    TRAIN_RATIO     = 0.70;
    VALUATION_RATIO = 0.15;
    TEST_RATIO      = 0.15;

    RETRAIN_ATTEMPTS = 10;

    bestMSE = inf;
    bestValMse = inf;
    bestTestMse = inf;

    bestTotReg = 0;
    bestTestReg = 0;
    bestValReg = 0;

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
            
            
            totMse = perform( net, targets, out );            
            testMse = perform(net,targets(:,tr.testInd),out(:,tr.testInd));
            valMse = perform(net,targets(:,tr.trainInd),out(:,tr.trainInd));

            totReg = regression( targets, out, 'one' );
            trainingReg = regression(targets(:,tr.trainInd),out(:,tr.trainInd),'one');
            valReg = regression(targets(:,tr.valInd), out(:,tr.valInd),'one');
            testReg = regression(targets(:,tr.testInd),out(:,tr.testInd),'one');
 
            

            if ( valMse < bestValMse && totReg > bestTotReg && testMse < ...
                 bestTestMse && totMse < bestMSE && testReg > ...
                 bestTestReg && valReg > bestValReg)

                disp( 'Best net found!' );
                bestMSE  = totMse;
                bestTestMse = testMse;
                bestValMse = valMse;
                bestTotReg  = totReg;
                bestTestReg = testReg;
                bestValReg = valReg;
                network  = net;
                training = tr;
                outputs  = out;
                errors   = err;

                % Goal reached
                if ( totMse <= GOAL_MSE  && totReg >= GOAL_REGRESSION )
                    disp('Goal reached!');
                    return
                end
            end

        end  % RETRAIN_ATEMPTS end
    end  % HIDDEN_LAYER_SIZE end
