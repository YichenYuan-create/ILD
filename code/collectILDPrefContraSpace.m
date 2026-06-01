function pref_split_contra = collectILDPrefContraSpace(allData, opts)

% Output:
%   pref_split_contra{sub, roi, hemi}   for subject-level
%   or
%   pref_split_contra{roi, hemi}        for group-level

    opts = fillDefaultOpts_collectILDPrefContraSpace(opts);

    if opts.subjectLevel
        pref_raw = getAllILDpref_subjectlevel( ...
            allData, ...
            opts.whichSub, ...
            opts.mapNames, ...
            opts.hemispheres, ...
            opts.baseModelNames, ...
            opts.whichModel, ...
            opts.baseDTnames, ...
            opts.whichDT, ...
            opts.veThresh, ...
            opts.scale,...
            opts.condition);

        nSub = size(pref_raw,1);
        nROI = size(pref_raw,2);
        nHemi = size(pref_raw,3);

        pref_split_contra = cell(nSub, nROI, nHemi);

        for s = 1:nSub
            for r = 1:nROI
                for h = 1:nHemi
                    x = pref_raw{s,r,h};
                    if isempty(x)
                        pref_split_contra{s,r,h} = [];
                        continue;
                    end

                    if opts.signreverse && h == 2   % Right hemisphere -> sign flip
                        x = -x;
                    end

                    pref_split_contra{s,r,h} = x(:);
                end
            end
        end

    else
        pref_raw = getAllILDpref( ...
            allData, ...
            opts.whichSubGroup, ...
            opts.mapNames, ...
            opts.hemispheres, ...
            opts.baseModelNames, ...
            opts.whichModel, ...
            opts.baseDTnames, ...
            opts.whichDT, ...
            opts.veThresh, ...
            opts.scale);

        nROI = size(pref_raw,1);
        nHemi = size(pref_raw,2);

        pref_split_contra = cell(nROI, nHemi);

        for r = 1:nROI
            for h = 1:nHemi
                x = pref_raw{r,h};
                if isempty(x)
                    pref_split_contra{r,h} = [];
                    continue;
                end

                if opts.signreverse && h == 2
                    x = -x;
                end

                pref_split_contra{r,h} = x(:);
            end
        end
    end
end