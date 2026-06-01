function opts = fillDefaultOpts_collectILDPrefContraSpace(opts)

    if ~isfield(opts,'hemispheres') || isempty(opts.hemispheres)
        opts.hemispheres = {'Left','Right'};
    end

    if ~isfield(opts,'subjectLevel') || isempty(opts.subjectLevel)
        opts.subjectLevel = false;
    end

    if ~isfield(opts,'whichSubGroup') || isempty(opts.whichSubGroup)
        opts.whichSubGroup = "dataAllSub";
    end
end