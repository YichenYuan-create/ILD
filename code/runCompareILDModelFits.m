function ModelCompareResults = runCompareILDModelFits(allData, opts)

% -------------------------
% condition-specific settings
% -------------------------
[whichSubs, dtsPerSub, veThresh, ~] = getConditionSettings(opts.condition);

dtsPerSub    = dtsPerSub(whichSubs);
subjectOrder = opts.baseSubjectOrder(whichSubs);
dataType     = opts.baseDTnames(dtsPerSub);


% -------------------------
% select ROIs
% -------------------------
if opts.includeAC
    selectedMapNames = opts.mapNames;
else
    selectedMapNames = opts.mapNames(2:end);
end

if opts.expfig
    opts.doExport=true;
else
    opts.doExport=false;
end
% -------------------------
% select models
% -------------------------
modelNames = opts.baseModelNames(opts.modelIdx);
ModelNamesFig = opts.ModelNamesFig;

% -------------------------
% run comparison
% -------------------------
ModelCompareResults = CompareILDModelFits2( ...
    allData, ...
    cellstr(subjectOrder), ...
    cellstr(selectedMapNames), ...
    opts.hemispheres, ...
    cellstr(modelNames), ...
    cellstr(opts.baseDTnames), ...
    dtsPerSub, ...
    veThresh, ...
    ModelNamesFig, ...
    opts);

end
