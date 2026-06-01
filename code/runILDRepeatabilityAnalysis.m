function results = runILDRepeatabilityAnalysis(subjectDataStruct, opts)

% runILDRepeatabilityAnalysis
%
% Example:
%   opts = struct();
%   opts.baseSubjectOrder = baseSubjectOrder;
%   opts.baseMapNames = baseMapNames;
%   opts.baseDTnames = baseDTnames;
%   opts.baseModelNames = baseModelNames;
%   results = runILDRepeatabilityAnalysis(subjectDataStruct, opts);

    if nargin < 2 || isempty(opts)
        opts = struct();
    end

    opts = fillDefaultOpts_runILDRepeatability(opts);

    % -------------------------
    % prepare inputs for runILDPlots
    % -------------------------
    plotOpts = struct();
    plotOpts.subjectOrder = opts.subjectOrder;
    plotOpts.baseSubjectOrder = opts.baseSubjectOrder;
    plotOpts.baseMapNames = opts.baseMapNames;
    plotOpts.baseDTnames = opts.baseDTnames;
    plotOpts.baseModelNames = opts.baseModelNames;
    plotOpts.modelNames = opts.modelNames;
    plotOpts.mapNames = opts.mapNames;
    plotOpts.hemispheres = opts.hemispheres;
    plotOpts.whichSubs = opts.whichSubs;
    plotOpts.whichModel = opts.whichModel;
    plotOpts.whichDT = opts.whichDT;
    plotOpts.veThresh = opts.veThresh_stats;
    plotOpts.whichPlots = opts.whichPlots;
    plotOpts.scale = opts.scale;

    % -------------------------
    % run ILDPlots
    % -------------------------
    statsAll = runILDPlots(subjectDataStruct, plotOpts);

    if isfield(statsAll, opts.scale)
        stats = statsAll.(opts.scale);
    else
        error('No stats found for scale "%s".', opts.scale);
    end

    if opts.closeAllAfterILDPlots
        close all;
    end

    % -------------------------
    % extract repeatability values
    % -------------------------
    nSub = numel(opts.whichSubs);
    nROIHemi = numel(opts.mapNames) * numel(opts.hemispheres);

    separateRValues = nan(nSub, nROIHemi);
    separatepValues = nan(nSub, nROIHemi);
    separatenValues = nan(nSub, nROIHemi);

    for i = 1:nSub
        thisSub = opts.whichSubs(i);

        if isempty(stats{thisSub})
            continue;
        end

        separateRValues(i, :) = stats{thisSub}.rILDOddEven(:)';
        separatepValues(i, :) = stats{thisSub}.pILDOddEven(:)';
        separatenValues(i, :) = stats{thisSub}.nsOddEven(:)';

        separateRValues_L(i, :) = stats{thisSub}.rILDOddEven([1:2:18])';
        separatepValues_L(i, :) = stats{thisSub}.pILDOddEven([1:2:18])';
        separatenValues_L(i, :) = stats{thisSub}.nsOddEven([1:2:18])';
        separateRValues_R(i, :) = stats{thisSub}.rILDOddEven([2:2:18])';
        separatepValues_R(i, :) = stats{thisSub}.pILDOddEven([2:2:18])';
        separatenValues_R(i, :) = stats{thisSub}.nsOddEven([2:2:18])';
    end

    % -------------------------
    % plotting
    % -------------------------
    violinOpts = opts.violinOpts;
    violinOpts.xlim = [1 numel(opts.mapNames_plot)];

    % plotILDRepeatabilityViolin_CollapseHemi( ...
    %     separateRValues, ...
    %     separatepValues, ...
    %     opts.mapNames_plot, ...
    %     violinOpts);

    plotILDRepeatabilityViolin_HalfHemi(separateRValues, separatepValues, opts.mapNames_plot, violinOpts)

    % -------------------------
    % pack outputs
    % -------------------------
    results = struct();
    results.statsAll = statsAll;
    results.stats = stats;
    results.separateRValues = separateRValues;
    results.separatepValues = separatepValues;
    results.separatenValues = separatenValues;
end