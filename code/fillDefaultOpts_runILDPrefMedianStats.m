function opts = fillDefaultOpts_runILDPrefMedianStats(opts)

    if ~isfield(opts, 'doLME') || isempty(opts.doLME)
        opts.doLME = true;
    end

    if ~isfield(opts, 'includeHemisphereInLME') || isempty(opts.includeHemisphereInLME)
        opts.includeHemisphereInLME = false;
    end

    if ~isfield(opts, 'doClassicalANOVA') || isempty(opts.doClassicalANOVA)
        opts.doClassicalANOVA = true;
    end

    if ~isfield(opts, 'includeHemisphereInClassicalANOVA') || isempty(opts.includeHemisphereInClassicalANOVA)
        opts.includeHemisphereInClassicalANOVA = false;
    end

    if ~isfield(opts, 'doSignrank') || isempty(opts.doSignrank)
        opts.doSignrank = true;
    end

    if ~isfield(opts, 'doFDR') || isempty(opts.doFDR)
        opts.doFDR = true;
    end

    if ~isfield(opts, 'hemiNames') || isempty(opts.hemiNames)
        opts.hemiNames = {'L','R'};
    end

    if ~isfield(opts, 'DummyVarCoding') || isempty(opts.DummyVarCoding)
        opts.DummyVarCoding = 'effects';
    end

    if ~isfield(opts, 'FitMethod') || isempty(opts.FitMethod)
        opts.FitMethod = 'reml';
    end

    if ~isfield(opts, 'dfmethod') || isempty(opts.dfmethod)
        opts.dfmethod = 'satterthwaite';
    end

    if ~isfield(opts, 'displayTables') || isempty(opts.displayTables)
        opts.displayTables = true;
    end

    if ~isfield(opts, 'makeAnovaFigure') || isempty(opts.makeAnovaFigure)
        opts.makeAnovaFigure = true;
    end

    if ~isfield(opts, 'anovanDisplay') || isempty(opts.anovanDisplay)
        opts.anovanDisplay = 'on';
    end

    if ~isfield(opts, 'multcompareDisplay') || isempty(opts.multcompareDisplay)
        opts.multcompareDisplay = 'on';
    end
end