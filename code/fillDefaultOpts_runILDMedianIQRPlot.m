function opts = fillDefaultOpts_runILDMedianIQRPlot(opts)

    requiredFields = {'baseMapNames', 'baseDTnames', 'baseModelNames'};
    for i = 1:numel(requiredFields)
        f = requiredFields{i};
        if ~isfield(opts, f) || isempty(opts.(f))
            error('opts.%s is required.', f);
        end
    end

    if ~isfield(opts, 'whichSub') || isempty(opts.whichSub)
        error('opts.whichSub is required.');
    end

    if ~isfield(opts, 'hemispheres') || isempty(opts.hemispheres)
        opts.hemispheres = {'Left', 'Right'};
    end

    if ~isfield(opts, 'mapNames') || isempty(opts.mapNames)
        opts.mapNames = [opts.baseMapNames(1:2), ...
                         opts.baseMapNames(4), ...
                         opts.baseMapNames(3), ...
                         opts.baseMapNames(9), ...
                         opts.baseMapNames(5), ...
                         opts.baseMapNames(6:8)];
    end

    % if ~isfield(opts, 'renamePC') || isempty(opts.renamePC)
    %     opts.renamePC = true;
    % end
    % if opts.renamePC
    %     opts.mapNames(5) = "PC";
    % end
    if ~isfield(opts, 'metricToPlot') || isempty(opts.metricToPlot)
        opts.metricToPlot = 'median';
    end

    if ~isfield(opts, 'flipRightHemisphere') || isempty(opts.flipRightHemisphere)
        if strcmpi(opts.metricToPlot, 'median')
            opts.flipRightHemisphere = true;
        else
            opts.flipRightHemisphere = false;
        end
    end

    if ~isfield(opts, 'doPlot') || isempty(opts.doPlot)
        opts.doPlot = true;
    end
    
    if ~isfield(opts, 'whichModel') || isempty(opts.whichModel)
        opts.whichModel = 5;
    end

    % if ~isfield(opts, 'whichDT_all') || isempty(opts.whichDT_all)
    %     opts.whichDT_all = [1 2 3];
    % end

    if ~isfield(opts, 'whichDT_plot') || isempty(opts.whichDT_plot)
        opts.whichDT_plot = 1;
    end

    if ~isfield(opts, 'veThresh') || isempty(opts.veThresh)
        opts.veThresh = 0.2;
    end

    if ~isfield(opts, 'scale') || isempty(opts.scale)
        opts.scale = 'lin';
    end

    if ~isfield(opts, 'Range') || isempty(opts.Range)
        opts.Range = [-20 20];
    end

    if ~isfield(opts, 'EdgeThr') || isempty(opts.EdgeThr)
        opts.EdgeThr = 19;
    end

    if ~isfield(opts, 'BinWidth') || isempty(opts.BinWidth)
        opts.BinWidth = 1;
    end

    if ~isfield(opts, 'cols') || isempty(opts.cols)
        opts.cols = [ ...
            0.894 0.102 0.110
            0.216 0.494 0.722
            0.302 0.686 0.290
            0.596 0.306 0.639
            1.000 0.498 0.000
            1.000 0.749 0.000
            0.651 0.337 0.157
            0.969 0.506 0.749
            0.200 0.200 0.200];
    end

    if ~isfield(opts, 'mapNames_plot') || isempty(opts.mapNames_plot)
        opts.mapNames_plot = ["Auditory cortex", ...
                              "Supramarginal gyrus", ...
                              "Angular gyrus", ...
                              "Postcentral gyrus", ...
                              "Precuneus", ...
                              "Middle frontal gyrus", ...
                              "Inferior frontal gyrus anterior", ...
                              "Inferior frontal gyrus posterior", ...
                              "Anterior cingulate cortex"];
    end

    if ~isfield(opts, 'plotOpts') || isempty(opts.plotOpts)
        plotOpts = struct();
    else
        plotOpts = opts.plotOpts;
    end

    if ~isfield(plotOpts, 'doExport')
        plotOpts.doExport = true;
    end
    if ~isfield(plotOpts, 'figname')
        plotOpts.figname = 'median.pdf';
    end
    if ~isfield(plotOpts, 'contentType')
        plotOpts.contentType = 'vector';
    end
    if ~isfield(plotOpts, 'xstep')
        plotOpts.xstep = 1;
    end
    if ~isfield(plotOpts, 'ylim')
        plotOpts.ylim = [-20 20];
    end
    if ~isfield(plotOpts, 'ystep')
        plotOpts.ystep = 5;
    end
    if ~isfield(plotOpts, 'plotyequal0')
        plotOpts.plotyequal0 = true;
    end

    opts.plotOpts = plotOpts;
end