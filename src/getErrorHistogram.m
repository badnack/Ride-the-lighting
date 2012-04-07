% This script is an alternativre version of matlab ploterrhist.
% It has been modified to retrieve the error of the highest column
% of histogram, without plot anything.


function ebins = getErrorHistogram(varargin)
    persistent INFO;
    if isempty(INFO), INFO = get_info; end
    if nargin == 0
        fig = nnplots.find_training_plot(mfilename);
        if nargout > 0
            out1 = fig;
        elseif ~isempty(fig)
            figure(fig);
        end
        return;
    end

    [args,param] = nnparam.extract_param(varargin,INFO.defaultParam);
    update_args = standard_args(args{:});
    if ischar(update_args)
        nnerr.throw(update_args);
    end
    [plotData,fig] = setup_figure([],INFO,false);
    unsuitable = unsuitable_to_plot(param,update_args{:});
    if isempty(unsuitable)
        [plotData,ebins] = update_plot(param,fig,plotData,update_args{:});
        nnplots.enable_plot(plotData);
    else
        nnplots.disable_plot(plotData,unsuitable);
    end
    set(fig,'visible','off');

    if nargout > 0, out1 = fig; end

end

function tag = new_tag
    tagnum = 1;
    while true
        tag = [upper(mfilename) num2str(tagnum)];
        fig = nnplots.find_plot(tag);
        if isempty(fig), return; end
        tagnum = tagnum+1;
    end
end

function [plotData,fig] = setup_figure(fig,info,isTraining)
    PTFS = nnplots.title_font_size;
    if isempty(fig)
        fig = get(0,'CurrentFigure');
        if isempty(fig) || strcmp(get(fig,'nextplot'),'new')
            if isTraining
                tag = ['TRAINING_' upper(mfilename)];
            else
                tag = new_tag;
            end
            fig = figure('visible','off','tag',tag);
            if isTraining
                set(fig,'CloseRequestFcn',[mfilename '(''close_request'')']);
            end
        else
            clf(fig);
            set(fig,'tag','');
            set(fig,'tag',new_tag);
        end
    end
    set(0,'CurrentFigure',fig);
    ws = warning('off','MATLAB:Figure:SetPosition');
    plotData = setup_plot(fig);
    warning(ws);
    if isTraining
        set(fig,'nextplot','new');
        update_training_title(fig,info,[]);
    else
        set(fig,'nextplot','replace');
        set(fig,'name',[info.name ' (' mfilename ')']);
    end
    set(fig,'NumberTitle','off','menubar','none','toolbar','none');
    plotData.CONTROL.text = uicontrol('parent',fig,'style','text',...
                                      'units','normalized','position',[0 0 1 1],'fontsize',PTFS,...
                                      'fontweight','bold','foreground',[0.7 0 0]);
    set(fig,'userdata',plotData);
end

function update_training_title(fig,info,tr)
    if isempty(tr)
        epochs = '0';
        stop = '';
    else
        epochs = num2str(tr.num_epochs);
        if isempty(tr.stop)
            stop = '';
        else
            stop = [', ' tr.stop];
        end
    end
    set(fig,'name',['Neural Network Training ' ...
                    info.name ' (' mfilename '), Epoch ' epochs stop]);
end


function info = get_info
    info = nnfcnPlot(mfilename,'Error Histogram',7.0,[...
        nnetParamInfo('bins','Number of Bins','nntype.pos_int_scalar',20,...
                      'Number of bins to divide errors between.'), ...
                   ]);
end



function args = standard_args(varargin)
    colors = {[0 0 1],[0 0.8 0],[1 0 0]};
    lastArg = varargin{end};
    if ischar(lastArg) && strcmp(lastArg,'T-Y')
        note = '= Targets - Outputs';
        varargin(end) = [];
    else
        note = '';
    end
    if length(varargin) < 1
        args = 'Not enough input arguments.';
    elseif length(varargin) == 1
        e = nntype.data('format',varargin{1});
        args = {{e},{''},colors(1),note};
    else
        count = floor(length(varargin)/2);
        if (length(varargin) ~= count*2)
            nnerr.throw('Args','Incorrect number of input arguments or unrecognized parameters.');
        end
        e = cell(1,count);
        names = cell(1,count);
        c = cell(1,count);
        for i=1:count
            e{i} = nntype.data('format',varargin{i*2-1});
            names{i} = nntype.string('format',varargin{i*2});
            if (i<length(colors))
                c{i} = colors{i};
            else
                c{i} = rand(1,3);
            end
        end
        args = {e,names,colors,note};
    end
