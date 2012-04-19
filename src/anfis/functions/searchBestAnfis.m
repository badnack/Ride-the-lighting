% -*- mode: matlab -*-
%
% Search best neural network
%
% Output: [network, train_errors, test_errors, check_errors]

function [ network, bestTrainErrors, bestTestErrors, bestCheckErrors ] = searchBestAnfis( trnData, chData, testData )

    EPOCHES_VALUES = [30:35];
    ATTEMPTS = [10:20];
    MIN_MS = [4 4];
    MAX_MS = [8 8];

    numMFs  = MIN_MS;
    mfType  = 'gbellmf';

    test_inputs = testData(:,1:2);
    test_targets = testData(:,3);

    bestTrainErrors = inf;
    bestTestErrors  = inf;
    bestCheckErrors = inf;
    bestTestMse = inf;

    network = 0;

    silent_mode = zeros( 4, 1 );

    % tries the same epoch ATTEMPTS times
    for epoch_n = EPOCHES_VALUES
        for i = ATTEMPTS
            disp(sprintf( 'Epoches #%d - Attempt #%d', epoch_n,( i - ATTEMPTS(1) + 1 ) ) );

            % generates a fis with 5 gaussian bell membership functions for each input
            in_fis = genfis1( trnData, numMFs, mfType );

            %anfis
            [ out_fis, error, ss, chkFis, chkErr ] = anfis( trnData, in_fis, epoch_n, silent_mode, chData, 1 );

            % tests the network
            anfis_output = evalfis( test_inputs, out_fis );

            %FIXME: use mse instead of normal error
            errTest = gsubtract( test_targets, anfis_output );

            mse = sqrt( sum( (test_targets(:)-anfis_output(:)).^2) / numel(test_targets) );



            %mse ( doesn't exist a matlab function)
            if mse < bestTestMse
                disp( 'best value found!' );
                bestTestMse = mse;
                bestTestErrors = errTest;
                bestTrainErrors = error;
                bestCheckErrors = chkErr;
            end
            %mse

        end

    end

end