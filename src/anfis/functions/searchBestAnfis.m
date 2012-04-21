% -*- mode: matlab -*-
%
% Search best neural network
%
% Output: [network, train_errors, test_errors, check_errors]

function [ network, nMF, bestTestMse ] = searchBestAnfis( trnData, chData, testData )

    EPOCHES_VALUES = [30:35];
    GOAL_MSE       = 20;
    MF_VALUES      = [3:7];
    MF_INIT        = [ MF_VALUES(1), MF_VALUES(1) ];

    numMFs  = MF_INIT;
    mfType  = 'gbellmf';

    test_inputs = testData(:,1:2);
    test_targets = testData(:,3);

    bestTestMse = inf;
    network = 0;
    mse = inf;

    silent_mode = zeros( 4, 1 );

    % tries the same differents epoches
    for epoch_n = EPOCHES_VALUES

        numMFs  = MF_INIT;

        % tries each values between Ms min value and ms max value
        for i = MF_VALUES
            for j = MF_VALUES

                numMFs  = [ i, j ];

                % generates a fis with 5 gaussian bell membership functions for each input
                in_fis = genfis1( trnData, numMFs, mfType );

                %anfis
                [ out_fis, error, ss, chkFis, chkErr ] = anfis( trnData, in_fis, epoch_n, silent_mode, chData, 1 );

                % tests the network
                anfis_output = evalfis( test_inputs, out_fis );

                mse = sqrt( sum( (test_targets(:) - anfis_output(:)).^2) / numel(test_targets) );

                disp(sprintf( ['Epoches #%d - Mfs: [%d %d] - MSE #%d'], epoch_n, i, j, mse ) );


                %mse ( doesn't exist a matlab function)
                if mse < bestTestMse

                    disp( 'best value found!' );
                    bestTestMse = mse;
                    network = out_fis;
                    nMF = numMFs;

                    if mse <= GOAL_MSE
                        return
                    end
                end

            end

        end
    end

end