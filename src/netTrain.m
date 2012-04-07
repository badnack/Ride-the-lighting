% -*- mode: matlab -*-

function netTrain
    load ../data/inputWork.csv;
    load ../data/targetWork.csv;
    load ../data/inputHoliday.csv;
    load ../data/targetHoliday.csv;
    [ netWork, trWork, outWork, errWork  ] = searchBestFitting ( inputWork', targetWork' );
    %[ netHoliday, trHoliday, outHoliday, errHoliday  ] = searchBestFitting ( inputHoliday', targetHoliday' );

    view ( netWork )
    figure, plotperform ( trWork )
    figure, plotregression ( targetWork', outWork )
    figure, ploterrhist ( errWork )

    %view ( netHoliday )
    %figure, plotperform ( trHoliday )
    %figure, plotregression ( targetHoliday', outHoliday )
    %figure, ploterrhist ( errHoliday )

end
