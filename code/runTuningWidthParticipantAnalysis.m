function results = runTuningWidthParticipantAnalysis(subjectDataStruct, opts)

    if nargin < 2 || isempty(opts)
        opts = struct();
    end

    opts = fillDefaultOpts_runTuningWidthParticipantAnalysis(opts);

    % -------------------------
    % run ILDPlots2
    % -------------------------
    stats_allptc = runILDPlots2_wrapper(subjectDataStruct, opts);

    % -------------------------
    % extract requested metric
    % -------------------------
    metricMat = extractTuningWidthMetric(stats_allptc, opts.metricField, opts.metricCol);

    % p-values for plotting
    if ~isempty(opts.pField)
        pMat = extractTuningWidthMetric(stats_allptc, opts.pField, opts.metricCol);
        pMat(isnan(pMat)) = 0.9;
    else
        pMat = [];
    end

    % -------------------------
    % reshape into L/R matrices
    % -------------------------
    [nSub, nCols] = size(metricMat);
    nROI = nCols / 2;

    if mod(nCols,2) ~= 0
        error('metricMat must have an even number of columns (L/R for each ROI).');
    end

    dataL = metricMat(:,1:2:end);
    dataR = metricMat(:,2:2:end);

    % -------------------------
    % plot
    % -------------------------
    mapNames_plot = opts.mapNames_plot;

    plotOpts = opts.plotOpts;
    plotOpts.xlim = [1 nROI];

    if opts.doPlot
        % plotILDsigmaslopeViolin_CollapseHemi( ...
        %     metricMat, ...
        %     pMat, ...
        %     mapNames_plot, ...
        %     plotOpts);
        plotILDsigmaslopeViolin_HalfHemi(metricMat, pMat, mapNames_plot, plotOpts)
    end

    % -------------------------
    % stats
    % -------------------------
    statsOpts = opts.statsOpts;
    statsOpts.metricName = opts.metricField;
    statsRes = runILDMetricStats( ...
        dataL, ...
        dataR, ...
        string(opts.subjectNamesUsed), ...
        string(opts.mapNames(:)), ...
        statsOpts);

    % -------------------------
    % outputs
    % -------------------------
    results = struct();
    results.stats_allptc = stats_allptc;
    results.metricMat = metricMat;
    results.pMat = pMat;
    results.dataL = dataL;
    results.dataR = dataR;
    results.statsRes = statsRes;
end