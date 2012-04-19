% -*- mode: matlab -*-
%
% Search best neural network
%
% Output: [network, train_errors, test_errors, check_errors]

function [ network, trainErrors, testErrors, checkErrors ] = searchBestAnfis( trnData, chData, testData )
    
    EPOCHES_VALUES = [30:50];
    ATTEMPTS = [10:20];
    MIN_MS = [4 4];
    MAX_MS = [8 8];
    
    numMFs  = MIN_MS;
    mfType  = 'gbellmf';
    
    test_inputs = testData(:,1:2);
    test_targets = testData(:,3);
       
    trainErrors = inf;
    testErrors  = inf;
    checkErrors = inf;
    testBestMse = inf;
    network = 0;

    silent_mode = zeros( 4, 1 );
    found = false;
    
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
            err = gsubtract( test_targets, anfis_output );

            mse = sqrt( sum( (test_targets(:)-anfis_output(:)).^2) / numel(test_targets) );




            %mse ( doesn't exist a matlab function)
            if mse < testBestMse
                disp( 'best value found!' );
                testBestMse = mse;
                found = true;
                testErrors = err;
                checkErrors = chkErr;
                trainErrors = error;                        
            elseif found ==false
                break
            end            
            
        end
        
        found = false;
        
    end
    
end