end

function plotData = setup_plot(fig)
    PTFS = nnplots.title_font_size;
    errorColor = [1 0.6 0];
    hold on
    plotData.bars(1) = bar(0:10,'Visible', 'off');
    plotData.bars(2) = bar(0:10,'Visible', 'off');
    plotData.bars(3) = bar(0:10,'Visible', 'off');
    plotData.bars(4) = bar(0:10,'Visible', 'off');
    plotData.errorLine = line([0 0],[NaN NaN],'color',errorColor,'linewidth',2);
    plotData.bars = fliplr(plotData.bars);
    p = get(gca,'position');
    set(gca,'position',p + [0 0.12 0 -0.12])
    plotData.title = title('Error Histogram','fontweight','bold','fontsize',PTFS);
    plotData.ylabel = ylabel('Instances','fontweight','bold','fontsize',PTFS);
    plotData.xlabels = [];
    plotData.axis = gca;
    plotData.numSignals = 0;
    plotData.xlabel = text(0.5,-0.22,'Error Values','fontsize',PTFS,'fontweight','bold',...
                           'units','normalized','HorizontalAlignment','center');
    drawnow
end

function fail = unsuitable_to_plot(param,e,names,colors,note)
    fail = '';
end

% Get also the error searched represented by xz
function [plotData,xz] = update_plot(param,fig,plotData,e,names,colors,note)
    set(plotData.title,'string',...
                      ['Error Histogram with ' num2str(param.bins) ' Bins']);
    delete(plotData.xlabels);
    axis(plotData.axis);
    numSignals = length(e);
    emin = NaN;
    emax = NaN;
    for i=1:numSignals
        ei = cell2mat(e{i});
        ei = ei(:)';
        emin = min(emin,min(ei));
        emax = max(emax,max(ei));
    end
    estep = (emax-emin)/param.bins;
    ebins = emin + ((1:param.bins)-0.5)*estep;
    lastY = 0;
    for i=1:numSignals
        b = plotData.bars(i);
        ei = cell2mat(e{i});
        ei = ei(:)';
        [y,x] = hist(ei,ebins);
        y = y + lastY;
        set(b,'xdata',x,'ydata',y,'facecolor',colors{i},...
              'barWidth',0.8,'visible','on');
        lastY = y;
    end
    ymax = max(y); %highest value on histogram

    for i=1:length(y)
        if(y(i) == ymax)
            xz = x(i);
        end
    end


    set(plotData.axis,'xlim',[emin emax],'ylim',[0 ymax*1.1]);
    set(plotData.errorLine,'ydata',[0 ymax*1.1])
    if ~isempty(names{1})
        legend([plotData.bars(1:numSignals) plotData.errorLine],names{:},'Zero Error');
    else
        legend(plotData.errorLine,'Zero Error');
    end
    set(plotData.axis,'xtick',ebins);
    for i=(numSignals+1):4
        b = plotData.bars(i);
        set(b,'xdata',1:2,'ydata',1:2,'visible','off');
    end
    labels = cell(1,param.bins);
    for i=1:param.bins
        numchar = 4;
        str = sprintf(['%.' num2str(numchar) 'g'],ebins(i));
        while(length(str) > 8)
            numchar = numchar - 1;
            str = sprintf(['%.' num2str(numchar) 'g'],ebins(i));
        end
        labels{i} = str;
    end
    xticks = get(gca,'XTick');
    yticks = get(gca,'YTick');
    ypos = yticks(1)-.1*(yticks(2)-yticks(1));
    plotData.xlabels = text(xticks,repmat(ypos,length(xticks),1),labels,...
                            'HorizontalAlignment','right','rotation',90);
    set(gca,'xticklabel',[])
    set(plotData.xlabel,'string',['Errors ' note]);
end
