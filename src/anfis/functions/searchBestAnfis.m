% -*- mode: matlab -*-
%
% Search best neural network
%
% Output: [network, train_errors, test_errors, check_errors]

function [ network, bestTrainErrors, bestTestErrors, bestCheckErrors ] = searchBestAnfis( trnData, chData, testData )

    EPOCHES_VALUES = [30:35];
    GOAL_MSE       = 50;    
    MS_VALUES      = [3:7];
    MS_INIT        = [ MS_VALUES(1), MS_VALUES(1) ];
    
    numMFs  = MS_INIT;
    mfType  = 'gbellmf';

    test_inputs = testData(:,1:2);
    test_targets = testData(:,3);

    bestTrainErrors = inf;
    bestTestErrors  = inf;
    bestCheckErrors = inf;
    bestTestMse = inf;
    network = 0;
    mse = inf;
    
    silent_mode = zeros( 4, 1 );

    % tries the same differents epoches
    for epoch_n = EPOCHES_VALUES

        numMFs  = MS_INIT;

        % tries each values between Ms min value and ms max value
        for i = MS_VALUES
            for j = MS_VALUES

                numMFs  = [ i, j ];                
                
                % generates a fis with 5 gaussian bell membership functions for each input
                in_fis = genfis1( trnData, numMFs, mfType );
                
                %anfis
                [ out_fis, error, ss, chkFis, chkErr ] = anfis( trnData, in_fis, epoch_n, silent_mode, chData, 1 );
                
                % tests the network
                anfis_output = evalfis( test_inputs, out_fis );
                
                %FIXME: use mse instead of normal error
                errTest = gsubtract( test_targets, anfis_output );
                
                mse = sqrt( sum( (test_targets(:)-anfis_output(:)).^2) / numel(test_targets) );
                
                disp(sprintf( ['Epoches #%d - Mfs: [%d %d] - MSE #%d'], epoch_n, i, j, mse ) );
                
                
                %mse ( doesn't exist a matlab function)
                if mse < bestTestMse
                    
                    disp( 'best value found!' );
                    bestTestMse = mse;
                    bestTestErrors = errTest;
                    bestTrainErrors = error;
                    bestCheckErrors = chkErr;
                    
                    if mse <= GOAL_MSE
                        return
                    end
                end
                
                
            end
            
        end
    end

    bestTestMse

end