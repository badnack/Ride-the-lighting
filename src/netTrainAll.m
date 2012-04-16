% -*- mode: matlab -*-

function net = netTrainAll
    load ../data/inputAll.csv;
    load ../data/targetAll.csv;
    [ net, train, output, errors ] = searchBestFitting ( inputAll', targetAll' );

    view ( net )
    figure, plotperform ( train )
    figure, plotregression ( targetAll', output )
    figure, ploterrhist ( errors )

end
