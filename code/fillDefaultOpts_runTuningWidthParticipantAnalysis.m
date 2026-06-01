function opts = fillDefaultOpts_runTuningWidthParticipantAnalysis(opts)

    requiredFields = {'subjectOrder','whichSubs','mapNames','hemispheres', ...
                      'baseModelNames','baseDTnames'};
    for i = 1:numel(requiredFields)
        f = requiredFields{i};
        if ~isfield(opts,f) || isempty(opts.(f))
            error('opts.%s is required.', f);
        end
    end

    if ~isfield(opts,'modelNames') || isempty(opts.modelNames)
        opts.modelNames = opts.baseModelNames;
    end

    if ~isfield(opts,'whichModel') || isempty(opts.whichModel)
        opts.whichModel = 5;
    end

    if ~isfield(opts,'whichDT') || isempty(opts.whichDT)
        opts.whichDT = [1 2 3];
    end

    if ~isfield(opts,'veThresh') || isempty(opts.veThresh)
        opts.veThresh = 0.2;
    end

    if ~isfield(opts,'whichPlots') || isempty(opts.whichPlots)
        opts.whichPlots = [0 0 0 0 0 1 0];
    end

    if ~isfield(opts,'scale') || isempty(opts.scale)
        opts.scale = 'lin';
    end

    if ~isfield(opts,'metricField') || isempty(opts.metricField)
        opts.metricField = 'BsigMajorMean';
    end

    if ~isfield(opts,'metricCol') || isempty(opts.metricCol)
        opts.metricCol = 2;
    end

    if ~isfield(opts,'pField') || isempty(opts.pField)
        opts.pField = 'PsigMajorMean';
    end

    if ~isfield(opts,'doPlot') || isempty(opts.doPlot)
        opts.doPlot = true;
    end

    if ~isfield(opts,'plotOpts') || isempty(opts.plotOpts)
        plotOpts = struct();
    else
        plotOpts = opts.plotOpts;
    end

    if ~isfield(plotOpts,'doExport'); plotOpts.doExport = true; end
    if ~isfield(plotOpts,'figname'); plotOpts.figname = 'slope.pdf'; end
    if ~isfield(plotOpts,'contentType'); plotOpts.contentType = 'vector'; end
    if ~isfield(plotOpts,'xstep'); plotOpts.xstep = 1; end
    if ~isfield(plotOpts,'plotyequal0'); plotOpts.plotyequal0 = true; end

    opts.plotOpts = plotOpts;

    if ~isfield(opts,'statsOpts') || isempty(opts.statsOpts)
        statsOpts = struct();
    else
        statsOpts = opts.statsOpts;
    end

    if ~isfield(statsOpts,'signrankCenter'); statsOpts.signrankCenter = 0; end

    opts.statsOpts = statsOpts;

    if ~isfield(opts,'subjectNamesUsed') || isempty(opts.subjectNamesUsed)
        opts.subjectNamesUsed = opts.subjectOrder(opts.whichSubs);
    end
end