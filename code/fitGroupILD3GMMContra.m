function out_group = fitGroupILD3GMMContra(allData, opts)

    pref_split_contra = collectILDPrefContraSpace(allData, opts);

    fitOpts = struct();
    fitOpts.scale = opts.scale;
    fitOpts.balanceN = opts.balanceN;
    fitOpts.quickPlot = opts.quickPlot;
    fitOpts.quickPlot_groupGMM = opts.quickPlot_groupGMM;
    fitOpts.figname = opts.figname;
    fitOpts.figname2 = opts.figname2;
    fitOpts.doExport = opts.doExport;
    fitOpts.doExport_groupGMM = opts.doExport_groupGMM;
    fitOpts.contentType = opts.contentType;

    if strcmp(opts.scale,'lin')
        fitOpts.xRange = [-25 25];
    else
        fitOpts.xRange = [-4 4];
    end

    out_group = fit_ILD_3G_pipeline(pref_split_contra, opts.mapNames, fitOpts);
end