function opts = fillDefaultOpts_runILDRepeatability(opts)

    % required fields
    requiredFields = {'baseSubjectOrder', 'baseMapNames', 'baseDTnames', 'baseModelNames'};
    for i = 1:numel(requiredFields)
        f = requiredFields{i};
        if ~isfield(opts, f) || isempty(opts.(f))
            error('opts.%s is required.', f);
        end
    end

    % defaults
    if ~isfield(opts, 'hemispheres') || isempty(opts.hemispheres)
        opts.hemispheres = {'Left', 'Right'};
    end

    % if ~isfield(opts, 'whichDT') || isempty(opts.whichDT)
    %     opts.whichDT = [1 2 3];
    % end
    % 
    % if ~isfield(opts, 'subjectOrder') || isempty(opts.subjectOrder)
    %     opts.subjectOrder = opts.baseSubjectOrder;
    % end

    % if ~isfield(opts, 'whichSubs') || isempty(opts.whichSubs)
    %     opts.whichSubs = 1:numel(opts.subjectOrder);
    % end

    % if ~isfield(opts, 'mapNames') || isempty(opts.mapNames)
    %     opts.mapNames = [opts.baseMapNames(1:2), ...
    %                      opts.baseMapNames(4), ...
    %                      opts.baseMapNames(3), ...
    %                      opts.baseMapNames(9), ...
    %                      opts.baseMapNames(5), ...
    %                      opts.baseMapNames(6:8)];
    % end
    % 
    % if ~isfield(opts, 'modelNames') || isempty(opts.modelNames)
    %     opts.modelNames = opts.baseModelNames;
    % end

    % if ~isfield(opts, 'whichModel') || isempty(opts.whichModel)
    %     opts.whichModel = 5;
    % end

    % if ~isfield(opts, 'scale') || isempty(opts.scale)
    %     opts.scale = 'lin';
    % end

    % if ~isfield(opts, 'whichPlots') || isempty(opts.whichPlots)
    %     opts.whichPlots = [0 0 0 0 0 0 0];
    % end

    % veThresh used when computing stats
    % if ~isfield(opts, 'veThresh_stats') || isempty(opts.veThresh_stats)
    %     opts.veThresh_stats = 0.1;
    % end

    if ~isfield(opts, 'closeAllAfterILDPlots') || isempty(opts.closeAllAfterILDPlots)
        opts.closeAllAfterILDPlots = true;
    end

    % if ~isfield(opts, 'mapNames_plot') || isempty(opts.mapNames_plot)
    %     opts.mapNames_plot = ["Auditory cortex", ...
    %                           "Supramarginal gyrus", ...
    %                           "Angular gyrus", ...
    %                           "Postcentral gyrus", ...
    %                           "Precuneus", ...
    %                           "Middle frontal gyrus", ...
    %                           "pars orbitalis", ...
    %                           "Pars opercularis", ...
    %                           "Anterior cingulate cortex"];
    % end

    % violin plot options
    if ~isfield(opts, 'violinOpts') || isempty(opts.violinOpts)
        violinOpts = struct();
    else
        violinOpts = opts.violinOpts;
    end

    if ~isfield(violinOpts, 'doExport')
        violinOpts.doExport = true;
    end
    if ~isfield(violinOpts, 'figname')
        violinOpts.figname = 'repeatability_r_ve0.1.pdf';
    end
    if ~isfield(violinOpts, 'contentType')
        violinOpts.contentType = 'vector';
    end
    if ~isfield(violinOpts, 'xstep')
        violinOpts.xstep = 1;
    end
    if ~isfield(violinOpts, 'ylim')
        violinOpts.ylim = [-1 1];
    end
    if ~isfield(violinOpts, 'ystep')
        violinOpts.ystep = 5;
    end
    if ~isfield(violinOpts, 'plotyequal0')
        violinOpts.plotyequal0 = true;
    end

    opts.violinOpts = violinOpts;
end