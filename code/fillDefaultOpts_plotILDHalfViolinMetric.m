function opts = fillDefaultOpts_plotILDHalfViolinMetric(opts, dataL, mapNames_plot)

    [~, nROI] = size(dataL);

    if ~isfield(opts, 'doExport') || isempty(opts.doExport)
        opts.doExport = true;
    end

    if ~isfield(opts, 'figname') || isempty(opts.figname)
        opts.figname = 'halfviolin.pdf';
    end

    if ~isfield(opts, 'contentType') || isempty(opts.contentType)
        opts.contentType = 'vector';
    end

    if ~isfield(opts, 'xlim') || isempty(opts.xlim)
        opts.xlim = [1 nROI];
    end

    if ~isfield(opts, 'xstep') || isempty(opts.xstep)
        opts.xstep = 1;
    end

    if ~isfield(opts, 'ylim') || isempty(opts.ylim)
        opts.ylim = [min(dataL(:),[],'omitnan') max(dataL(:),[],'omitnan')];
    end

    if ~isfield(opts, 'ystep') || isempty(opts.ystep)
        opts.ystep = 5;
    end

    if ~isfield(opts, 'plotyequal0') || isempty(opts.plotyequal0)
        opts.plotyequal0 = false;
    end
end