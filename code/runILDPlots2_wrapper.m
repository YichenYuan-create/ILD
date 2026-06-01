function stats_allptc = runILDPlots2_wrapper(subjectDataStruct, opts)

    subjectOrder = opts.subjectOrder;
    whichSubs    = opts.whichSubs;
    mapNames     = opts.mapNames;
    hemispheres  = opts.hemispheres;
    baseModelNames = opts.baseModelNames;
    modelNames   = opts.modelNames;
    whichModel   = opts.whichModel;
    whichDT      = opts.whichDT;
    DTnames      = opts.baseDTnames(whichDT);
    veThresh     = opts.veThresh;
    whichPlots   = opts.whichPlots;
    scale        = opts.scale;

    clear stats stats_allptc

    for i = 1:numel(subjectOrder)
        thisName = char(subjectOrder(i));
        if isfield(subjectDataStruct, thisName)
            eval([thisName ' = subjectDataStruct.(thisName);']);
        end
    end

    ILDPlots2;

    if ~exist('stats_allptc','var')
        error('ILDPlots2 did not create variable "stats_allptc".');
    end
end