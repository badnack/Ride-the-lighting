function [ network, training, out, err ] = searchBestFitting (varargin)
    ERROR_TO_REACH = 0.02;

    RETRAIN_ATTEMPT = 10;

    REGRESSION_TO_REACH = 0.91;

    INIT_HIDDEN_LAYER_SIZE = 10;

    MAX_HIDDEN_LAYER_SIZE = 21;

    TRAIN     =  0.9;
    VALUATION = 0.05;
    TEST      = 0.05;



    % Variables initilizations
    inputs = varargin{1};
    target = varargin{2};

    bestThreshError = inf;
    bestRegression = 0;
    stop = 0;
    hiddenLayerSize = INIT_HIDDEN_LAYER_SIZE;

    while ( stop == 0 )

        net = fitnet ( hiddenLayerSize );


        net.divideParam.trainRatio = TRAIN;
        net.divideParam.valRatio   = VALUATION;
        net.divideParam.testRatio  = TEST;

        for i = 1:RETRAIN_ATTEMPT
            net = init ( net );

            % Train the Network
            [ net, tr ] = train ( net, inputs, target );

            % Test the Network
            outputs          = net ( inputs );
            currentErrors    = gsubtract ( target, outputs );
            performance      = perform ( net, target, outputs );

            % ad-hoc functions
            currentRegression  = getRegression ( target, outputs )
            bestRegression
            currentThreshError = Errhis ( currentErrors )
            bestThreshError


            if ( abs ( currentThreshError ) < abs ( bestThreshError ) && currentRegression > bestRegression )

                % Best value Reached
                if ( abs ( currentThreshError ) <= ERROR_TO_REACH  && currentRegression >= REGRESSION_TO_REACH )
                    stop = 1;
                end

                bestTraining    = tr;
                bestNet         = net;
                bestOutputs     = outputs;
                bestErrors      = currentErrors;
                bestThreshError = currentThreshError;
                bestRegression  = currentRegression;

            end

        end

        hiddenLayerSize = hiddenLayerSize + 1;

        if ( hiddenLayerSize == MAX_HIDDEN_LAYER_SIZE )
            stop = 1;
        end


    end

    % View the Network
    network = bestNet;
    training = bestTraining;
    out = bestOutputs;
    err = bestErrors
    % Plots

end