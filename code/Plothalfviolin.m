function Plothalfviolin(dataL, dataR, cols, nROI, nSub, mapNames,opts)
figure; hold on;

% 2 group colors (L and R) for violins/boxplots

roiGrayL = repmat([0.5 0.5 0.5], nROI, 1);  % 

hL = daviolinplot(dataL, ...
    'violin','half2', ...        % 
    'truncateviolin',1, ...
    'colors', roiGrayL, ...
    'outliers', 0);

roiGrayR = repmat([0.85 0.85 0.85], nROI, 1);  % 

hR = daviolinplot(dataR, ...
    'violin','half', ...          % 
    'truncateviolin',1, ...
    'colors', roiGrayR, ...
    'outliers', 0);

% xJitter = 0.05;
xJitter = 0;
offset  = 0.08;

for r = 1:nROI
    for s = 1:nSub
        % Left hemi
        plot(r - offset + (rand-0.5)*2*xJitter, dataL(s,r), 'o', ...
            'MarkerEdgeColor',cols(s,:), ...
            'MarkerFaceColor', 'none', ...
            'MarkerSize',7,'LineWidth',2);
        % plot(r - offset + (rand-0.5)*2*xJitter, dataL(s,r), 'o', ...
        %     'MarkerEdgeColor','k', ...
        %     'MarkerFaceColor', cols(s,:), ...
        %     'MarkerSize',8,'LineWidth',1);

        % Right hemi
        plot(r + offset + (rand-0.5)*2*xJitter, dataR(s,r), 'd', ...
            'MarkerEdgeColor',cols(s,:), ...
            'MarkerFaceColor', 'none', ...
            'MarkerSize',7,'LineWidth',2);
        % plot(r + offset + (rand-0.5)*2*xJitter, dataR(s,r), 'd', ...
        %     'MarkerEdgeColor','k', ...
        %     'MarkerFaceColor', cols(s,:), ...
        %     'MarkerSize',8,'LineWidth',1);
    end
end
if opts.plotyequal0
    plot([0 nROI+0.5],[0 0],'k--');
end
% 
% ylabel('Peak ILD');
% title('Peak ILD preference – Left vs Right hemisphere');
% ylim([-20,20])

% axis square;
% box off;
% set(gca,'Color','w');
% set(gcf,'Color','w');
% rangeylim = max([max(dataL(:)) max(dataR(:))]) - min([min(dataL(:)) min(dataR(:))]);
% opts.ylim = [min([min(dataL(:)) min(dataR(:))])-rangeylim/10 max([max(dataL(:)) max(dataR(:))])+rangeylim/10];
% opts.ystep = round(rangeylim/5);
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
xticklabels(mapNames)
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