function testplot( net, test, str)
    x = [1:length(test(:,1))];
    figure
    plot(x,test(:,3),'o',x,evalfis( test(:,1:2), net ),'x');
    xlabel('steps');
    ylabel('outputs');
    title(str);
    legend('targets','outputs');
end