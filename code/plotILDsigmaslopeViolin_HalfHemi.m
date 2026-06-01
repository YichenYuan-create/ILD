function plotILDsigmaslopeViolin_HalfHemi(rVals, pVals, roiNames, opts)
% Plot slope with two half violins per ROI
% LH = one half, RH = the other half
%
% INPUT
% rVals    : nSub x 18 (9 LH + 9 RH)
% pVals    : nSub x 18
% roiNames : 1 x 9 cell
% opts     : plotting/export options

    [nSub, nCols] = size(rVals);

    if nCols ~= 18
        error('rVals must be nSub x 18 (9 LH + 9 RH).');
    end

    if ~isequal(size(pVals), size(rVals))
        error('pVals must have the same size as rVals.');
    end

    if numel(roiNames) ~= 9
        error('roiNames must be 1x9 cell array.');
    end

    nROI = 9;

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
    % Separate LH and RH data
    % ------------------------------------------------------------
    dataL = nan(nSub, nROI);
    dataR = nan(nSub, nROI);
    pL    = nan(nSub, nROI);
    pR    = nan(nSub, nROI);

    for roiIdx = 1:nROI
        dataL(:, roiIdx) = rVals(:, roiIdx*2-1); % LH
        dataR(:, roiIdx) = rVals(:, roiIdx*2);   % RH
        pL(:, roiIdx)    = pVals(:, roiIdx*2-1);
        pR(:, roiIdx)    = pVals(:, roiIdx*2);
    end

    % ------------------------------------------------------------
    % Plot half violins
    % ------------------------------------------------------------
    figure; hold on;

    violinColsL = repmat([0.5 0.5 0.5], nROI, 1);
    violinColsR = repmat([0.85 0.85 0.85], nROI, 1);

    % LH half
    daviolinplot(dataL, ...
        'truncateviolin', 1, ...
        'violin', 'half2', ...
        'colors', violinColsL, ...
        'outliers', 0);

    % RH half
    daviolinplot(dataR, ...
        'truncateviolin', 1, ...
        'violin', 'half', ...
        'colors', violinColsR, ...
        'outliers', 0);

    plot([0.5 9.5], [0 0], 'k--');

    % ------------------------------------------------------------
    % Overlay subject points
    % ------------------------------------------------------------
    xJitter = 0;
    offset  = 0.08;

    for roiIdx = 1:nROI
        for s = 1:nSub

            % -------- LH --------
            x = roiIdx - offset + (rand-0.5)*2*xJitter;
            y = dataL(s, roiIdx);

            if contains(opts.figname, 'lin')
                if pL(s, roiIdx) < 0.05 && y > 0
                    plot(x, y, 'o', ...
                        'MarkerFaceColor', cols(s,:), ...
                        'MarkerEdgeColor', 'k', ...
                        'MarkerSize', 7, ...
                        'LineWidth', 1.2);
                else
                    plot(x, y, 'o', ...
                        'MarkerFaceColor', 'w', ...
                        'MarkerEdgeColor', cols(s,:), ...
                        'MarkerSize', 5, ...
                        'LineWidth', 1);
                end

            elseif contains(opts.figname, 'log')
                if pL(s, roiIdx) < 0.05 && y < 0
                    plot(x, y, 'o', ...
                        'MarkerFaceColor', cols(s,:), ...
                        'MarkerEdgeColor', 'k', ...
                        'MarkerSize', 7, ...
                        'LineWidth', 1.2);
                else
                    plot(x, y, 'o', ...
                        'MarkerFaceColor', 'w', ...
                        'MarkerEdgeColor', cols(s,:), ...
                        'MarkerSize', 5, ...
                        'LineWidth', 1);
                end
            else
                % fallback if figname contains neither 'lin' nor 'log'
                plot(x, y, 'o', ...
                    'MarkerFaceColor', 'w', ...
                    'MarkerEdgeColor', cols(s,:), ...
                    'MarkerSize', 5, ...
                    'LineWidth', 1);
            end

            % -------- RH --------
            x = roiIdx + offset + (rand-0.5)*2*xJitter;
            y = dataR(s, roiIdx);

            if contains(opts.figname, 'lin')
                if pR(s, roiIdx) < 0.05 && y > 0
                    plot(x, y, 'd', ...
                        'MarkerFaceColor', cols(s,:), ...
                        'MarkerEdgeColor', 'k', ...
                        'MarkerSize', 7, ...
                        'LineWidth', 1.2);
                else
                    plot(x, y, 'd', ...
                        'MarkerFaceColor', 'w', ...
                        'MarkerEdgeColor', cols(s,:), ...
                        'MarkerSize', 5, ...
                        'LineWidth', 1);
                end

            elseif contains(opts.figname, 'log')
                if pR(s, roiIdx) < 0.05 && y < 0
                    plot(x, y, 'd', ...
                        'MarkerFaceColor', cols(s,:), ...
                        'MarkerEdgeColor', 'k', ...
                        'MarkerSize', 7, ...
                        'LineWidth', 1.2);
                else
                    plot(x, y, 'd', ...
                        'MarkerFaceColor', 'w', ...
                        'MarkerEdgeColor', cols(s,:), ...
                        'MarkerSize', 5, ...
                        'LineWidth', 1);
                end
            else
                % fallback if figname contains neither 'lin' nor 'log'
                plot(x, y, 'd', ...
                    'MarkerFaceColor', 'w', ...
                    'MarkerEdgeColor', cols(s,:), ...
                    'MarkerSize', 5, ...
                    'LineWidth', 1);
            end
        end
    end

    % ------------------------------------------------------------
    % Formatting
    % ------------------------------------------------------------
    ylabel('Slope');
    title('Slope (LH vs RH)');

    xlimv = opts.xlim;
    xstep = opts.xstep;
    ylimv = opts.ylim;
    ystep = opts.ystep;

    ax = gca;
    ax.FontName = 'helvetica';
    ax.LineWidth = 1;
    ax.TickLength = [0.012 0.012];
    ax.FontSize = 7;

    yticks(ylimv(1):ystep:ylimv(2));
    xticks(xlimv(1):xstep:xlimv(2));
    xticklabels(roiNames);
    xtickangle(90);

    axis([0 max(xlimv)+0.5 ylimv(1) ylimv(2)]);

    ax.Units = 'normalized';
    ax.Position = [0.18 0.18 0.75 0.75];

    pause(2);

    if opts.doExport
        exportgraphics(gcf, opts.figname, ...
            'Append', false, ...
            'ContentType', opts.contentType);
    end
end