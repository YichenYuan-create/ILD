function plotILDRepeatabilityViolin_CollapseHemi(rVals, pVals, roiNames,opts)
% Plot ILD repeatability collapsed across hemispheres
% Each ROI combines LH and RH data into one violin


    [nSub, nROI] = size(rVals);

    % if nROI ~= 18
    %     error('rVals must be nSub x 18 (9 LH + 9 RH).');
    % end
    % 
    % if numel(roiNames) ~= 9
    %     error('roiNames must be 1x9 cell array.');
    % end

    % ------------------------------------------------------------
    % Subject colors
    % ------------------------------------------------------------
    baseCols = [
        0.894 0.102 0.110
        0.216 0.494 0.722
        0.302 0.686 0.290
        0.596 0.306 0.639
        1.000 0.498 0.000
        1.000 0.749 0.000
        0.651 0.337 0.157
        0.969 0.506 0.749
        0.200 0.200 0.200
    ];

    cols = baseCols(1:nSub,:);

    % ------------------------------------------------------------
    % Build violin data (collapse hemisphere)
    % ------------------------------------------------------------
    violindata = nan(nSub*2, 9);   % LH + RH

    for roiIdx = 1:9
        violindata(:, roiIdx) = ...
            [rVals(:, roiIdx*2-1); rVals(:, roiIdx*2)];
    end

    % ------------------------------------------------------------
    % Plot
    % ------------------------------------------------------------
    figure; hold on;

    violincols = repmat([0.5 0.5 0.5], 9, 1);
    daviolinplot(violindata, ...
        'truncateviolin', 1, ...
        'violin', 'full', ...
        'colors', violincols);

    plot([0.5 9.5],[0 0],'k--');

    xJitter = 0;

    for roiIdx = 1:9
        for s = 1:nSub

            % -------- LH --------
            x = roiIdx + (rand-0.5)*2*xJitter;
            y = rVals(s, roiIdx*2-1);

            if pVals(s, roiIdx*2-1) < 0.05 && y>0
                plot(x,y,'o','MarkerFaceColor',cols(s,:), ...
                    'MarkerEdgeColor','k','MarkerSize',7,'LineWidth',1.2);
            else
                plot(x,y,'o','MarkerFaceColor','w', ...
                    'MarkerEdgeColor',cols(s,:), ...
                    'MarkerSize',5,'LineWidth',1);
            end

            % -------- RH --------
            x = roiIdx + (rand-0.5)*2*xJitter;
            y = rVals(s, roiIdx*2);

            if pVals(s, roiIdx*2) < 0.05 && y>0
                plot(x,y,'o','MarkerFaceColor',cols(s,:), ...
                    'MarkerEdgeColor','k','MarkerSize',7,'LineWidth',1.2);
            else
                plot(x,y,'o','MarkerFaceColor','w', ...
                    'MarkerEdgeColor',cols(s,:), ...
                    'MarkerSize',5,'LineWidth',1);
            end
        end
    end

    % ------------------------------------------------------------
    % Formatting
    % ------------------------------------------------------------
    % set(gca,'XTick',1:9,'XTickLabel',roiNames, ...
    %     'TickLabelInterpreter','none');
    % xtickangle(45);

    ylabel('Correlation r (odd vs even)');
    % axis([0.5 9.5 yLim(1) yLim(2)]);
    % axis square;

    title('Repeatability of ILD preference (collapsed across hemispheres)');

    % set(gca,'Color','w');
    % set(gcf,'Color','w');
    % box off;



    xlim=opts.xlim;
    xstep=opts.xstep;
    ylim = opts.ylim;
    ystep=opts.ystep;
    
    
    ax=gca;
    ax.FontName='helvetica'
    % ax.Units='points';
    ax.LineWidth=1;
    ax.TickLength = [0.012 0.012];
    ax.FontSize=7;
    yticks(ylim(1):ystep:ylim(2))
    % set(gca,'XTick',1:nROI, ...
    %         'XTickLabel', mapNames, ...
    %         'TickLabelInterpreter','none');
    % xticks(0:10:max(M1.currTsData.x))    
    % xticks(0:1:nROI)    
    xticks(xlim(1):xstep:xlim(2))  
    xticklabels(roiNames)
    xtickangle(90);
    axis([0 max(xlim)+0.5 ylim(1) ylim(2)]);
    % ax.Position=[20 20 0+202 0+45];
    ax.Units = 'normalized';
    ax.Position = [0.18 0.18 0.75 0.75];   
    pause(2)
    if opts.doExport
        
    
        
        exportgraphics(gcf, opts.figname, ...
            'Append', false, ...
            'ContentType', opts.contentType);
    end
    
end
