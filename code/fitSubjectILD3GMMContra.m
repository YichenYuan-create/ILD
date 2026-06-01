function res_subj = fitSubjectILD3GMMContra(allData, opts)

    pref_split_contra = collectILDPrefContraSpace(allData, opts);

    nSub = size(pref_split_contra,1);
    nROI = size(pref_split_contra,2);
    nHemi = size(pref_split_contra,3);

    res_subj = struct();
    res_subj.out_subj = cell(nSub,1);
    res_subj.weights = nan(nSub, nROI, nHemi, 3);

    for s = 1:nSub
        data_subj = squeeze(pref_split_contra(s,:,:));   % [nROI x nHemi]

        fitOpts = struct();
        fitOpts.scale = opts.scale;
        fitOpts.balanceN = opts.balanceN;
        fitOpts.quickPlot = opts.quickPlot;
        fitOpts.quickPlot_groupGMM = opts.quickPlot_groupGMM;
        fitOpts.figname = ['GMM_subj', num2str(s), '.pdf'];
        fitOpts.figname2 = ['GMM_allROI', num2str(s), '.pdf'];
        fitOpts.doExport = opts.doExport ;
        fitOpts.doExport_groupGMM = opts.doExport_groupGMM;
        fitOpts.contentType = opts.contentType;

        if strcmp(opts.scale,'lin')
            fitOpts.xRange = [-25 25];
        else
            fitOpts.xRange = [-4 4];
        end

        out = fit_ILD_3G_pipeline(data_subj, opts.mapNames, fitOpts);

        res_subj.out_subj{s} = out;
        res_subj.weights(s,:,:,:) = out.weights;   % [roi hemi comp]
    end
end