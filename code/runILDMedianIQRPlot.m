function results = runILDMedianIQRPlot(allData, opts)

% runILDMedianIQRPlot
%
% Example:
%   opts = struct();
%   opts.whichSub = [1 13 14 15 18 19 20 21];
%   opts.baseMapNames = baseMapNames;
%   opts.baseDTnames = baseDTnames;
%   opts.baseModelNames = baseModelNames;
%   results = runILDMedianIQRPlot(allData, opts);

    if nargin < 2 || isempty(opts)
        opts = struct();
    end

    opts = fillDefaultOpts_runILDMedianIQRPlot(opts);
    if strcmp(opts.scale, 'lin')
        opts.Range=[-22 22];
    else
        opts.Range=[-4.1 4.1];
    end

    % -------------------------
    % ROI stats
    % -------------------------
    [pref_all, sigma_all, stats_pref_all] = roiPrefStats_allptc( ...
        allData, ...
        opts.whichSub, ...
        opts.mapNames, ...
        opts.hemispheres, ...
        opts.baseModelNames, ...
        opts.whichModel, ...
        opts.baseDTnames, ...
        opts.whichDT_all, ...
        opts.veThresh, ...
        opts.scale, ...
        opts.condition, ...
        'Range', opts.Range, ...
        'EdgeThr', opts.EdgeThr, ...
        'BinWidth', opts.BinWidth);

    % -------------------------
    % collect median / IQR
    % -------------------------
    nSub  = numel(opts.whichSub);
    nROI  = numel(opts.mapNames);
    nHemi = numel(opts.hemispheres);
    nDT   = numel(opts.whichDT_all);

    pref_median_all = nan(nSub, nROI, nHemi, nDT);
    pref_IQR_all    = nan(nSub, nROI, nHemi, nDT);
    pref_sigma_all = nan(nSub, nROI, nHemi, nDT);

    for iSub = 1:nSub
        for iROI = 1:nROI
            for iHemi = 1:nHemi
                for iDT = 1:nDT
                    if ~isempty(stats_pref_all{iSub, iROI, iHemi, iDT})
                        pref_median_all(iSub, iROI, iHemi, iDT) = stats_pref_all{iSub, iROI, iHemi, iDT}.medianPref;
                        pref_IQR_all(iSub, iROI, iHemi, iDT)    = stats_pref_all{iSub, iROI, iHemi, iDT}.IQRPref;
                        pref_sigma_all(iSub, iROI, iHemi, iDT) = stats_pref_all{iSub, iROI, iHemi, iDT}.mediansigma;
                    end
                end
            end
        end
    end

    % -------------------------
    % select plotting DT
    % -------------------------
    if opts.whichDT_plot > nDT
        error('opts.whichDT_plot exceeds number of selected DTs.');
    end

    pref_median_plot = pref_median_all(:,:,:,opts.whichDT_plot);
    pref_IQR_plot    = pref_IQR_all(:,:,:,opts.whichDT_plot);
    pref_sigma_plot = pref_sigma_all(:,:,:,opts.whichDT_plot);

    [nSub2, nROI2, nHemi2] = size(pref_median_plot);
    assert(nSub2 == nSub, 'Subject count mismatch.');
    assert(nROI2 == nROI, 'ROI count mismatch.');
    assert(nHemi2 == 2, 'Expecting 2 hemispheres.');

     % -------------------------
    % choose metric for plotting/output
    % -------------------------
    switch lower(opts.metricToPlot)
        case 'median'
            dataL = pref_median_plot(:,:,1);
            dataR = pref_median_plot(:,:,2);

            if opts.flipRightHemisphere
                dataR = -dataR;
            end

        case 'iqr'
            dataL = pref_IQR_plot(:,:,1);
            dataR = pref_IQR_plot(:,:,2);

        case 'sigma'
            dataL = pref_sigma_plot(:,:,1);
            dataR = pref_sigma_plot(:,:,2);

        otherwise
            error('opts.metricToPlot must be ''median'' or ''iqr''.');
    end

    % -------------------------
    % plotting
    % -------------------------
    if opts.doPlot
        plotOpts = opts.plotOpts;
        plotOpts.xlim = [1 nROI];

        Plothalfviolin(dataL, dataR, opts.cols, nROI, nSub, opts.mapNames_plot, plotOpts);
    end

    % -------------------------
    % outputs
    % -------------------------
    results = struct();
    results.pref_all = pref_all;
    results.sigma_all = sigma_all;
    results.stats_pref_all = stats_pref_all;
    results.pref_median_all = pref_median_all;
    results.pref_IQR_all = pref_IQR_all;
    results.pref_median_plot = pref_median_plot;
    results.pref_IQR_plot = pref_IQR_plot;
    results.dataL = dataL;
    results.dataR = dataR;
end