function results = runILDRepeatabilityStats(rVals, subjectOrder, mapNames, opts)

% runILDRepeatabilityStats
%
% Inputs
%   rVals         : nSub x (2*nROI), e.g. 8 x 18
%   subjectOrder  : subject labels, length = nSub
%   mapNames      : ROI labels, length = nROI
%   opts          : optional struct
%
% Outputs
%   results       : struct containing LME, ANOVA, multcompare, signrank, etc.
%
% Example
%   opts = struct();
%   opts.doLME = true;
%   opts.doClassicalANOVA = true;
%   opts.doSignrank = true;
%   results = runILDRepeatabilityStats(rVals, subjectOrder, mapNames, opts);

    if nargin < 4 || isempty(opts)
        opts = struct();
    end

    opts = fillDefaultOpts_runILDRepeatabilityStats(opts);

    % -------------------------
    % basic size checks
    % -------------------------
    [nSub, nCols] = size(rVals);
    nROI = numel(mapNames);

    if nCols ~= 2 * nROI
        error('rVals must have size nSub x (2*nROI). Got %d columns, expected %d.', ...
            nCols, 2*nROI);
    end

    % if numel(subjectOrder) ~= nSub
    %     error('Length of subjectOrder (%d) must match number of rows in rVals (%d).', ...
    %         numel(subjectOrder), nSub);
    % end

    % -------------------------
    % reshape: nSub x hemi x ROI -> nSub x ROI x hemi
    % -------------------------
    rVals_tmp = reshape(rVals, nSub, 2, nROI);          % nSub x hemi x ROI
    rVals_statistic = permute(rVals_tmp, [1 3 2]);      % nSub x ROI x hemi
    [nSub, nROI, nHemi] = size(rVals_statistic);

    assert(nHemi == 2, 'Expecting 2 hemispheres.');

    % labels
    subjectLabels = repmat((1:nSub)', [1, nROI, nHemi]);
    mapLabels     = repmat(reshape(1:nROI, 1, nROI, 1), [nSub, 1, nHemi]);
    hemiLabels    = repmat(reshape(1:nHemi, 1, 1, nHemi), [nSub, nROI, 1]);

    % hemiNames = opts.hemiNames;
    % hemiLabelStr = hemiNames(hemiLabels(:))';

    results = struct();
    results.rVals_statistic = rVals_statistic;
    results.subjectLabels = subjectLabels;
    results.mapLabels = mapLabels;
    results.hemiLabels = hemiLabels;

    % =========================================================
    % 1) LME
    % =========================================================
    if opts.doLME
        data_lme = table( ...
            rVals_statistic(:), ...
            categorical(subjectLabels(:)), ...
            categorical(mapLabels(:)), ...
            'VariableNames', {'rVals_statistic','subject','map'});

        lmeFormula = 'rVals_statistic ~ map + (1|subject)';

        lme = fitlme(data_lme, ...
            lmeFormula, ...
            'DummyVarCoding', opts.DummyVarCoding, ...
            'FitMethod', opts.FitMethod);

        anova_stats = anova(lme, 'dfmethod', opts.dfmethod);

        F   = anova_stats.FStat;
        df1 = anova_stats.DF1;
        df2 = anova_stats.DF2;

        partial_eta2 = (F .* df1) ./ (F .* df1 + df2);
        anova_stats.partial_eta2 = partial_eta2;

        results.data_lme = data_lme;
        results.lme = lme;
        results.lmeFormula = lmeFormula;
        results.anova_stats = anova_stats;

        if opts.displayTables
            disp(anova_stats);
        end
    end

    % =========================================================
    % 2) Classical ANOVA
    % =========================================================
    if opts.doClassicalANOVA
        subjectLabelsStr = string(subjectOrder(subjectLabels(:)));
        mapNameLabels    = string(mapNames(mapLabels(:)));

        if opts.makeAnovaFigure
            figure;
        end

        [p_anovan, T, statsOut] = anovan(rVals_statistic(:), ...
            {mapNameLabels, subjectLabelsStr}, ...
            'varnames', {'map','subject'}, ...
            'display', opts.anovanDisplay);

        row_map   = find(strcmp(T(2:end,1), 'map')) + 1;
        row_error = find(strcmp(T(2:end,1), 'Error')) + 1;

        SS_map   = T{row_map,   2};
        df_map   = T{row_map,   3};
        MS_map   = T{row_map,   5};
        F_map    = T{row_map,   6};
        p_map    = T{row_map,   7};

        SS_error = T{row_error, 2};
        df_error = T{row_error, 3};
        MS_error = T{row_error, 5};

        partial_eta2_map = SS_map / (SS_map + SS_error);

        [multcomp, ~, ~, gnames] = multcompare(statsOut, ...
            'Dimension', 1, ...
            'Display', opts.multcompareDisplay);

        n_i = accumarray(grp2idx(categorical(mapNameLabels)), 1);
        MSE = MS_error;
        df  = df_error;

        q = zeros(size(multcomp,1),1);
        t_from_q = zeros(size(multcomp,1),1);
        d = zeros(size(multcomp,1),1);
        r = zeros(size(multcomp,1),1);

        for k = 1:size(multcomp,1)
            i = multcomp(k,1);
            j = multcomp(k,2);
            diff_ij = multcomp(k,4);

            SE = sqrt(MSE * (1/n_i(i) + 1/n_i(j)));
            q(k) = abs(diff_ij) / SE;
            t_from_q(k) = q(k) / sqrt(2);

            d(k) = diff_ij / sqrt(MSE);
            r(k) = t_from_q(k) / sqrt(t_from_q(k)^2 + df);
        end

        results.p_anovan = p_anovan;
        results.T = T;
        results.statsOut = statsOut;
        results.classical = struct( ...
            'SS_map', SS_map, ...
            'df_map', df_map, ...
            'MS_map', MS_map, ...
            'F_map', F_map, ...
            'p_map', p_map, ...
            'SS_error', SS_error, ...
            'df_error', df_error, ...
            'MS_error', MS_error, ...
            'partial_eta2_map', partial_eta2_map);

        results.multcomp = multcomp;
        results.gnames = gnames;
        results.pairwise = struct( ...
            'q', q, ...
            't_from_q', t_from_q, ...
            'd', d, ...
            'r', r, ...
            'df', df, ...
            'MSE', MSE, ...
            'n_i', n_i);
    end

    % =========================================================
    % 3) Signrank across collapsed hemispheres
    % =========================================================
    if opts.doSignrank
        rdata = nan(nSub * 2, nROI);

        for roiIdx = 1:nROI
            rdata(:, roiIdx) = [rVals(:, roiIdx*2 - 1); rVals(:, roiIdx*2)];
        end

        p_signrank2 = nan(1, nROI);
        z = nan(1, nROI);
        n_eff2 = nan(1, nROI);
        stats_t = cell(1, nROI);


        for roiIdx = 1:nROI
            thisData = rdata(:, roiIdx);

            [p_signrank2(roiIdx), ~, stats_t{roiIdx}] = signrank(thisData);

            if isfield(stats_t{roiIdx}, 'zval')
                z(roiIdx) = stats_t{roiIdx}.zval;
            else
                z(roiIdx) = NaN;
            end

            n_eff2(roiIdx) = sum(thisData ~= 0);
        end

        if opts.doFDR
            [~, ~, ~, adj_p2] = fdr_bh(p_signrank2);
        else
            adj_p2 = nan(size(p_signrank2));
        end
        r_effect2 = z ./ sqrt(n_eff2);

        [p_all2, ~,stats_allt] = signrank(rdata(:));
        zall = stats_allt.zval;
        n_effall2 = sum(rdata(:) ~= 0);
        r_effectall2 = zall ./ sqrt(n_effall2);

        results.signrank = struct( ...
            'rdata', rdata, ...
            'p_signrank', p_signrank2, ...
            'stats_t', {stats_t}, ...
            'z', z, ...
            'n_eff', n_eff2, ...
            'adj_p', adj_p2, ...
            'r_effect', r_effect2,...
            'p_all', p_all2, ...
            'zall', zall, ...
            'stats_tall', stats_allt,...
            'r_effectall', r_effectall2);
    end
end